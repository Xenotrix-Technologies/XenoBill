import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xenobill_flutter/application/customers/customers_bloc.dart';
import 'package:xenobill_flutter/domain/entities/customer.dart';
import 'package:xenobill_flutter/domain/entities/customer_payment.dart';
import 'package:xenobill_flutter/domain/repositories/repositories.dart';
import 'package:xenobill_flutter/presentation/customers/pages/add_edit_customer_page.dart';

class FakeCustomerRepository implements CustomerRepository {
  final List<Customer> _customers = [];

  @override
  Future<List<Customer>> getCustomers(String businessId) async {
    return _customers;
  }

  @override
  Future<Customer> addCustomer(Customer customer) async {
    _customers.add(customer);
    return customer;
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    final idx = _customers.indexWhere((c) => c.id == customer.id);
    if (idx != -1) {
      _customers[idx] = customer;
    }
    return customer;
  }

  @override
  Future<void> deleteCustomer(String customerId) async {
    _customers.removeWhere((c) => c.id == customerId);
  }

  @override
  Future<Customer?> getCustomerById(String id) async => null;

  @override
  Future<void> recordPayment(String customerId, double amount) async {}

  @override
  Future<void> recordCustomerPayment(CustomerPayment payment) async {}

  @override
  Future<List<CustomerPayment>> getCustomerPayments(String customerId) async => [];
}

void main() {
  late FakeCustomerRepository fakeRepo;
  late CustomersBloc customersBloc;

  setUp(() {
    fakeRepo = FakeCustomerRepository();
    customersBloc = CustomersBloc(repository: fakeRepo);
  });

  tearDown(() {
    customersBloc.close();
  });

  Widget createWidgetUnderTest({Customer? initialCustomer}) {
    return MaterialApp(
      home: BlocProvider.value(
        value: customersBloc,
        child: AddEditCustomerPage(initialCustomer: initialCustomer),
      ),
    );
  }

  testWidgets('Renders Add Customer header, sections, and fields correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Header
    expect(find.text('Add Customer'), findsOneWidget);
    expect(find.text('Add a customer or party to your business'), findsOneWidget);

    // Verify Section Headers
    expect(find.text('CUSTOMER INFORMATION'), findsOneWidget);
    expect(find.text('ADDRESS'), findsOneWidget);
    expect(find.text('ADDITIONAL DETAILS'), findsOneWidget);

    // Verify Fields
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Customer Name')), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Phone')), findsWidgets);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Email')), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Billing Address')), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('City')), findsWidgets);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('State')), findsWidgets);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('PIN Code')), findsWidgets);
    expect(find.text('Customer Type'), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Opening Balance')), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Credit Limit')), findsOneWidget);

    // Verify Primary Action Button
    expect(find.text('Create Customer'), findsOneWidget);

    // Ensure NO GST / Business Fields exist
    expect(find.text('GSTIN'), findsNothing);
    expect(find.text('GST Registration Type'), findsNothing);
    expect(find.text('PAN'), findsNothing);
    expect(find.text('Business / Trade Name'), findsNothing);
  });

  testWidgets('Validation prevents submitting with empty Customer Name', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final createButton = find.text('Create Customer');
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(find.text('Customer Name is required'), findsOneWidget);
  });
}
