import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/subscription_details.dart';
import '../../domain/entities/subscription_transaction.dart';
import '../../infrastructure/datasources/subscription_remote_data_source.dart';
import '../../infrastructure/database/app_database.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRemoteDataSource _remoteDataSource;

  SubscriptionBloc({SubscriptionRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? SubscriptionRemoteDataSourceImpl(),
        super(SubscriptionInitial()) {
    on<LoadSubscriptionEvent>(_onLoadSubscription);
    on<CheckTrialReminderEvent>(_onCheckTrialReminder);
    on<DismissTrialPopupEvent>(_onDismissTrialPopup);
    on<PurchasePlanEvent>(_onPurchasePlan);
    on<CancelSubscriptionEvent>(_onCancelSubscription);
    on<StartReTrialEvent>(_onStartReTrial);
  }

  Future<void> _onLoadSubscription(
    LoadSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());

    SubscriptionDetails? details;
    List<SubscriptionTransaction> transactions = [];

    // 1. Try fetching from Supabase
    try {
      details = await _remoteDataSource.fetchSubscriptionDetails(event.userId);
      transactions = await _remoteDataSource.fetchTransactions(event.userId);
    } catch (_) {}

    // 2. Fallback to local AppDatabase cache or create default 7-day trial
    if (details == null) {
      details = AppDatabase.instance.subscriptionDetails;
      transactions = AppDatabase.instance.subscriptionTransactions;
    }

    if (details == null) {
      final initial = SubscriptionDetails.initialForUser(event.userId, businessId: event.businessId);
      try {
        details = await _remoteDataSource.upsertSubscriptionDetails(initial);
      } catch (_) {
        details = initial;
      }
    }

    final activeDetails = details;

    await AppDatabase.instance.saveSubscriptionDetails(activeDetails);
    await AppDatabase.instance.saveSubscriptionTransactions(transactions);

    final bool shouldPopup = activeDetails.shouldShowReminderPopup;

    emit(SubscriptionLoaded(
      details: activeDetails,
      transactions: transactions,
      showTrialPopup: shouldPopup,
    ));
  }

  Future<void> _onCheckTrialReminder(
    CheckTrialReminderEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    if (state is SubscriptionLoaded) {
      final current = (state as SubscriptionLoaded);
      final shouldShow = current.details.shouldShowReminderPopup;
      if (shouldShow != current.showTrialPopup) {
        emit(current.copyWith(showTrialPopup: shouldShow));
      }
    }
  }

  Future<void> _onDismissTrialPopup(
    DismissTrialPopupEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    if (state is SubscriptionLoaded) {
      final current = (state as SubscriptionLoaded);
      final updatedDetails = current.details.copyWith(
        lastReminderTimestamp: DateTime.now(),
      );

      await AppDatabase.instance.saveSubscriptionDetails(updatedDetails);
      try {
        await _remoteDataSource.upsertSubscriptionDetails(updatedDetails);
      } catch (_) {}

      emit(current.copyWith(
        details: updatedDetails,
        showTrialPopup: false,
      ));
    }
  }

  Future<void> _onPurchasePlan(
    PurchasePlanEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    if (state is SubscriptionLoaded) {
      final current = (state as SubscriptionLoaded);
      final now = DateTime.now();
      final isYearly = event.planName.toLowerCase().contains('yearly');
      final duration = isYearly ? const Duration(days: 365) : const Duration(days: 30);

      final updatedDetails = current.details.copyWith(
        status: SubscriptionStatus.subscriptionActive,
        planName: event.planName,
        subscriptionStartDate: now,
        subscriptionEndDate: now.add(duration),
        paymentMethod: event.paymentMethod,
        paymentStatus: 'Active Paid Plan',
        lastReminderTimestamp: now,
      );

      final newTransaction = SubscriptionTransaction(
        id: const Uuid().v4(),
        userId: current.details.userId,
        date: now,
        planName: event.planName,
        amount: event.amount,
        status: 'Paid',
        paymentMethod: event.paymentMethod,
      );

      final updatedTransactions = [newTransaction, ...current.transactions];

      await AppDatabase.instance.saveSubscriptionDetails(updatedDetails);
      await AppDatabase.instance.saveSubscriptionTransactions(updatedTransactions);

      try {
        await _remoteDataSource.upsertSubscriptionDetails(updatedDetails);
        await _remoteDataSource.recordTransaction(newTransaction);
      } catch (_) {}

      emit(SubscriptionLoaded(
        details: updatedDetails,
        transactions: updatedTransactions,
        showTrialPopup: false,
      ));
    }
  }

  Future<void> _onCancelSubscription(
    CancelSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    if (state is SubscriptionLoaded) {
      final current = (state as SubscriptionLoaded);
      final updatedDetails = current.details.copyWith(
        status: SubscriptionStatus.demoMode,
        planName: 'Demo Mode',
        paymentStatus: 'Cancelled',
      );

      await AppDatabase.instance.saveSubscriptionDetails(updatedDetails);
      try {
        await _remoteDataSource.upsertSubscriptionDetails(updatedDetails);
      } catch (_) {}

      emit(current.copyWith(
        details: updatedDetails,
        showTrialPopup: false,
      ));
    }
  }

  Future<void> _onStartReTrial(
    StartReTrialEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    if (state is SubscriptionLoaded) {
      final current = (state as SubscriptionLoaded);
      final now = DateTime.now();
      final updatedDetails = current.details.copyWith(
        status: SubscriptionStatus.retrialActive,
        planName: '7-Day Re-Trial',
        trialStartDate: now,
        trialEndDate: now.add(const Duration(days: 7)),
        trialCount: current.details.trialCount + 1,
        lastReminderTimestamp: now,
      );

      await AppDatabase.instance.saveSubscriptionDetails(updatedDetails);
      try {
        await _remoteDataSource.upsertSubscriptionDetails(updatedDetails);
      } catch (_) {}

      emit(current.copyWith(
        details: updatedDetails,
        showTrialPopup: false,
      ));
    }
  }
}
