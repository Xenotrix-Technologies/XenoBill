import 'package:equatable/equatable.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubscriptionEvent extends SubscriptionEvent {
  final String userId;
  final String? businessId;

  const LoadSubscriptionEvent({required this.userId, this.businessId});

  @override
  List<Object?> get props => [userId, businessId];
}

class CheckTrialReminderEvent extends SubscriptionEvent {}

class DismissTrialPopupEvent extends SubscriptionEvent {}

class PurchasePlanEvent extends SubscriptionEvent {
  final String planName; // 'Monthly Pro', 'Yearly Pro'
  final double amount;
  final String paymentMethod; // 'UPI', 'Credit Card', 'Netbanking'
  final String? billingCycle; // 'monthly', 'yearly'
  final String? planId;

  const PurchasePlanEvent({
    required this.planName,
    required this.amount,
    required this.paymentMethod,
    this.billingCycle,
    this.planId,
  });

  @override
  List<Object?> get props => [planName, amount, paymentMethod, billingCycle, planId];
}

class CancelSubscriptionEvent extends SubscriptionEvent {}

class StartReTrialEvent extends SubscriptionEvent {}
