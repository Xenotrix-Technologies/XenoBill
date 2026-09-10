import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription_details.dart';
import '../../domain/entities/subscription_transaction.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final SubscriptionDetails details;
  final List<SubscriptionTransaction> transactions;
  final bool showTrialPopup;

  const SubscriptionLoaded({
    required this.details,
    this.transactions = const [],
    this.showTrialPopup = false,
  });

  bool get isRestricted => details.status.isRestricted;
  int get remainingTrialDays => details.remainingTrialDays;

  SubscriptionLoaded copyWith({
    SubscriptionDetails? details,
    List<SubscriptionTransaction>? transactions,
    bool? showTrialPopup,
  }) {
    return SubscriptionLoaded(
      details: details ?? this.details,
      transactions: transactions ?? this.transactions,
      showTrialPopup: showTrialPopup ?? this.showTrialPopup,
    );
  }

  @override
  List<Object?> get props => [details, transactions, showTrialPopup];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
