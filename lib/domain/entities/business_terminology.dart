import 'package:equatable/equatable.dart';
import 'business_type.dart';

class BusinessTerminology extends Equatable {
  final String item;
  final String items;
  final String addItem;
  final String customer;
  final String customers;
  final String addCustomer;
  final String invoice;
  final String invoices;
  final String addInvoice;
  final String inventory;
  final String shopSectionTitle;

  const BusinessTerminology({
    required this.item,
    required this.items,
    required this.addItem,
    required this.customer,
    required this.customers,
    required this.addCustomer,
    required this.invoice,
    required this.invoices,
    required this.addInvoice,
    required this.inventory,
    required this.shopSectionTitle,
  });

  factory BusinessTerminology.fromBusinessType(BusinessType type) {
    switch (type) {
      case BusinessType.restaurant:
      case BusinessType.cafe:
      case BusinessType.bakery:
        return const BusinessTerminology(
          item: 'Item',
          items: 'Menu Items',
          addItem: 'Add Item',
          customer: 'Customer',
          customers: 'Customers',
          addCustomer: 'Add Customer',
          invoice: 'Order',
          invoices: 'Orders',
          addInvoice: 'New Order',
          inventory: 'Menu',
          shopSectionTitle: 'Menu',
        );

      case BusinessType.hotel:
        return const BusinessTerminology(
          item: 'Charge',
          items: 'Rooms & Services',
          addItem: 'Add Charge',
          customer: 'Guest',
          customers: 'Guests',
          addCustomer: 'Add Guest',
          invoice: 'Bill',
          invoices: 'Bills',
          addInvoice: 'New Booking',
          inventory: 'Rooms',
          shopSectionTitle: 'Hotel',
        );

      case BusinessType.salon:
      case BusinessType.beauty:
      case BusinessType.spa:
      case BusinessType.service:
      case BusinessType.freelancer:
      case BusinessType.professionalService:
        return const BusinessTerminology(
          item: 'Service',
          items: 'Services',
          addItem: 'Add Service',
          customer: 'Client',
          customers: 'Clients',
          addCustomer: 'Add Client',
          invoice: 'Invoice',
          invoices: 'Invoices',
          addInvoice: 'Create Invoice',
          inventory: 'Services',
          shopSectionTitle: 'Business',
        );

      case BusinessType.repair:
        return const BusinessTerminology(
          item: 'Service / Part',
          items: 'Services & Parts',
          addItem: 'Add Service/Part',
          customer: 'Customer',
          customers: 'Customers',
          addCustomer: 'Add Customer',
          invoice: 'Job Sheet',
          invoices: 'Job Sheets',
          addInvoice: 'New Job',
          inventory: 'Inventory & Repair',
          shopSectionTitle: 'Business',
        );

      case BusinessType.retail:
      case BusinessType.wholesale:
      case BusinessType.supermarket:
      case BusinessType.mixed:
      case BusinessType.other:
        return const BusinessTerminology(
          item: 'Product',
          items: 'Products',
          addItem: 'Add Product',
          customer: 'Customer',
          customers: 'Customers',
          addCustomer: 'Add Customer',
          invoice: 'Invoice',
          invoices: 'Invoices',
          addInvoice: 'Add Invoice',
          inventory: 'Inventory',
          shopSectionTitle: 'Shop',
        );
    }
  }

  @override
  List<Object?> get props => [
        item,
        items,
        addItem,
        customer,
        customers,
        addCustomer,
        invoice,
        invoices,
        addInvoice,
        inventory,
        shopSectionTitle,
      ];
}
