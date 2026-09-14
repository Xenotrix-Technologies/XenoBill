import 'package:flutter/material.dart';
import 'business_features.dart';
import 'business_terminology.dart';

enum BusinessType {
  retail,
  wholesale,
  supermarket,
  pharmacy,
  textiles,
  salon,
  beauty,
  spa,
  repair,
  service,
  freelancer,
  professionalService,
  mixed,
  other;

  static BusinessType fromString(String? val) {
    if (val == null || val.isEmpty) return BusinessType.retail;
    final lower = val.toLowerCase();
    if (lower.contains('pharmacy') || lower.contains('medical')) return BusinessType.pharmacy;
    if (lower.contains('textile') || lower.contains('garment') || lower.contains('clothing') || lower.contains('apparel')) return BusinessType.textiles;
    if (lower.contains('supermarket')) return BusinessType.supermarket;
    if (lower.contains('wholesale')) return BusinessType.wholesale;
    if (lower.contains('salon')) return BusinessType.salon;
    if (lower.contains('beauty')) return BusinessType.beauty;
    if (lower.contains('spa')) return BusinessType.spa;
    if (lower.contains('repair')) return BusinessType.repair;
    if (lower.contains('freelancer')) return BusinessType.freelancer;
    if (lower.contains('professional')) return BusinessType.professionalService;
    if (lower.contains('service')) return BusinessType.service;
    if (lower.contains('mixed')) return BusinessType.mixed;
    if (lower.contains('other')) return BusinessType.other;
    return BusinessType.retail;
  }
}

extension BusinessTypeX on BusinessType {
  String get displayName {
    switch (this) {
      case BusinessType.retail:
        return 'Retail Shop';
      case BusinessType.wholesale:
        return 'Wholesale';
      case BusinessType.supermarket:
        return 'Supermarket';
      case BusinessType.pharmacy:
        return 'Pharmacy / Medical';
      case BusinessType.textiles:
        return 'Textiles & Garments';
      case BusinessType.salon:
        return 'Salon / Beauty';
      case BusinessType.beauty:
        return 'Beauty Parlour';
      case BusinessType.spa:
        return 'Spa & Wellness';
      case BusinessType.repair:
        return 'Repair Shop';
      case BusinessType.service:
        return 'Service Business';
      case BusinessType.freelancer:
        return 'Freelancer';
      case BusinessType.professionalService:
        return 'Professional Services';
      case BusinessType.mixed:
        return 'Mixed Business';
      case BusinessType.other:
        return 'Other Business';
    }
  }

  String get description {
    switch (this) {
      case BusinessType.retail:
        return 'Products, inventory, stock tracking & retail billing';
      case BusinessType.wholesale:
        return 'Products, bulk sales & customer credit management';
      case BusinessType.supermarket:
        return 'Groceries, barcode scanning, stock & fast billing';
      case BusinessType.pharmacy:
        return 'Medicines, batches, prescriptions & retail billing';
      case BusinessType.textiles:
        return 'Clothing, apparel, sizes/variants & retail billing';
      case BusinessType.salon:
        return 'Styling services, appointments, customers & billing';
      case BusinessType.beauty:
        return 'Beauty treatments, services & customer records';
      case BusinessType.spa:
        return 'Wellness therapies, packages & customer billing';
      case BusinessType.repair:
        return 'Device/vehicle repairs, spare parts & service billing';
      case BusinessType.service:
        return 'Professional services, clients & custom invoices';
      case BusinessType.freelancer:
        return 'Project billing, clients & simple invoice generation';
      case BusinessType.professionalService:
        return 'Consulting, hourly/job billing & client ledgers';
      case BusinessType.mixed:
        return 'Both physical products & billable services';
      case BusinessType.other:
        return 'Customize your own workspace features & modules';
    }
  }

  IconData get icon {
    switch (this) {
      case BusinessType.retail:
        return Icons.storefront;
      case BusinessType.wholesale:
        return Icons.inventory_2;
      case BusinessType.supermarket:
        return Icons.shopping_cart;
      case BusinessType.pharmacy:
        return Icons.medical_services;
      case BusinessType.textiles:
        return Icons.checkroom;
      case BusinessType.salon:
      case BusinessType.beauty:
      case BusinessType.spa:
        return Icons.content_cut;
      case BusinessType.repair:
        return Icons.build;
      case BusinessType.service:
      case BusinessType.freelancer:
      case BusinessType.professionalService:
        return Icons.business_center;
      case BusinessType.mixed:
        return Icons.category;
      case BusinessType.other:
        return Icons.tune;
    }
  }

  BusinessFeatures get defaultFeatures {
    switch (this) {
      case BusinessType.retail:
      case BusinessType.wholesale:
      case BusinessType.supermarket:
      case BusinessType.pharmacy:
      case BusinessType.textiles:
        return const BusinessFeatures(
          inventoryEnabled: true,
          productsEnabled: true,
          servicesEnabled: false,
          customersEnabled: true,
          creditSalesEnabled: true,
          gstEnabled: true,
          expenseTrackingEnabled: true,
          smartInsightsEnabled: true,
          printingEnabled: true,
          restaurantEnabled: false,
          hotelEnabled: false,
          roomsEnabled: false,
          guestManagementEnabled: false,
          barcodeEnabled: true,
          stockTrackingEnabled: true,
        );

      case BusinessType.salon:
      case BusinessType.beauty:
      case BusinessType.spa:
      case BusinessType.service:
      case BusinessType.freelancer:
      case BusinessType.professionalService:
        return const BusinessFeatures(
          inventoryEnabled: false,
          productsEnabled: false,
          servicesEnabled: true,
          customersEnabled: true,
          creditSalesEnabled: true,
          gstEnabled: true,
          expenseTrackingEnabled: true,
          smartInsightsEnabled: true,
          printingEnabled: true,
          restaurantEnabled: false,
          hotelEnabled: false,
          roomsEnabled: false,
          guestManagementEnabled: false,
          barcodeEnabled: false,
          stockTrackingEnabled: false,
        );

      case BusinessType.repair:
      case BusinessType.mixed:
      case BusinessType.other:
        return const BusinessFeatures(
          inventoryEnabled: true,
          productsEnabled: true,
          servicesEnabled: true,
          customersEnabled: true,
          creditSalesEnabled: true,
          gstEnabled: true,
          expenseTrackingEnabled: true,
          smartInsightsEnabled: true,
          printingEnabled: true,
          restaurantEnabled: false,
          hotelEnabled: false,
          roomsEnabled: false,
          guestManagementEnabled: false,
          barcodeEnabled: true,
          stockTrackingEnabled: true,
        );
    }
  }

  BusinessTerminology get defaultTerminology {
    return BusinessTerminology.fromBusinessType(this);
  }
}
