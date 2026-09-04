import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/repositories.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();
  @override
  List<Object?> get props => [];
}

class LoadSalesEvent extends SalesEvent {}

class FilterSalesEvent extends SalesEvent {
  final String dateRange; // 'Today', '7 Days', '30 Days', 'All'
  final String paymentFilter; // 'All', 'Cash', 'Credit', 'UPI', 'Card'
  final String searchQuery;

  const FilterSalesEvent({
    required this.dateRange,
    required this.paymentFilter,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [dateRange, paymentFilter, searchQuery];
}

class CancelInvoiceEvent extends SalesEvent {
  final String invoiceId;
  const CancelInvoiceEvent(this.invoiceId);
  @override
  List<Object?> get props => [invoiceId];
}

abstract class SalesState extends Equatable {
  const SalesState();
  @override
  List<Object?> get props => [];
}

class SalesInitial extends SalesState {}
class SalesLoading extends SalesState {}
class SalesLoaded extends SalesState {
  final List<Invoice> allInvoices;
  final List<Invoice> filteredInvoices;
  final String selectedDateRange;
  final String selectedPaymentFilter;
  final String searchQuery;

  const SalesLoaded({
    required this.allInvoices,
    required this.filteredInvoices,
    this.selectedDateRange = 'Today',
    this.selectedPaymentFilter = 'All',
    this.searchQuery = '',
  });

  double get todaySales => allInvoices.fold(0.0, (sum, i) => sum + i.grandTotal);
  int get todayBillsCount => allInvoices.length;
  double get cashSales => allInvoices.where((i) => i.paymentType == PaymentType.cash).fold(0.0, (sum, i) => sum + i.grandTotal);
  double get creditSales => allInvoices.where((i) => i.paymentType == PaymentType.credit).fold(0.0, (sum, i) => sum + i.grandTotal);

  @override
  List<Object?> get props => [
        allInvoices,
        filteredInvoices,
        selectedDateRange,
        selectedPaymentFilter,
        searchQuery,
      ];
}

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final InvoiceRepository repository;

  SalesBloc({required this.repository}) : super(SalesInitial()) {
    on<LoadSalesEvent>((event, emit) async {
      emit(SalesLoading());
      final invoices = await repository.getInvoices('biz_1');
      emit(SalesLoaded(allInvoices: invoices, filteredInvoices: invoices));
    });

    on<FilterSalesEvent>((event, emit) {
      if (state is SalesLoaded) {
        final currentState = state as SalesLoaded;
        final query = event.searchQuery.toLowerCase();
        final now = DateTime.now();
        final todayStart = DateTime(now.year, now.month, now.day);
        
        final filtered = currentState.allInvoices.where((inv) {
          final matchesQuery = inv.invoiceNumber.toLowerCase().contains(query) ||
                               inv.customerName.toLowerCase().contains(query);
          
          bool matchesPayment = true;
          if (event.paymentFilter != 'All') {
            if (event.paymentFilter.toLowerCase() == 'pending') {
              matchesPayment = inv.dueAmount > 0 || inv.paymentType == PaymentType.credit || inv.status == InvoiceStatus.credit;
            } else {
              matchesPayment = inv.paymentType.name.toLowerCase() == event.paymentFilter.toLowerCase();
            }
          }

          bool matchesDate = true;
          final d = event.dateRange.toLowerCase();
          if (d == 'today') {
            matchesDate = inv.invoiceDate.isAfter(todayStart.subtract(const Duration(seconds: 1)));
          } else if (d == '7 days') {
            matchesDate = inv.invoiceDate.isAfter(now.subtract(const Duration(days: 7)));
          } else if (d == '30 days') {
            matchesDate = inv.invoiceDate.isAfter(now.subtract(const Duration(days: 30)));
          }

          return matchesQuery && matchesPayment && matchesDate;
        }).toList();

        emit(SalesLoaded(
          allInvoices: currentState.allInvoices,
          filteredInvoices: filtered,
          selectedDateRange: event.dateRange,
          selectedPaymentFilter: event.paymentFilter,
          searchQuery: event.searchQuery,
        ));
      }
    });

    on<CancelInvoiceEvent>((event, emit) async {
      await repository.cancelInvoice(event.invoiceId);
      add(LoadSalesEvent());
    });
  }
}
