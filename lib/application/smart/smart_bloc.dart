import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/smart_insight.dart';
import '../../infrastructure/database/app_database.dart';

abstract class SmartEvent extends Equatable {
  const SmartEvent();
  @override
  List<Object?> get props => [];
}

class LoadSmartInsightsEvent extends SmartEvent {}

abstract class SmartState extends Equatable {
  const SmartState();
  @override
  List<Object?> get props => [];
}

class SmartInitial extends SmartState {}
class SmartLoading extends SmartState {}
class SmartLoaded extends SmartState {
  final List<SmartInsight> insights;
  final double netProfit;
  final bool hasSufficientData;

  const SmartLoaded({
    required this.insights,
    required this.netProfit,
    required this.hasSufficientData,
  });

  @override
  List<Object?> get props => [insights, netProfit, hasSufficientData];
}

class SmartBloc extends Bloc<SmartEvent, SmartState> {
  SmartBloc() : super(SmartInitial()) {
    on<LoadSmartInsightsEvent>((event, emit) {
      emit(SmartLoading());

      final db = AppDatabase.instance;
      final invoices = db.invoices;
      final expenses = db.expenses;
      final items = db.items;

      double totalRevenue = invoices.fold(0.0, (sum, i) => sum + i.grandTotal);
      double totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);

      // Estimate item costs
      double totalItemCost = 0.0;
      for (final inv in invoices) {
        for (final item in inv.items) {
          try {
            final prod = items.firstWhere((p) => p.id == item.productId);
            totalItemCost += (prod.purchasePrice * item.quantity);
          } catch (_) {}
        }
      }

      final netProfit = totalRevenue - totalItemCost - totalExpenses;
      final hasData = invoices.isNotEmpty || items.isNotEmpty;

      final dynamicInsights = List<SmartInsight>.from(db.smartInsights);

      // Calculate low stock dynamically
      final lowItems = items.where((i) => i.isLowStock).toList();
      if (lowItems.isNotEmpty) {
        dynamicInsights.add(
          SmartInsight(
            id: 'dyn_low_stock',
            title: '${lowItems.length} Products Low on Stock',
            message: '${lowItems.first.name} is running below safety stock level.',
            category: 'Inventory',
            actionLabel: 'View Shop',
            actionRoute: '/shop',
            isPositive: false,
          ),
        );
      }

      emit(SmartLoaded(
        insights: dynamicInsights,
        netProfit: netProfit,
        hasSufficientData: hasData,
      ));
    });
  }
}
