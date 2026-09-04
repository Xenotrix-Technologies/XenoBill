import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xenobill_flutter/domain/entities/customer.dart';
import 'package:xenobill_flutter/application/customers/customers_bloc.dart';
import 'package:xenobill_flutter/infrastructure/repositories/repository_impls.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CustomersBloc Add, Update, and Delete Tests', () {
    late CustomerRepositoryImpl repository;
    late CustomersBloc customersBloc;

    const testCust = Customer(
      id: 'cust_test_1',
      businessId: 'biz_1',
      name: 'Ramesh Patel',
      phone: '9876543210',
      email: 'ramesh@example.com',
      address: '10 Park Avenue',
      gstin: '27AAAAA0000A1Z5',
      outstandingBalance: 500.0,
      totalInvoices: 2,
    );

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = CustomerRepositoryImpl();
      customersBloc = CustomersBloc(repository: repository);
    });

    tearDown(() {
      customersBloc.close();
    });

    test('AddCustomerEvent adds customer to repository', () async {
      customersBloc.add(const AddCustomerEvent(testCust));
      await Future.delayed(const Duration(milliseconds: 50));

      final fetched = await repository.getCustomerById('cust_test_1');
      expect(fetched, isNotNull);
      expect(fetched?.name, equals('Ramesh Patel'));
    });

    test('DeleteCustomerEvent removes customer from repository', () async {
      await repository.addCustomer(testCust);
      customersBloc.add(const DeleteCustomerEvent('cust_test_1'));
      await Future.delayed(const Duration(milliseconds: 50));

      final fetched = await repository.getCustomerById('cust_test_1');
      expect(fetched, isNull);
    });
  });
}
