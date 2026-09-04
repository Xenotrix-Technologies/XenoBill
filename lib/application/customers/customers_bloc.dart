import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_payment.dart';
import '../../domain/repositories/repositories.dart';

abstract class CustomersEvent extends Equatable {
  const CustomersEvent();
  @override
  List<Object?> get props => [];
}

class LoadCustomersEvent extends CustomersEvent {}

class SearchCustomersEvent extends CustomersEvent {
  final String query;
  const SearchCustomersEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class AddCustomerEvent extends CustomersEvent {
  final Customer customer;
  const AddCustomerEvent(this.customer);
  @override
  List<Object?> get props => [customer];
}

class UpdateCustomerEvent extends CustomersEvent {
  final Customer customer;
  const UpdateCustomerEvent(this.customer);
  @override
  List<Object?> get props => [customer];
}

class DeleteCustomerEvent extends CustomersEvent {
  final String customerId;
  const DeleteCustomerEvent(this.customerId);
  @override
  List<Object?> get props => [customerId];
}

class RecordCustomerPaymentEvent extends CustomersEvent {
  final String customerId;
  final double amount;
  const RecordCustomerPaymentEvent({required this.customerId, required this.amount});
  @override
  List<Object?> get props => [customerId, amount];
}

class RecordDetailedCustomerPaymentEvent extends CustomersEvent {
  final CustomerPayment payment;
  const RecordDetailedCustomerPaymentEvent(this.payment);
  @override
  List<Object?> get props => [payment];
}

abstract class CustomersState extends Equatable {
  const CustomersState();
  @override
  List<Object?> get props => [];
}

class CustomersInitial extends CustomersState {}
class CustomersLoading extends CustomersState {}
class CustomersLoaded extends CustomersState {
  final List<Customer> customers;
  final List<Customer> filteredCustomers;
  final String searchQuery;

  const CustomersLoaded({
    required this.customers,
    required this.filteredCustomers,
    this.searchQuery = '',
  });

  double get totalOutstanding => customers.fold(0.0, (sum, c) => sum + c.outstandingBalance);

  @override
  List<Object?> get props => [customers, filteredCustomers, searchQuery];
}

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final CustomerRepository repository;

  CustomersBloc({required this.repository}) : super(CustomersInitial()) {
    on<LoadCustomersEvent>((event, emit) async {
      emit(CustomersLoading());
      final customers = await repository.getCustomers('biz_1');
      emit(CustomersLoaded(customers: customers, filteredCustomers: customers));
    });

    on<SearchCustomersEvent>((event, emit) {
      if (state is CustomersLoaded) {
        final currentState = state as CustomersLoaded;
        final query = event.query.toLowerCase();
        final filtered = currentState.customers.where((c) {
          return c.name.toLowerCase().contains(query) ||
                 c.phone.toLowerCase().contains(query) ||
                 c.email.toLowerCase().contains(query);
        }).toList();
        emit(CustomersLoaded(
          customers: currentState.customers,
          filteredCustomers: filtered,
          searchQuery: event.query,
        ));
      }
    });

    on<AddCustomerEvent>((event, emit) async {
      await repository.addCustomer(event.customer);
      add(LoadCustomersEvent());
    });

    on<UpdateCustomerEvent>((event, emit) async {
      await repository.updateCustomer(event.customer);
      add(LoadCustomersEvent());
    });

    on<DeleteCustomerEvent>((event, emit) async {
      await repository.deleteCustomer(event.customerId);
      add(LoadCustomersEvent());
    });

    on<RecordCustomerPaymentEvent>((event, emit) async {
      await repository.recordPayment(event.customerId, event.amount);
      add(LoadCustomersEvent());
    });

    on<RecordDetailedCustomerPaymentEvent>((event, emit) async {
      await repository.recordCustomerPayment(event.payment);
      add(LoadCustomersEvent());
    });
  }
}
