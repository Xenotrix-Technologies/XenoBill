import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/subscription_details.dart';
import '../../domain/entities/subscription_transaction.dart';
import '../../infrastructure/database/app_database.dart';
import '../../infrastructure/supabase/supabase_client.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionInitial()) {
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

    SubscriptionDetails? details = AppDatabase.instance.subscriptionDetails;
    List<SubscriptionTransaction> transactions =
        AppDatabase.instance.subscriptionTransactions;

    details ??= SubscriptionDetails.initialForUser(event.userId,
        businessId: event.businessId);

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
    log(event.paymentMethod);
    if (state is SubscriptionLoaded) {
      final current = (state as SubscriptionLoaded);
      final now = DateTime.now();
      final isYearly = event.planName.toLowerCase().contains('yearly');
      final duration =
          isYearly ? const Duration(days: 365) : const Duration(days: 30);

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
        businessId: AppDatabase.instance.currentBusiness?.id ??
            current.details.businessId ??
            current.details.userId,
        date: now,
        planName: event.planName,
        amount: event.amount,
        status: 'Paid',
        paymentMethod: event.paymentMethod,
      );

      final updatedTransactions = [newTransaction, ...current.transactions];

      await AppDatabase.instance.saveSubscriptionDetails(updatedDetails);
      await AppDatabase.instance
          .saveSubscriptionTransactions(updatedTransactions);

      try {
        final client = SupabaseClientManager.instance.client;
        final user = client.auth.currentUser;
        if (user != null) {
          final planPayload = updatedDetails.toBusinessPlanJson(
            companyName: AppDatabase.instance.currentBusiness?.name,
          );
          planPayload['current_plan_price'] = event.amount;
          planPayload['billing_cycle'] =
              duration.inDays == 365 ? 'yearly' : 'monthly';
          String? formattedGateway;
          final pmLower = event.paymentMethod.toLowerCase().trim();
          if (pmLower.contains('razorpay')) {
            formattedGateway = 'razorpay';
          } else if (pmLower.contains('cashfree')) {
            formattedGateway = 'cashfree';
          } else if (pmLower.contains('manual')) {
            formattedGateway = 'manual';
          } else if (['razorpay', 'cashfree', 'manual'].contains(pmLower)) {
            formattedGateway = pmLower;
          }

          planPayload['gateway'] = formattedGateway;
          planPayload['is_demo_user'] = false;
          planPayload['subscription_status'] = 'active';
          planPayload['demo_status'] = 'cancelled';

          try {
            await client
                .from('business_plans')
                .upsert(planPayload, onConflict: 'user_id');
          } catch (_) {}
        }
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

      emit(current.copyWith(
        details: updatedDetails,
        showTrialPopup: false,
      ));
    }
  }
}
