import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/route_constants.dart';
import '../../infrastructure/database/app_database.dart';
import '../../presentation/auth/pages/welcome_page.dart';
import '../../presentation/auth/pages/register_page.dart';
import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/auth/pages/business_type_selection_page.dart';
import '../../presentation/auth/pages/business_setup_page.dart';
import '../../domain/entities/business_type.dart';
import '../../presentation/main_layout/main_layout_page.dart';
import '../../presentation/dashboard/dashboard_page.dart';
import '../../presentation/sales/sales_history_page.dart';
import '../../presentation/invoice/pages/add_invoice_page.dart';
import '../../presentation/invoice/pages/invoice_detail_page.dart';
import '../../presentation/inventory/pages/inventory_page.dart';
import '../../presentation/inventory/pages/add_edit_product_page.dart';
import '../../presentation/customers/pages/customers_page.dart';
import '../../presentation/customers/pages/add_edit_customer_page.dart';
import '../../presentation/reports/reports_page.dart';
import '../../presentation/settings/settings_page.dart';
import '../../presentation/expenses/expenses_page.dart';
import '../../presentation/smart/smart_insights_page.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => GoRouter(
        initialLocation: AppDatabase.instance.isDemoMode || AppDatabase.instance.isBusinessConfigured
            ? RouteConstants.home
            : RouteConstants.welcome,
        navigatorKey: _rootNavigatorKey,
        routes: [
          GoRoute(
            path: RouteConstants.welcome,
            builder: (context, state) => const WelcomePage(),
          ),
          GoRoute(
            path: RouteConstants.register,
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: RouteConstants.login,
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: RouteConstants.businessTypeSelection,
            builder: (context, state) => const BusinessTypeSelectionPage(),
          ),
          GoRoute(
            path: RouteConstants.businessSetup,
            builder: (context, state) {
              final selectedType = state.extra as BusinessType?;
              return BusinessSetupPage(selectedType: selectedType);
            },
          ),
          GoRoute(
            path: RouteConstants.addInvoice,
            builder: (context, state) => const AddInvoicePage(),
          ),
          GoRoute(
            path: '/invoice/:id',
            builder: (context, state) {
              final invoiceId = state.pathParameters['id'] ?? '';
              return InvoiceDetailPage(invoiceId: invoiceId);
            },
          ),
          GoRoute(
            path: RouteConstants.addEditProduct,
            builder: (context, state) => const AddEditProductPage(),
          ),
          GoRoute(
            path: RouteConstants.addEditCustomer,
            builder: (context, state) => const AddEditCustomerPage(),
          ),
          GoRoute(
            path: RouteConstants.reports,
            builder: (context, state) => const ReportsPage(),
          ),
          GoRoute(
            path: '/expenses',
            builder: (context, state) => const ExpensesPage(),
          ),
          GoRoute(
            path: '/smart',
            builder: (context, state) => const SmartInsightsPage(),
          ),
          // Main Shell Route with Floating Navigation Bar
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) {
              return MainLayoutPage(child: child);
            },
            routes: [
              GoRoute(
                path: RouteConstants.home,
                builder: (context, state) => const DashboardPage(),
              ),
              GoRoute(
                path: RouteConstants.sales,
                builder: (context, state) => const SalesHistoryPage(),
              ),
              GoRoute(
                path: RouteConstants.shop,
                builder: (context, state) => const InventoryPage(),
              ),
              GoRoute(
                path: RouteConstants.customers,
                builder: (context, state) => const CustomersPage(),
              ),
              GoRoute(
                path: RouteConstants.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      );
}
