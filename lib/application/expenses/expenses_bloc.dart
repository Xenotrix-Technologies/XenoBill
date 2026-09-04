import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';
import '../../infrastructure/database/app_database.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();
  @override
  List<Object?> get props => [];
}

class LoadExpensesEvent extends ExpensesEvent {}

class AddExpenseEvent extends ExpensesEvent {
  final Expense expense;
  const AddExpenseEvent(this.expense);
  @override
  List<Object?> get props => [expense];
}

abstract class ExpensesState extends Equatable {
  const ExpensesState();
  @override
  List<Object?> get props => [];
}

class ExpensesInitial extends ExpensesState {}
class ExpensesLoading extends ExpensesState {}
class ExpensesLoaded extends ExpensesState {
  final List<Expense> expenses;

  const ExpensesLoaded(this.expenses);

  double get totalExpenses => expenses.fold(0.0, (sum, e) => sum + e.amount);
  double get todayExpenses => expenses
      .where((e) => e.date.year == DateTime.now().year && e.date.month == DateTime.now().month && e.date.day == DateTime.now().day)
      .fold(0.0, (sum, e) => sum + e.amount);

  @override
  List<Object?> get props => [expenses];
}

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<LoadExpensesEvent>((event, emit) {
      emit(ExpensesLoading());
      emit(ExpensesLoaded(List.from(AppDatabase.instance.expenses)));
    });

    on<AddExpenseEvent>((event, emit) async {
      AppDatabase.instance.expenses.insert(0, event.expense);
      await AppDatabase.instance.saveLocalState();
      add(LoadExpensesEvent());
    });
  }
}
