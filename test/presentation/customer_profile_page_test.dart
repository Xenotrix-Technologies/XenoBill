import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xenobill_flutter/application/customers/customers_bloc.dart';
import 'package:xenobill_flutter/domain/entities/customer.dart';
import 'package:xenobill_flutter/domain/entities/customer_payment.dart';
import 'package:xenobill_flutter/domain/repositories/repositories.dart';
import 'package:xenobill_flutter/infrastructure/database/app_database.dart';
import 'package:xenobill_flutter/presentation/customers/pages/customer_profile_page.dart';

class FakeCustomerRepository implements CustomerRepository {
  final List<Customer> _customers = [];

  @override
  Future<List<Customer>> getCustomers(String businessId) async => _customers;

  @override
  Future<Customer?> getCustomerById(String id) async => null;

  @override
  Future<void> addCustomer(Customer customer) async {
    _customers.add(customer);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {}

  @override
  Future<void> recordPayment(String customerId, double amount) async {}

  @override
  Future<void> recordCustomerPayment(CustomerPayment payment) async {}

  @override
  Future<List<CustomerPayment>> getCustomerPayments(String customerId) async => [];

  @override
  Future<void> deleteCustomer(String id) async {}
}

void main() {
  late FakeCustomerRepository fakeRepo;
  late CustomersBloc customersBloc;

  const testCustomer = Customer(
    id: 'c1',
    businessId: 'biz_1',
    name: 'Hari',
    phone: '+91 40259294662',
    email: 'hari@example.com',
    address: 'Lake View Apartments',
    gstin: '',
    outstandingBalance: 2500.0,
    totalInvoices: 12,
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    fakeRepo = FakeCustomerRepository();
    customersBloc = CustomersBloc(repository: fakeRepo);
    AppDatabase.instance.loadDemoData();
  });

  tearDown(() {
    customersBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider.value(
        value: customersBloc,
        child: const CustomerProfilePage(customer: testCustomer),
      ),
    );
  }

  testWidgets('Renders Customer Profile header, actions, summary card & tabs', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // App Bar
    expect(find.text('Customer Profile'), findsOneWidget);
    expect(find.byIcon(Icons.picture_as_pdf_outlined), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsWidgets);

    // Customer Identity Header
    expect(find.text('Hari'), findsOneWidget);
    expect(find.text('+91 40259294662'), findsWidgets);
    expect(find.text('HA'), findsOneWidget);

    // Primary Actions
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Record Payment'), findsWidgets);

    // Summary Card
    expect(find.text('Outstanding'), findsWidgets);



    // Tabs
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Timeline'), findsOneWidget);

    // Verify NO GST/PAN/Purchases strictly
    expect(find.text('Purchases'), findsNothing);
    expect(find.text('Last purchase'), findsNothing);
    expect(find.text('GSTIN'), findsNothing);
  });

  testWidgets('Opening Record Payment bottom sheet shows amount, methods & submit button', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap + Record Payment
    final recordPaymentBtn = find.widgetWithText(ElevatedButton, 'Record Payment');
    await tester.tap(recordPaymentBtn);
    await tester.pumpAndSettle();

    // Bottom sheet content
    expect(find.text('Amount Collected *'), findsOneWidget);
    expect(find.text('Payment Method'), findsOneWidget);
    expect(find.text('Reference / Note'), findsOneWidget);
  });
}
