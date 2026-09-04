import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'infrastructure/database/app_database.dart';
import 'infrastructure/repositories/repository_impls.dart';
import 'application/business/business_bloc.dart';
import 'application/inventory/inventory_bloc.dart';
import 'application/customers/customers_bloc.dart';
import 'application/invoice/invoice_bloc.dart';
import 'application/sales/sales_bloc.dart';
import 'application/reports/reports_bloc.dart';
import 'application/expenses/expenses_bloc.dart';
import 'application/smart/smart_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.init();
  runApp(const XenobizApp());
}

class XenobizApp extends StatelessWidget {
  const XenobizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final businessRepo = BusinessRepositoryImpl();
    final productRepo = ProductRepositoryImpl();
    final customerRepo = CustomerRepositoryImpl();
    final invoiceRepo = InvoiceRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BusinessBloc(repository: businessRepo)..add(LoadBusinessEvent())),
        BlocProvider(create: (_) => InventoryBloc(repository: productRepo)..add(LoadInventoryEvent())),
        BlocProvider(create: (_) => CustomersBloc(repository: customerRepo)..add(LoadCustomersEvent())),
        BlocProvider(create: (_) => InvoiceBloc(repository: invoiceRepo)),
        BlocProvider(create: (_) => SalesBloc(repository: invoiceRepo)..add(LoadSalesEvent())),
        BlocProvider(create: (_) => ReportsBloc(repository: invoiceRepo)..add(const LoadReportsEvent())),
        BlocProvider(create: (_) => ExpensesBloc()..add(LoadExpensesEvent())),
        BlocProvider(create: (_) => SmartBloc()..add(LoadSmartInsightsEvent())),
      ],
      child: MaterialApp.router(
        title: 'Xenobiz POS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
