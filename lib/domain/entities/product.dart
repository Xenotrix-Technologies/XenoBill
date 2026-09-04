import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String businessId;
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final double mrp;
  final double gstRate; // e.g. 5, 12, 18, 28
  final int currentStock;
  final int lowStockLimit;
  final String? imagePath;

  const Product({
    required this.id,
    required this.businessId,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.mrp,
    required this.gstRate,
    required this.currentStock,
    required this.lowStockLimit,
    this.imagePath,
  });

  bool get isLowStock => currentStock <= lowStockLimit;
  bool get isOutOfStock => currentStock <= 0;

  Product copyWith({
    String? id,
    String? businessId,
    String? name,
    String? sku,
    String? barcode,
    String? category,
    String? unit,
    double? purchasePrice,
    double? sellingPrice,
    double? mrp,
    double? gstRate,
    int? currentStock,
    int? lowStockLimit,
    String? imagePath,
  }) {
    return Product(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrp: mrp ?? this.mrp,
      gstRate: gstRate ?? this.gstRate,
      currentStock: currentStock ?? this.currentStock,
      lowStockLimit: lowStockLimit ?? this.lowStockLimit,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        businessId,
        name,
        sku,
        barcode,
        category,
        unit,
        purchasePrice,
        sellingPrice,
        mrp,
        gstRate,
        currentStock,
        lowStockLimit,
        imagePath,
      ];
}
