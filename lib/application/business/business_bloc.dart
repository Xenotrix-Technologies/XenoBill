import 'dart:async';
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

class _DriftBusinessUpdatedEvent extends BusinessEvent {
  final Business? business;
  const _DriftBusinessUpdatedEvent(this.business);
  @override
  List<Object?> get props => [business];
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
  StreamSubscription<Business?>? _driftSubscription;

  BusinessBloc({required this.repository}) : super(BusinessInitial()) {
    on<LoadBusinessEvent>(_onLoadBusiness);
    on<UpdateBusinessEvent>(_onUpdateBusiness);
    on<ToggleDemoModeEvent>(_onToggleDemoMode);
    on<_DriftBusinessUpdatedEvent>(_onDriftBusinessUpdated);

    // Watch local Drift database stream
    _driftSubscription = repository.watchCurrentBusiness().listen((biz) {
      add(_DriftBusinessUpdatedEvent(biz));
    });
  }

  Future<void> _onLoadBusiness(LoadBusinessEvent event, Emitter<BusinessState> emit) async {
    emit(BusinessLoading());
    // Trigger non-blocking cloud sync in background
    repository.syncBusiness();

    final current = await repository.getCurrentBusiness();
    if (current != null) {
      emit(BusinessLoaded(current, isDemoMode: AppDatabase.instance.isDemoMode));
    } else if (AppDatabase.instance.currentBusiness != null) {
      emit(BusinessLoaded(AppDatabase.instance.currentBusiness!, isDemoMode: AppDatabase.instance.isDemoMode));
    } else {
      emit(BusinessInitial());
    }
  }

  Future<void> _onUpdateBusiness(UpdateBusinessEvent event, Emitter<BusinessState> emit) async {
    // Local-first write: update Drift database immediately
    await repository.updateBusiness(event.business);
    emit(BusinessLoaded(event.business, isDemoMode: false));
  }

  Future<void> _onToggleDemoMode(ToggleDemoModeEvent event, Emitter<BusinessState> emit) async {
    if (event.enableDemo) {
      AppDatabase.instance.loadDemoData();
    } else {
      AppDatabase.instance.isDemoMode = false;
    }
    await AppDatabase.instance.saveLocalState();
    if (AppDatabase.instance.currentBusiness != null) {
      emit(BusinessLoaded(AppDatabase.instance.currentBusiness!, isDemoMode: AppDatabase.instance.isDemoMode));
    }
  }

  void _onDriftBusinessUpdated(_DriftBusinessUpdatedEvent event, Emitter<BusinessState> emit) {
    if (event.business != null && !AppDatabase.instance.isDemoMode) {
      emit(BusinessLoaded(event.business!, isDemoMode: false));
    }
  }

  @override
  Future<void> close() {
    _driftSubscription?.cancel();
    return super.close();
  }
}
