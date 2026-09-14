import 'package:equatable/equatable.dart';

enum SubscriptionStatus {
  newUser,
  trialActive,
  trialExpired,
  demoMode,
  subscriptionActive,
  subscriptionExpired,
  retrialEligible,
  retrialActive,
  retrialExpired,
}

extension SubscriptionStatusX on SubscriptionStatus {
  String get displayName {
    switch (this) {
      case SubscriptionStatus.newUser:
        return 'New User';
      case SubscriptionStatus.trialActive:
        return 'Free Trial Active';
      case SubscriptionStatus.trialExpired:
        return 'Trial Expired';
      case SubscriptionStatus.demoMode:
        return 'Demo Mode';
      case SubscriptionStatus.subscriptionActive:
        return 'Pro Active';
      case SubscriptionStatus.subscriptionExpired:
        return 'Subscription Expired';
      case SubscriptionStatus.retrialEligible:
        return 'Re-Trial Available';
      case SubscriptionStatus.retrialActive:
        return 'Re-Trial Active';
      case SubscriptionStatus.retrialExpired:
        return 'Re-Trial Expired';
    }
  }

  bool get isRestricted {
    return this == SubscriptionStatus.trialExpired ||
        this == SubscriptionStatus.demoMode ||
        this == SubscriptionStatus.subscriptionExpired ||
        this == SubscriptionStatus.retrialExpired;
  }
}

class SubscriptionDetails extends Equatable {
  final String userId;
  final String? businessId;
  final SubscriptionStatus status;
  final String planName; // e.g. "Free Trial", "Xenobill Pro Monthly", "Xenobill Pro Yearly", "Demo Mode"
  final DateTime trialStartDate;
  final DateTime trialEndDate;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final DateTime? lastReminderTimestamp;
  final DateTime? lastActiveDate;
  final int trialCount;
  final String paymentMethod;
  final String paymentStatus;

  const SubscriptionDetails({
    required this.userId,
    this.businessId,
    required this.status,
    required this.planName,
    required this.trialStartDate,
    required this.trialEndDate,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.lastReminderTimestamp,
    this.lastActiveDate,
    this.trialCount = 1,
    this.paymentMethod = 'None',
    this.paymentStatus = 'Free Trial',
  });

  /// Calculates remaining trial days based on current system time
  int get remainingTrialDays {
    final now = DateTime.now();
    if (now.isAfter(trialEndDate)) return 0;
    final diff = trialEndDate.difference(now).inDays;
    return diff < 0 ? 0 : diff + 1;
  }

  /// Calculates total trial duration in days
  int get totalTrialDays {
    final diff = trialEndDate.difference(trialStartDate).inDays;
    return diff <= 0 ? 30 : diff;
  }

  /// Checks if 5+ hours have elapsed since last reminder modal popup dismissal
  bool get shouldShowReminderPopup {
    if (status.isRestricted) return true;
    if (status != SubscriptionStatus.trialActive &&
        status != SubscriptionStatus.retrialActive &&
        status != SubscriptionStatus.retrialEligible) {
      return false;
    }
    if (lastReminderTimestamp == null) return true;
    final hoursSinceLastReminder = DateTime.now().difference(lastReminderTimestamp!).inHours;
    return hoursSinceLastReminder >= 5;
  }

  SubscriptionDetails copyWith({
    String? userId,
    String? businessId,
    SubscriptionStatus? status,
    String? planName,
    DateTime? trialStartDate,
    DateTime? trialEndDate,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    DateTime? lastReminderTimestamp,
    DateTime? lastActiveDate,
    int? trialCount,
    String? paymentMethod,
    String? paymentStatus,
  }) {
    return SubscriptionDetails(
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      status: status ?? this.status,
      planName: planName ?? this.planName,
      trialStartDate: trialStartDate ?? this.trialStartDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      subscriptionStartDate: subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      lastReminderTimestamp: lastReminderTimestamp ?? this.lastReminderTimestamp,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      trialCount: trialCount ?? this.trialCount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  factory SubscriptionDetails.initialForUser(String userId, {String? businessId}) {
    final now = DateTime.now();
    return SubscriptionDetails(
      userId: userId,
      businessId: businessId,
      status: SubscriptionStatus.trialActive,
      planName: 'Free Trial',
      trialStartDate: now,
      trialEndDate: now.add(const Duration(days: 30)),
      lastReminderTimestamp: null,
      lastActiveDate: now,
      trialCount: 1,
      paymentMethod: 'None',
      paymentStatus: 'Active Trial',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'business_id': businessId,
      'status': status.name,
      'plan_name': planName,
      'trial_start_date': trialStartDate.toIso8601String(),
      'trial_end_date': trialEndDate.toIso8601String(),
      'subscription_start_date': subscriptionStartDate?.toIso8601String(),
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
      'last_reminder_timestamp': lastReminderTimestamp?.toIso8601String(),
      'trial_count': trialCount,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
    };
  }

  factory SubscriptionDetails.fromBusinessPlanJson(
    Map<String, dynamic> json, {
    DateTime? existingLastReminderTimestamp,
  }) {
    final now = DateTime.now();
    final isDemo = json['is_demo_user'] == true || json['subscription_status'] == 'demo';
    final subStatusStr = json['subscription_status']?.toString().toLowerCase() ?? 'demo';
    final demoStatusStr = json['demo_status']?.toString().toLowerCase() ?? 'active';

    final demoStart = json['demo_start_at'] != null ? DateTime.tryParse(json['demo_start_at'].toString()) ?? now : now;
    final demoEnd = json['demo_end_at'] != null ? DateTime.tryParse(json['demo_end_at'].toString()) ?? now.add(const Duration(days: 30)) : now.add(const Duration(days: 30));
    final startDate = json['start_date'] != null ? DateTime.tryParse(json['start_date'].toString()) : null;
    final dueDate = json['due_date'] != null ? DateTime.tryParse(json['due_date'].toString()) : null;

    SubscriptionStatus computedStatus;
    if (isDemo) {
      if (demoStatusStr == 'expired' || now.isAfter(demoEnd)) {
        computedStatus = SubscriptionStatus.trialExpired;
      } else {
        computedStatus = SubscriptionStatus.trialActive;
      }
    } else if (subStatusStr == 'active' || subStatusStr == 'paid') {
      if (dueDate != null && now.isAfter(dueDate)) {
        computedStatus = SubscriptionStatus.subscriptionExpired;
      } else {
        computedStatus = SubscriptionStatus.subscriptionActive;
      }
    } else if (subStatusStr == 'expired') {
      computedStatus = SubscriptionStatus.subscriptionExpired;
    } else {
      computedStatus = SubscriptionStatus.trialActive;
    }

    return SubscriptionDetails(
      userId: json['user_id']?.toString() ?? '',
      businessId: json['plan_id']?.toString(),
      status: computedStatus,
      planName: json['plan_name']?.toString() ?? (isDemo ? 'Demo Plan' : 'Pro Plan'),
      trialStartDate: demoStart,
      trialEndDate: demoEnd,
      subscriptionStartDate: startDate,
      subscriptionEndDate: dueDate,
      lastReminderTimestamp: existingLastReminderTimestamp,
      lastActiveDate: now,
      trialCount: 1,
      paymentMethod: json['gateway']?.toString() ?? json['subscription_source']?.toString() ?? 'None',
      paymentStatus: json['subscription_status']?.toString() ?? 'Active',
    );
  }

  Map<String, dynamic> toBusinessPlanJson({String? companyName}) {
    final isDemo = status == SubscriptionStatus.demoMode || status == SubscriptionStatus.trialActive || status == SubscriptionStatus.trialExpired;
    final isPaid = status == SubscriptionStatus.subscriptionActive;

    return {
      'user_id': userId,
      'plan_name': planName,
      'company_name': companyName,
      'is_demo_user': isDemo,
      'demo_status': status == SubscriptionStatus.trialExpired ? 'expired' : 'active',
      'demo_start_at': trialStartDate.toIso8601String(),
      'demo_end_at': trialEndDate.toIso8601String(),
      'subscription_status': isPaid ? 'active' : (status == SubscriptionStatus.trialExpired ? 'expired' : 'demo'),
      'purchase_date': subscriptionStartDate?.toIso8601String(),
      'start_date': subscriptionStartDate?.toIso8601String() ?? trialStartDate.toIso8601String(),
      'due_date': subscriptionEndDate?.toIso8601String() ?? trialEndDate.toIso8601String(),
      'auto_renew': false,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    SubscriptionStatus parseStatus(String? val) {
      if (val == null) return SubscriptionStatus.trialActive;
      try {
        return SubscriptionStatus.values.firstWhere((e) => e.name == val);
      } catch (_) {
        return SubscriptionStatus.trialActive;
      }
    }

    DateTime parseDate(dynamic val, DateTime fallback) {
      if (val == null) return fallback;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return fallback;
      }
    }

    final now = DateTime.now();
    final trialStart = parseDate(json['trial_start_date'] ?? json['start_date'] ?? json['started_at'], now);
    final trialEnd = parseDate(json['trial_end_date'] ?? json['expiry_date'] ?? json['subscription_end_date'], now.add(const Duration(days: 30)));

    SubscriptionStatus rawStatus = parseStatus(json['status']?.toString());
    
    // Evaluate status dynamically if trial duration passed
    if ((rawStatus == SubscriptionStatus.trialActive || rawStatus == SubscriptionStatus.retrialActive) &&
        now.isAfter(trialEnd)) {
      rawStatus = SubscriptionStatus.trialExpired;
    }

    return SubscriptionDetails(
      userId: json['user_id']?.toString() ?? '',
      businessId: json['business_id']?.toString(),
      status: rawStatus,
      planName: json['plan_name']?.toString() ?? 'Free Trial',
      trialStartDate: trialStart,
      trialEndDate: trialEnd,
      subscriptionStartDate: json['subscription_start_date'] != null
          ? DateTime.tryParse(json['subscription_start_date'].toString())
          : null,
      subscriptionEndDate: json['subscription_end_date'] != null
          ? DateTime.tryParse(json['subscription_end_date'].toString())
          : null,
      lastReminderTimestamp: json['last_reminder_timestamp'] != null
          ? DateTime.tryParse(json['last_reminder_timestamp'].toString())
          : null,
      lastActiveDate: json['last_active_date'] != null
          ? DateTime.tryParse(json['last_active_date'].toString())
          : now,
      trialCount: (json['trial_count'] as num?)?.toInt() ?? 1,
      paymentMethod: json['payment_method']?.toString() ?? 'None',
      paymentStatus: json['payment_status']?.toString() ?? 'Active',
    );
  }

  @override
  List<Object?> get props => [
        userId,
        businessId,
        status,
        planName,
        trialStartDate,
        trialEndDate,
        subscriptionStartDate,
        subscriptionEndDate,
        lastReminderTimestamp,
        lastActiveDate,
        trialCount,
        paymentMethod,
        paymentStatus,
      ];
}
