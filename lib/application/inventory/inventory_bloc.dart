import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/repositories.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadInventoryEvent extends InventoryEvent {}

class SearchInventoryEvent extends InventoryEvent {
  final String query;
  const SearchInventoryEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class AddProductEvent extends InventoryEvent {
  final Item item;
  const AddProductEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class UpdateProductEvent extends InventoryEvent {
  final Item item;
  const UpdateProductEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class AdjustStockEvent extends InventoryEvent {
  final String productId;
  final int newStock;
  const AdjustStockEvent({required this.productId, required this.newStock});
  @override
  List<Object?> get props => [productId, newStock];
}

abstract class InventoryState extends Equatable {
  const InventoryState();
  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}
class InventoryLoading extends InventoryState {}
class InventoryLoaded extends InventoryState {
  final List<Item> products;
  final List<Item> filteredProducts;
  final String searchQuery;

  const InventoryLoaded({
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
  });

  int get totalProducts => products.where((p) => p.isProduct).length;
  int get totalServices => products.where((p) => p.isService).length;
  int get lowStockCount => products.where((p) => p.isLowStock).length;
  int get outOfStockCount => products.where((p) => p.isOutOfStock).length;
  double get totalStockValue => products.where((p) => p.isProduct).fold(0.0, (sum, p) => sum + (p.purchasePrice * p.currentStock));

  @override
  List<Object?> get props => [products, filteredProducts, searchQuery];
}

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final ProductRepository repository;

  InventoryBloc({required this.repository}) : super(InventoryInitial()) {
    on<LoadInventoryEvent>((event, emit) async {
      emit(InventoryLoading());
      final items = await repository.getProducts('biz_1');
      emit(InventoryLoaded(products: items, filteredProducts: items));
    });

    on<SearchInventoryEvent>((event, emit) {
      if (state is InventoryLoaded) {
        final currentState = state as InventoryLoaded;
        final query = event.query.toLowerCase();
        final filtered = currentState.products.where((p) {
          return p.name.toLowerCase().contains(query) ||
                 p.sku.toLowerCase().contains(query) ||
                 p.barcode.toLowerCase().contains(query) ||
                 p.category.toLowerCase().contains(query);
        }).toList();
        emit(InventoryLoaded(
          products: currentState.products,
          filteredProducts: filtered,
          searchQuery: event.query,
        ));
      }
    });

    on<AddProductEvent>((event, emit) async {
      await repository.addProduct(event.item);
      add(LoadInventoryEvent());
    });

    on<UpdateProductEvent>((event, emit) async {
      await repository.updateProduct(event.item);
      add(LoadInventoryEvent());
    });

    on<AdjustStockEvent>((event, emit) async {
      await repository.updateStock(event.productId, event.newStock);
      add(LoadInventoryEvent());
    });
  }
}
