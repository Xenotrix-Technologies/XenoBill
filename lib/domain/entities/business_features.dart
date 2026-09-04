import 'package:equatable/equatable.dart';
import 'business_type.dart';

class BusinessFeatures extends Equatable {
  final bool inventoryEnabled;
  final bool productsEnabled;
  final bool servicesEnabled;
  final bool customersEnabled;
  final bool creditSalesEnabled;
  final bool gstEnabled;
  final bool expenseTrackingEnabled;
  final bool smartInsightsEnabled;
  final bool printingEnabled;
  final bool restaurantEnabled;
  final bool hotelEnabled;
  final bool roomsEnabled;
  final bool guestManagementEnabled;
  final bool barcodeEnabled;
  final bool stockTrackingEnabled;

  const BusinessFeatures({
    required this.inventoryEnabled,
    required this.productsEnabled,
    required this.servicesEnabled,
    required this.customersEnabled,
    required this.creditSalesEnabled,
    required this.gstEnabled,
    required this.expenseTrackingEnabled,
    required this.smartInsightsEnabled,
    required this.printingEnabled,
    required this.restaurantEnabled,
    required this.hotelEnabled,
    required this.roomsEnabled,
    required this.guestManagementEnabled,
    required this.barcodeEnabled,
    required this.stockTrackingEnabled,
  });

  factory BusinessFeatures.fromBusinessType(dynamic type) {
    if (type is BusinessType) {
      return type.defaultFeatures;
    }
    final bType = BusinessType.fromString(type.toString());
    return bType.defaultFeatures;
  }

  BusinessFeatures copyWith({
    bool? inventoryEnabled,
    bool? productsEnabled,
    bool? servicesEnabled,
    bool? customersEnabled,
    bool? creditSalesEnabled,
    bool? gstEnabled,
    bool? expenseTrackingEnabled,
    bool? smartInsightsEnabled,
    bool? printingEnabled,
    bool? restaurantEnabled,
    bool? hotelEnabled,
    bool? roomsEnabled,
    bool? guestManagementEnabled,
    bool? barcodeEnabled,
    bool? stockTrackingEnabled,
  }) {
    return BusinessFeatures(
      inventoryEnabled: inventoryEnabled ?? this.inventoryEnabled,
      productsEnabled: productsEnabled ?? this.productsEnabled,
      servicesEnabled: servicesEnabled ?? this.servicesEnabled,
      customersEnabled: customersEnabled ?? this.customersEnabled,
      creditSalesEnabled: creditSalesEnabled ?? this.creditSalesEnabled,
      gstEnabled: gstEnabled ?? this.gstEnabled,
      expenseTrackingEnabled: expenseTrackingEnabled ?? this.expenseTrackingEnabled,
      smartInsightsEnabled: smartInsightsEnabled ?? this.smartInsightsEnabled,
      printingEnabled: printingEnabled ?? this.printingEnabled,
      restaurantEnabled: restaurantEnabled ?? this.restaurantEnabled,
      hotelEnabled: hotelEnabled ?? this.hotelEnabled,
      roomsEnabled: roomsEnabled ?? this.roomsEnabled,
      guestManagementEnabled: guestManagementEnabled ?? this.guestManagementEnabled,
      barcodeEnabled: barcodeEnabled ?? this.barcodeEnabled,
      stockTrackingEnabled: stockTrackingEnabled ?? this.stockTrackingEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventoryEnabled': inventoryEnabled,
      'productsEnabled': productsEnabled,
      'servicesEnabled': servicesEnabled,
      'customersEnabled': customersEnabled,
      'creditSalesEnabled': creditSalesEnabled,
      'gstEnabled': gstEnabled,
      'expenseTrackingEnabled': expenseTrackingEnabled,
      'smartInsightsEnabled': smartInsightsEnabled,
      'printingEnabled': printingEnabled,
      'restaurantEnabled': restaurantEnabled,
      'hotelEnabled': hotelEnabled,
      'roomsEnabled': roomsEnabled,
      'guestManagementEnabled': guestManagementEnabled,
      'barcodeEnabled': barcodeEnabled,
      'stockTrackingEnabled': stockTrackingEnabled,
    };
  }

  factory BusinessFeatures.fromJson(Map<String, dynamic> json) {
    return BusinessFeatures(
      inventoryEnabled: json['inventoryEnabled'] ?? true,
      productsEnabled: json['productsEnabled'] ?? true,
      servicesEnabled: json['servicesEnabled'] ?? false,
      customersEnabled: json['customersEnabled'] ?? true,
      creditSalesEnabled: json['creditSalesEnabled'] ?? true,
      gstEnabled: json['gstEnabled'] ?? true,
      expenseTrackingEnabled: json['expenseTrackingEnabled'] ?? true,
      smartInsightsEnabled: json['smartInsightsEnabled'] ?? true,
      printingEnabled: json['printingEnabled'] ?? true,
      restaurantEnabled: json['restaurantEnabled'] ?? false,
      hotelEnabled: json['hotelEnabled'] ?? false,
      roomsEnabled: json['roomsEnabled'] ?? false,
      guestManagementEnabled: json['guestManagementEnabled'] ?? false,
      barcodeEnabled: json['barcodeEnabled'] ?? true,
      stockTrackingEnabled: json['stockTrackingEnabled'] ?? true,
    );
  }

  @override
  List<Object?> get props => [
        inventoryEnabled,
        productsEnabled,
        servicesEnabled,
        customersEnabled,
        creditSalesEnabled,
        gstEnabled,
        expenseTrackingEnabled,
        smartInsightsEnabled,
        printingEnabled,
        restaurantEnabled,
        hotelEnabled,
        roomsEnabled,
        guestManagementEnabled,
        barcodeEnabled,
        stockTrackingEnabled,
      ];
}
