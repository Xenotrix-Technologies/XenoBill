import 'package:flutter_test/flutter_test.dart';
import 'package:xenobill_flutter/domain/entities/business_type.dart';
import 'package:xenobill_flutter/domain/entities/business.dart';

void main() {
  group('Business Type Adaptive Configuration Tests', () {
    test('Retail business type provides correct feature defaults and terminology', () {
      const type = BusinessType.retail;
      final features = type.defaultFeatures;
      final terminology = type.defaultTerminology;

      expect(features.productsEnabled, isTrue);
      expect(features.inventoryEnabled, isTrue);
      expect(features.servicesEnabled, isFalse);
      expect(features.hotelEnabled, isFalse);
      expect(features.restaurantEnabled, isFalse);

      expect(terminology.item, equals('Product'));
      expect(terminology.items, equals('Products'));
      expect(terminology.shopSectionTitle, equals('Shop'));
    });

    test('Service business type provides correct feature defaults and terminology', () {
      const type = BusinessType.service;
      final features = type.defaultFeatures;
      final terminology = type.defaultTerminology;

      expect(features.productsEnabled, isFalse);
      expect(features.inventoryEnabled, isFalse);
      expect(features.servicesEnabled, isTrue);
      expect(features.hotelEnabled, isFalse);

      expect(terminology.item, equals('Service'));
      expect(terminology.items, equals('Services'));
      expect(terminology.customer, equals('Client'));
      expect(terminology.shopSectionTitle, equals('Business'));
    });

    test('Pharmacy business type provides correct feature defaults and terminology', () {
      const type = BusinessType.pharmacy;
      final features = type.defaultFeatures;
      final terminology = type.defaultTerminology;

      expect(features.productsEnabled, isTrue);
      expect(features.inventoryEnabled, isTrue);
      expect(features.stockTrackingEnabled, isTrue);
      expect(features.barcodeEnabled, isTrue);

      expect(terminology.item, equals('Product'));
      expect(terminology.items, equals('Products'));
      expect(terminology.shopSectionTitle, equals('Shop'));
    });

    test('Textiles business type provides retail feature defaults and terminology', () {
      const type = BusinessType.textiles;
      final features = type.defaultFeatures;
      final terminology = type.defaultTerminology;

      expect(features.productsEnabled, isTrue);
      expect(features.inventoryEnabled, isTrue);
      expect(features.stockTrackingEnabled, isTrue);

      expect(terminology.item, equals('Product'));
      expect(terminology.invoice, equals('Invoice'));
      expect(terminology.shopSectionTitle, equals('Shop'));
    });

    test('Business entity encapsulates configuration properly', () {
      final biz = Business(
        id: 'b1',
        name: 'Apex Salon',
        businessType: BusinessType.salon,
        phone: '9876543210',
        address: 'Main St',
        gstEnabled: true,
        gstin: '27AABCU9603R1ZM',
        invoicePrefix: 'INV',
        nextInvoiceNumber: 1001,
      );

      expect(biz.type, equals(BusinessType.salon));
      expect(biz.businessType, equals('Salon / Beauty'));
      expect(biz.configuration.isService, isTrue);
      expect(biz.terminology.item, equals('Service'));
      expect(biz.features.servicesEnabled, isTrue);
    });
  });
}
