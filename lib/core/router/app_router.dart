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
import '../../domain/entities/item.dart';
import '../../domain/entities/customer.dart';
import '../../presentation/main_layout/main_layout_page.dart';
import '../../presentation/dashboard/dashboard_page.dart';
import '../../presentation/sales/sales_history_page.dart';
import '../../presentation/invoice/pages/add_invoice_page.dart';
import '../../presentation/invoice/pages/invoice_detail_page.dart';
import '../../presentation/inventory/pages/inventory_page.dart';
import '../../presentation/inventory/pages/add_edit_product_page.dart';
import '../../presentation/inventory/pages/product_detail_page.dart';
import '../../presentation/customers/pages/customers_page.dart';
import '../../presentation/customers/pages/add_edit_customer_page.dart';
import '../../presentation/reports/reports_page.dart';
import '../../presentation/settings/settings_page.dart';
import '../../presentation/expenses/expenses_page.dart';
import '../../presentation/smart/smart_insights_page.dart';

import '../../presentation/customers/pages/customer_profile_page.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
  static final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellNav');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.welcome,
    redirect: (context, state) {
      final db = AppDatabase.instance;
      final isWelcomeRoute = state.matchedLocation == RouteConstants.welcome;
      final isAuthRoute = state.matchedLocation == RouteConstants.login ||
                          state.matchedLocation == RouteConstants.register ||
                          state.matchedLocation == RouteConstants.businessTypeSelection ||
                          state.matchedLocation == RouteConstants.businessSetup;

      if (!db.isLoggedIn && !isWelcomeRoute && !isAuthRoute) {
        return RouteConstants.welcome;
      }

      if (db.isLoggedIn && !db.isBusinessConfigured) {
        if (state.matchedLocation != RouteConstants.businessTypeSelection &&
            state.matchedLocation != RouteConstants.businessSetup) {
          return RouteConstants.businessTypeSelection;
        }
      }

      if (db.isLoggedIn && db.isBusinessConfigured && (isWelcomeRoute || isAuthRoute)) {
        return RouteConstants.home;
      }

      return null;
    },
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
          final type = state.extra as BusinessType? ?? BusinessType.retail;
          return BusinessSetupPage(selectedType: type);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteConstants.addInvoice,
        builder: (context, state) => const AddInvoicePage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteConstants.invoiceDetail,
        builder: (context, state) {
          final invoiceId = state.pathParameters['id'] ?? '';
          return InvoiceDetailPage(invoiceId: invoiceId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteConstants.addEditProduct,
        builder: (context, state) {
          final item = state.extra as Item?;
          return AddEditProductPage(initialItem: item);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteConstants.productDetail,
        builder: (context, state) {
          final item = state.extra as Item;
          return ProductDetailPage(item: item);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteConstants.addEditCustomer,
        builder: (context, state) {
          final customer = state.extra as Customer?;
          return AddEditCustomerPage(initialCustomer: customer);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteConstants.customerProfile,
        builder: (context, state) {
          final customer = state.extra as Customer;
          return CustomerProfilePage(customer: customer);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteConstants.reports,
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/expenses',
        builder: (context, state) => const ExpensesPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/smart',
        builder: (context, state) => const SmartInsightsPage(),
      ),
      // Main Shell Route with Floating Navigation Bar
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayoutPage(state: state, child: child);
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

