import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/repositories.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
  @override
  List<Object?> get props => [];
}

class LoadReportsEvent extends ReportsEvent {
  final String dateRange; // 'Today', '7 Days', '30 Days', 'This Month'
  const LoadReportsEvent({this.dateRange = '7 Days'});
  @override
  List<Object?> get props => [dateRange];
}

abstract class ReportsState extends Equatable {
  const ReportsState();
  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}
class ReportsLoading extends ReportsState {}
class ReportsLoaded extends ReportsState {
  final String selectedDateRange;
  final double grossSales;
  final double totalDiscount;
  final double totalTax;
  final double netSales;
  final double cashTotal;
  final double creditTotal;
  final double upiTotal;
  final double cardTotal;
  final int totalInvoices;
  final double taxableSales;
  final double cgstTotal;
  final double sgstTotal;
  final double igstTotal;

  const ReportsLoaded({
    required this.selectedDateRange,
    required this.grossSales,
    required this.totalDiscount,
    required this.totalTax,
    required this.netSales,
    required this.cashTotal,
    required this.creditTotal,
    required this.upiTotal,
    required this.cardTotal,
    required this.totalInvoices,
    required this.taxableSales,
    required this.cgstTotal,
    required this.sgstTotal,
    required this.igstTotal,
  });

  @override
  List<Object?> get props => [
        selectedDateRange,
        grossSales,
        totalDiscount,
        totalTax,
        netSales,
        cashTotal,
        creditTotal,
        upiTotal,
        cardTotal,
        totalInvoices,
        taxableSales,
        cgstTotal,
        sgstTotal,
        igstTotal,
      ];
}

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final InvoiceRepository repository;

  ReportsBloc({required this.repository}) : super(ReportsInitial()) {
    on<LoadReportsEvent>((event, emit) async {
      emit(ReportsLoading());
      final invoices = await repository.getInvoices('biz_1');

      double gross = 0.0;
      double disc = 0.0;
      double tax = 0.0;
      double net = 0.0;
      double cash = 0.0;
      double credit = 0.0;
      double upi = 0.0;
      double card = 0.0;
      double taxable = 0.0;
      double cgst = 0.0;
      double sgst = 0.0;
      double igst = 0.0;

      for (final inv in invoices) {
        if (inv.status == InvoiceStatus.cancelled) continue;
        gross += inv.subtotal;
        disc += inv.discount;
        cgst += inv.cgst;
        sgst += inv.sgst;
        igst += inv.igst;
        tax += (inv.cgst + inv.sgst + inv.igst);
        net += inv.grandTotal;
        taxable += (inv.subtotal - inv.discount);

        switch (inv.paymentType) {
          case PaymentType.cash:
            cash += inv.grandTotal;
            break;
          case PaymentType.credit:
            credit += inv.grandTotal;
            break;
          case PaymentType.upi:
            upi += inv.grandTotal;
            break;
          case PaymentType.card:
            card += inv.grandTotal;
            break;
        }
      }

      emit(ReportsLoaded(
        selectedDateRange: event.dateRange,
        grossSales: gross,
        totalDiscount: disc,
        totalTax: tax,
        netSales: net,
        cashTotal: cash,
        creditTotal: credit,
        upiTotal: upi,
        cardTotal: card,
        totalInvoices: invoices.where((i) => i.status != InvoiceStatus.cancelled).length,
        taxableSales: taxable,
        cgstTotal: cgst,
        sgstTotal: sgst,
        igstTotal: igst,
      ));
    });
  }
}
