import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/business.dart';
import '../../domain/repositories/repositories.dart';
import '../../infrastructure/database/app_database.dart';

abstract class BusinessEvent extends Equatable {
  const BusinessEvent();
  @override
  List<Object?> get props => [];
}

class LoadBusinessEvent extends BusinessEvent {}

class UpdateBusinessEvent extends BusinessEvent {
  final Business business;
  const UpdateBusinessEvent(this.business);
  @override
  List<Object?> get props => [business];
}

class ToggleDemoModeEvent extends BusinessEvent {
  final bool enableDemo;
  const ToggleDemoModeEvent(this.enableDemo);
  @override
  List<Object?> get props => [enableDemo];
}

abstract class BusinessState extends Equatable {
  const BusinessState();
  @override
  List<Object?> get props => [];
}

class BusinessInitial extends BusinessState {}
class BusinessLoading extends BusinessState {}
class BusinessLoaded extends BusinessState {
  final Business business;
  final bool isDemoMode;
  const BusinessLoaded(this.business, {this.isDemoMode = false});
  @override
  List<Object?> get props => [business, isDemoMode];
}

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessRepository repository;

  BusinessBloc({required this.repository}) : super(BusinessInitial()) {
    on<LoadBusinessEvent>((event, emit) async {
      emit(BusinessLoading());
      if (AppDatabase.instance.currentBusiness != null) {
        emit(BusinessLoaded(AppDatabase.instance.currentBusiness!, isDemoMode: AppDatabase.instance.isDemoMode));
      } else {
        final biz = await repository.getBusiness('biz_1');
        if (biz != null) {
          emit(BusinessLoaded(biz, isDemoMode: AppDatabase.instance.isDemoMode));
        } else {
          // If no business exists, load demo as fallback
          AppDatabase.instance.loadDemoData();
          emit(BusinessLoaded(AppDatabase.instance.currentBusiness!, isDemoMode: true));
        }
      }
    });

    on<UpdateBusinessEvent>((event, emit) async {
      await AppDatabase.instance.createNewBusiness(event.business);
      await repository.saveBusiness(event.business);
      emit(BusinessLoaded(event.business, isDemoMode: false));
    });

    on<ToggleDemoModeEvent>((event, emit) async {
      if (event.enableDemo) {
        AppDatabase.instance.loadDemoData();
      } else {
        AppDatabase.instance.isDemoMode = false;
      }
      await AppDatabase.instance.saveLocalState();
      if (AppDatabase.instance.currentBusiness != null) {
        emit(BusinessLoaded(AppDatabase.instance.currentBusiness!, isDemoMode: AppDatabase.instance.isDemoMode));
      }
    });
  }
}
