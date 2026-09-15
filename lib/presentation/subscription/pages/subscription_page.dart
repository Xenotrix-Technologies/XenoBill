import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/subscription_details.dart';
import '../../../domain/entities/subscription_transaction.dart';
import '../../../infrastructure/supabase/supabase_client.dart';
import '../../../application/subscription/subscription_bloc.dart';
import '../../../application/subscription/subscription_event.dart';
import '../../../application/subscription/subscription_state.dart';

/// Data class representing an offer record from public.subscription_offers / public.subscription_offer
class SubscriptionOffer {
  final String id;
  final String offerName;
  final String description;
  final String planId;
  final double offerPrice;
  final String currency;
  final bool isActive;

  const SubscriptionOffer({
    required this.id,
    required this.offerName,
    required this.description,
    required this.planId,
    required this.offerPrice,
    this.currency = 'INR',
    this.isActive = true,
  });

  factory SubscriptionOffer.fromSupabaseJson(Map<String, dynamic> json) {
    return SubscriptionOffer(
      id: json['id']?.toString() ?? '',
      offerName: json['offer_name']?.toString() ?? json['name']?.toString() ?? 'Special Offer',
      description: json['description']?.toString() ?? '',
      planId: json['plan_id']?.toString() ?? '',
      offerPrice: ((json['offer_price'] ?? json['price'] ?? 199.0) as num).toDouble(),
      currency: json['currency']?.toString() ?? 'INR',
      isActive: json['is_active'] != false,
    );
  }
}

/// Data class representing a plan record from public.subscription_plans / public.subscription_plan
class SubscriptionPlan {
  final String id;
  final String planName;
  final String description;
  final double price;
  final String billingCycle; // 'monthly' or 'yearly'
  final double? originalPrice;
  final String? discountTag;
  final List<String> features;
  final bool isRecommended;
  final bool isActive;
  final SubscriptionOffer? activeOffer;

  const SubscriptionPlan({
    required this.id,
    required this.planName,
    this.description = '',
    required this.price,
    required this.billingCycle,
    this.originalPrice,
    this.discountTag,
    required this.features,
    this.isRecommended = false,
    this.isActive = true,
    this.activeOffer,
  });

  double get finalPrice => activeOffer != null ? activeOffer!.offerPrice : price;
  double? get strikethroughPrice => activeOffer != null ? price : originalPrice;

  factory SubscriptionPlan.fromSupabaseJson(Map<String, dynamic> json, {SubscriptionOffer? offer}) {
    List<String> parsedFeatures = [];
    if (json['features'] is List) {
      parsedFeatures = (json['features'] as List).map((e) => e.toString()).toList();
    } else if (json['plan_details'] != null && json['plan_details']['features'] is List) {
      parsedFeatures = (json['plan_details']['features'] as List).map((e) => e.toString()).toList();
    } else if (json['features'] is String) {
      try {
        final decoded = jsonDecode(json['features']);
        if (decoded is List) {
          parsedFeatures = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    final cycleStr = json['billing_cycle']?.toString().toLowerCase() ?? json['cycle']?.toString().toLowerCase() ?? 'monthly';
    final isYearly = cycleStr.contains('year');
    final rawOrigPrice = (json['original_price'] as num?)?.toDouble();

    return SubscriptionPlan(
      id: json['id']?.toString() ?? '',
      planName: json['plan_name']?.toString() ?? json['name']?.toString() ?? (isYearly ? 'Xenobill Yearly' : 'Xenobill Monthly'),
      description: json['description']?.toString() ?? (isYearly ? 'Complete annual access to all Xenobill Pro features with priority support.' : 'Flexible monthly access to all Xenobill Pro features.'),
      price: ((json['price'] ?? json['amount'] ?? (isYearly ? 4999.0 : 399.0)) as num).toDouble(),
      billingCycle: isYearly ? 'yearly' : 'monthly',
      originalPrice: rawOrigPrice ?? (isYearly ? null : 399.0),
      discountTag: json['discount_tag']?.toString() ?? (isYearly ? 'Save 17%' : null),
      features: parsedFeatures.isNotEmpty
          ? parsedFeatures
          : (isYearly
              ? [
                  'All Pro Monthly Features',
                  'Priority Support & Onboarding',
                  'GST Tax Returns & E-Way Bills',
                  'Custom Invoice Templates'
                ]
              : [
                  'Unlimited Invoices & Purchases',
                  'Full Analytics & Smart Insights',
                  'WhatsApp & Email Billing',
                  'Cloud Backup & Multi-device Sync'
                ]),
      isRecommended: json['is_recommended'] == true || json['is_popular'] == true || isYearly,
      isActive: json['is_active'] != false,
      activeOffer: offer,
    );
  }
}

/// Skeleton loader specifically for Available Subscription Plans section
class SubscriptionSkeletonLoader extends StatefulWidget {
  const SubscriptionSkeletonLoader({super.key});

  @override
  State<SubscriptionSkeletonLoader> createState() => _SubscriptionSkeletonLoaderState();
}

class _SubscriptionSkeletonLoaderState extends State<SubscriptionSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBone({required double width, required double height, double borderRadius = 8}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBone(width: 160, height: 22, borderRadius: 6),
              const SizedBox(height: 12),
              _buildBone(width: double.infinity, height: 38, borderRadius: 8),
              const SizedBox(height: 16),
              _buildBone(width: 130, height: 30, borderRadius: 6),
              const SizedBox(height: 16),
              _buildBone(width: double.infinity, height: 16, borderRadius: 4),
              const SizedBox(height: 8),
              _buildBone(width: double.infinity, height: 16, borderRadius: 4),
              const SizedBox(height: 8),
              _buildBone(width: 220, height: 16, borderRadius: 4),
              const SizedBox(height: 20),
              _buildBone(width: double.infinity, height: 44, borderRadius: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _availablePlansKey = GlobalKey();

  String _selectedCycle = 'monthly'; // 'monthly' or 'yearly'
  List<SubscriptionPlan> _fetchedPlans = [];
  bool _isLoadingPlans = true;
  bool _isOffline = false;

  // Fallback default plans
  static const List<SubscriptionPlan> _defaultPlans = [
    SubscriptionPlan(
      id: 'plan_monthly',
      planName: 'Xenobill Monthly',
      description: 'Flexible monthly access to all Xenobill Pro features.',
      price: 399.0,
      originalPrice: 399.0,
      billingCycle: 'monthly',
      features: [
        'Unlimited Invoices & Purchases',
        'Full Analytics & Smart Insights',
        'WhatsApp & Email Billing',
        'Cloud Backup & Multi-device Sync'
      ],
      isRecommended: false,
      activeOffer: SubscriptionOffer(
        id: 'offer_first_month',
        offerName: 'Special Offer',
        description: '₹199 for your 1st month, then ₹399/month thereafter',
        planId: 'plan_monthly',
        offerPrice: 199.0,
      ),
    ),
    SubscriptionPlan(
      id: 'plan_yearly',
      planName: 'Xenobill Yearly',
      description: 'Complete annual access to all Xenobill Pro features with priority support.',
      price: 4999.0,
      billingCycle: 'yearly',
      features: [
        'All Pro Monthly Features',
        'Priority Support & Onboarding',
        'GST Tax Returns & E-Way Bills',
        'Custom Invoice Templates'
      ],
      isRecommended: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionPlansAndOffers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Auto scrolls to the Available Plans section smoothly
  void _scrollToAvailablePlans() {
    final ctx = _availablePlansKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else if (_scrollController.hasClients) {
      _scrollController.animateTo(
        320,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Fetches plans from public.subscription_plans / public.subscription_plan and offers from public.subscription_offers
  Future<void> _fetchSubscriptionPlansAndOffers() async {
    try {
      final client = SupabaseClientManager.instance.client;

      // 1. Fetch active offers from public.subscription_offers / public.subscription_offer
      List<SubscriptionOffer> offers = [];
      try {
        dynamic offersRes;
        try {
          offersRes = await client.from('subscription_offers').select('*').eq('is_active', true);
        } catch (_) {
          offersRes = await client.from('subscription_offer').select('*').eq('is_active', true);
        }
        if (offersRes is List && offersRes.isNotEmpty) {
          offers = offersRes
              .map((o) => SubscriptionOffer.fromSupabaseJson(Map<String, dynamic>.from(o as Map)))
              .toList();
        }
      } catch (e) {
        debugPrint('[SubscriptionPage] Note on fetching subscription_offers: $e');
      }

      // If no offers in cloud, provide default first month offer for monthly plan
      if (offers.isEmpty) {
        offers = [
          const SubscriptionOffer(
            id: 'offer_first_month',
            offerName: 'Special Offer',
            description: '₹199 for your 1st month, then ₹399/month thereafter',
            planId: 'plan_monthly',
            offerPrice: 199.0,
          ),
        ];
      }

      // 2. Fetch plans from public.subscription_plans / public.subscription_plan
      dynamic plansRes;
      try {
        plansRes = await client.from('subscription_plans').select('*').order('price', ascending: true);
      } catch (_) {
        plansRes = await client.from('subscription_plan').select('*').order('price', ascending: true);
      }

      if (plansRes is List && plansRes.isNotEmpty) {
        final parsed = plansRes.map((map) {
          final planMap = Map<String, dynamic>.from(map as Map);
          final planId = planMap['id']?.toString() ?? '';

          SubscriptionOffer? matchedOffer;
          try {
            matchedOffer = offers.firstWhere(
              (off) => off.planId == planId ||
                  off.offerName.toLowerCase().contains(planMap['plan_name']?.toString().toLowerCase() ?? '') ||
                  planMap['plan_name']?.toString().toLowerCase().contains('monthly') == true,
            );
          } catch (_) {
            if (planMap['billing_cycle']?.toString().toLowerCase().contains('month') == true ||
                planMap['plan_name']?.toString().toLowerCase().contains('monthly') == true) {
              matchedOffer = const SubscriptionOffer(
                id: 'offer_first_month',
                offerName: 'Special Offer',
                description: '₹199 for your 1st month, then ₹399/month thereafter',
                planId: '',
                offerPrice: 199.0,
              );
            }
          }

          return SubscriptionPlan.fromSupabaseJson(
            planMap,
            offer: matchedOffer != null && matchedOffer.isActive ? matchedOffer : null,
          );
        }).where((p) => p.isActive).toList();

        if (parsed.isNotEmpty) {
          if (mounted) {
            setState(() {
              _fetchedPlans = parsed;
              _isLoadingPlans = false;
              _isOffline = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('[SubscriptionPage] Error fetching plans/offers: $e');
    }

    if (mounted) {
      setState(() {
        _fetchedPlans = _defaultPlans;
        _isLoadingPlans = false;
        _isOffline = false;
      });
    }
  }

  /// Checks internet connectivity prior to triggering payment gateway
  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 2));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
    } catch (_) {}
    try {
      final result = await InternetAddress.lookup('1.1.1.1').timeout(const Duration(seconds: 2));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
    } catch (_) {}
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        foregroundColor: Colors.white,
        title: const Text(
          'Subscription & Billing',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            if (state is! SubscriptionLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final details = state.details;
            final transactions = state.transactions;

            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isOffline) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off_rounded, color: Colors.red, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Offline Mode: Please connect to the internet to purchase or refresh plans.',
                              style: TextStyle(fontSize: 12.5, color: Colors.red, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 1. CURRENT PLAN CARD
                  _buildCurrentPlanCard(context, details),
                  const SizedBox(height: 24),

                  // 2. AVAILABLE PLANS SECTION WITH CENTERED TOGGLE TAB
                  _buildPlansHeaderWithCoolerToggle(),
                  const SizedBox(height: 16),
                  _buildPlansSection(context, details, transactions),
                  const SizedBox(height: 24),

                  // 3. TRANSACTION / PAYMENT HISTORY SECTION
                  _buildTransactionHistorySection(context, transactions),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. CURRENT PLAN CARD (WITHOUT CHANGE PLAN & CANCEL SUBSCRIPTION BUTTONS)
  // ===========================================================================
  Widget _buildCurrentPlanCard(BuildContext context, SubscriptionDetails details) {
    final status = details.status;
    final isPro = status == SubscriptionStatus.subscriptionActive;
    final isTrialExpired = status == SubscriptionStatus.trialExpired;
    final isSubExpired = status == SubscriptionStatus.subscriptionExpired;
    final isExpired = isTrialExpired || isSubExpired;

    final remainingDays = isPro ? details.remainingSubscriptionDays : details.remainingTrialDays;

    String dateLabel = 'Expires On';
    String dateVal = DateFormat('dd MMM yyyy').format(details.trialEndDate);

    if (isPro && details.subscriptionEndDate != null) {
      dateLabel = 'Renews On';
      dateVal = DateFormat('dd MMM yyyy').format(details.subscriptionEndDate!);
    } else if (isSubExpired && details.subscriptionEndDate != null) {
      dateLabel = 'Expired On';
      dateVal = DateFormat('dd MMM yyyy').format(details.subscriptionEndDate!);
    } else if (isTrialExpired) {
      dateLabel = 'Expired On';
      dateVal = DateFormat('dd MMM yyyy').format(details.trialEndDate);
    }

    String statusBadgeText = 'FREE TRIAL ACTIVE';
    Color badgeBgColor = AppColors.brightCyan;
    Color badgeTextColor = AppColors.darkNavy;

    if (isPro) {
      statusBadgeText = 'PRO ACTIVE';
      badgeBgColor = const Color(0xFF16A34A);
      badgeTextColor = Colors.white;
    } else if (isTrialExpired) {
      statusBadgeText = 'INACTIVE';
      badgeBgColor = const Color(0xFFEF4444);
      badgeTextColor = Colors.white;
    } else if (isSubExpired) {
      statusBadgeText = 'EXPIRED';
      badgeBgColor = const Color(0xFFEF4444);
      badgeTextColor = Colors.white;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header status badge & remaining days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusBadgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (!isExpired)
                Text(
                  '$remainingDays ${remainingDays == 1 ? 'day' : 'days'} left',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.brightCyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Plan Name
          Text(
            isExpired ? (isTrialExpired ? 'Demo Plan' : details.planName) : details.planName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),

          // Dates & Status line
          Row(
            children: [
              Text(
                '$dateLabel: $dateVal',
                style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 14),
              Text(
                'Status: ${isTrialExpired ? 'expired' : (isPro ? 'active' : 'demo')}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
            ],
          ),

          // CARD FOOTER ACTIONS / MESSAGES BASED ON STATUS:
          if (isTrialExpired) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF7F1D1D).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFFCA5A5), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Demo is over. Purchase plan to continue.',
                      style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _scrollToAvailablePlans,
                icon: const Icon(Icons.arrow_downward_rounded, size: 20),
                label: const Text(
                  'Purchase Plan to Continue',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCyan,
                  foregroundColor: AppColors.darkNavy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ] else if (isSubExpired) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _scrollToAvailablePlans,
                icon: const Icon(Icons.autorenew_rounded, size: 20),
                label: Text(
                  'Renew Plan (${details.planName})',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCyan,
                  foregroundColor: AppColors.darkNavy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. CENTERED PLANS HEADER WITH SIMPLE TOGGLE TAB (NO ICONS, NO PERCENTAGE OFF)
  // ===========================================================================
  Widget _buildPlansHeaderWithCoolerToggle() {
    return Column(
      key: _availablePlansKey,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            'Available Plans',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 12),

        // CENTERED TOGGLE TAB
        Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSimpleTabButton(
                  label: 'Monthly',
                  value: 'monthly',
                ),
                const SizedBox(width: 4),
                _buildSimpleTabButton(
                  label: 'Yearly',
                  value: 'yearly',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleTabButton({
    required String label,
    required String value,
  }) {
    final isSelected = _selectedCycle == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCycle = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkNavy : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.darkNavy.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildPlansSection(
    BuildContext context,
    SubscriptionDetails details,
    List<SubscriptionTransaction> transactions,
  ) {
    if (_isLoadingPlans) {
      return const SubscriptionSkeletonLoader();
    }

    // A user has purchased a plan ONLY if status is subscriptionActive AND subscriptionStartDate is set
    final bool hasPurchasedPlan = details.status == SubscriptionStatus.subscriptionActive &&
        details.subscriptionStartDate != null;

    final currentPlan = details.planName;
    final activePlans = (_fetchedPlans.isNotEmpty ? _fetchedPlans : _defaultPlans)
        .where((p) => p.billingCycle == _selectedCycle)
        .toList();

    return Column(
      children: [
        ...activePlans.map((plan) {
          final isCurrent = currentPlan.toLowerCase().replaceAll(' ', '') == plan.planName.toLowerCase().replaceAll(' ', '');

          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: _buildUnifiedPlanTile(
              context: context,
              plan: plan,
              isCurrent: isCurrent,
              hasPurchasedPlan: hasPurchasedPlan,
              onSelect: () => _handlePlanSelection(context, plan, hasPurchasedPlan: hasPurchasedPlan),
            ),
          );
        }),
      ],
    );
  }

  /// Unified Card Widget for both Monthly and Yearly Plans
  Widget _buildUnifiedPlanTile({
    required BuildContext context,
    required SubscriptionPlan plan,
    bool isCurrent = false,
    bool hasPurchasedPlan = false,
    VoidCallback? onSelect,
  }) {
    final isRecommended = plan.isRecommended;
    final bool showOffer = !hasPurchasedPlan && plan.billingCycle == 'monthly';

    final finalPriceVal = showOffer ? 199.0 : plan.price;
    final double? strikethroughPriceVal = showOffer ? plan.price : null;

    final periodText = plan.billingCycle == 'yearly'
        ? '/ year ${plan.discountTag != null ? '(${plan.discountTag})' : ''}'
        : '/ month';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRecommended
              ? AppColors.brightCyan
              : (isCurrent ? AppColors.darkNavy : const Color(0xFFE2E8F0)),
          width: isRecommended || isCurrent ? 2.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isRecommended
                ? AppColors.brightCyan.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Recommendation Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    plan.planName,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  if (isRecommended) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.brightCyan.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'RECOMMENDED',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                      ),
                    ),
                  ],
                ],
              ),
              if (isCurrent)
                const Icon(Icons.check_circle, color: AppColors.darkNavy, size: 22),
            ],
          ),
          const SizedBox(height: 6),

          // Cloud Description text
          if (plan.description.isNotEmpty) ...[
            Text(
              plan.description,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), height: 1.35),
            ),
            const SizedBox(height: 10),
          ],

          // Friendly Offer Tag Banner (Hidden if user purchased a plan)
          if (showOffer) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.local_offer_rounded, color: Color(0xFFD97706), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Special Offer – ₹199 for your 1st month, then ₹399/month thereafter.',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Price row with Strikethrough if offer exists
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (strikethroughPriceVal != null && strikethroughPriceVal > finalPriceVal) ...[
                Text(
                  CurrencyFormatter.format(strikethroughPriceVal),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                CurrencyFormatter.format(finalPriceVal),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(width: 4),
              Text(
                periodText,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // Features List
          ...plan.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 17, color: Color(0xFF16A34A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),

          // Action Button
          if (!isCurrent && onSelect != null)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecommended ? AppColors.brightCyan : AppColors.darkNavy,
                  foregroundColor: isRecommended ? AppColors.darkNavy : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Select ${plan.planName}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else if (isCurrent)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Active Current Plan',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. TRANSACTION HISTORY SECTION
  // ===========================================================================
  Widget _buildTransactionHistorySection(BuildContext context, List<SubscriptionTransaction> transactions) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('No billing transactions recorded yet', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.receipt_long, color: AppColors.darkNavy, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.planName,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              '${DateFormat('dd MMM yyyy').format(tx.date)} · ${tx.paymentMethod}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.format(tx.amount),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          InkWell(
                            onTap: () => _showReceiptModal(context, tx),
                            child: const Text(
                              'View Receipt',
                              style: TextStyle(fontSize: 12, color: AppColors.darkNavy, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // INTERNET CHECK & BOTTOMSHEET PURCHASE FLOW
  // ===========================================================================
  Future<void> _handlePlanSelection(
    BuildContext context,
    SubscriptionPlan plan, {
    bool hasPurchasedPlan = false,
  }) async {
    final finalPriceToCharge = (!hasPurchasedPlan && plan.billingCycle == 'monthly') ? 199.0 : plan.finalPrice;

    final hasInternet = await _checkInternet();
    if (!hasInternet) {
      if (!mounted) return;
      setState(() => _isOffline = true);
    }

    // 1. Open Purchase BottomSheet
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetCtx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        plan.planName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(bottomSheetCtx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Billing Cycle', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          const SizedBox(height: 2),
                          Text(
                            plan.billingCycle.toUpperCase(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Total Amount', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.format(finalPriceToCharge),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Included Features
                const Text(
                  'Included in this plan:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                ),
                const SizedBox(height: 8),
                ...plan.features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: Color(0xFF16A34A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(f, style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetCtx);
                      _processRazorpayPayment(context, plan, finalPriceToCharge);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brightCyan,
                      foregroundColor: AppColors.darkNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue to Payment',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Simulated Razorpay Payment Gateway integration with loading and success states
  Future<void> _processRazorpayPayment(BuildContext context, SubscriptionPlan plan, double amountToCharge) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.brightCyan),
                const SizedBox(height: 20),
                const Text(
                  'Connecting to Razorpay...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                ),
                const SizedBox(height: 6),
                Text(
                  'Processing payment of ${CurrencyFormatter.format(amountToCharge)}',
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        );
      },
    );

    final nav = Navigator.of(context, rootNavigator: true);
    final bloc = context.read<SubscriptionBloc>();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    nav.pop();

    bloc.add(PurchasePlanEvent(
          planName: plan.planName,
          amount: amountToCharge,
          paymentMethod: 'Razorpay Online',
        ));

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (successCtx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF16A34A),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your ${plan.planName} subscription is now active.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(successCtx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReceiptModal(BuildContext context, SubscriptionTransaction tx) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Subscription Receipt', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction ID: ${tx.id.length > 8 ? tx.id.substring(0, 8).toUpperCase() : tx.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Plan'), Text(tx.planName, style: const TextStyle(fontWeight: FontWeight.bold))]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Date'), Text(DateFormat('dd MMM yyyy, h:mm a').format(tx.date))]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Payment Method'), Text(tx.paymentMethod)]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Amount Paid'), Text(CurrencyFormatter.format(tx.amount), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Close')),
        ],
      ),
    );
  }
}
