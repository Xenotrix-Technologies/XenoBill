import '../../domain/entities/business.dart';
import '../../domain/entities/business_features.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/smart_insight.dart';

class DemoData {
  DemoData._();

  static const String demoBusinessId = 'biz_demo_101';

  static final Business demoBusiness = Business(
    id: demoBusinessId,
    name: 'Xeno Universal Store & Services',
    businessType: 'Retail & Service Business',
    phone: '9876543210',
    email: 'contact@xenobiz.com',
    address: 'Shop #14, Main Market, MG Road, Mumbai',
    gstEnabled: true,
    gstin: '27AABCU9603R1ZM',
    currency: '₹',
    invoicePrefix: 'INV',
    nextInvoiceNumber: 1026,
    features: BusinessFeatures.fromBusinessType('Retail & Service Business'),
  );

  static final List<Item> demoItems = [
    const Item(
      id: 'item_1',
      businessId: demoBusinessId,
      type: ItemType.product,
      name: 'Basmati Rice 5kg',
      sku: 'RICE-005',
      barcode: '890123456701',
      category: 'Groceries',
      unit: 'Pack',
      sellingPrice: 350.0,
      purchasePrice: 280.0,
      mrp: 380.0,
      gstRate: 5.0,
      currentStock: 24,
      lowStockLimit: 5,
    ),
    const Item(
      id: 'item_2',
      businessId: demoBusinessId,
      type: ItemType.product,
      name: 'Refined Sugar 1kg',
      sku: 'SUG-001',
      barcode: '890123456702',
      category: 'Groceries',
      unit: 'kg',
      sellingPrice: 45.0,
      purchasePrice: 38.0,
      mrp: 50.0,
      gstRate: 5.0,
      currentStock: 48,
      lowStockLimit: 10,
    ),
    const Item(
      id: 'item_3',
      businessId: demoBusinessId,
      type: ItemType.service,
      name: 'Haircut & Styling',
      description: 'Professional hair trimming and styling',
      category: 'Salon Services',
      unit: 'Service',
      sellingPrice: 300.0,
      gstRate: 18.0,
      durationMinutes: 30,
    ),
    const Item(
      id: 'item_4',
      businessId: demoBusinessId,
      type: ItemType.service,
      name: 'Smartphone Screen Replacement',
      description: 'Display repair & glass fitment',
      category: 'Repair Services',
      unit: 'Job',
      sellingPrice: 1500.0,
      gstRate: 18.0,
      durationMinutes: 45,
    ),
    const Item(
      id: 'item_5',
      businessId: demoBusinessId,
      type: ItemType.product,
      name: 'Assam Tea 250g',
      sku: 'TEA-250',
      barcode: '890123456705',
      category: 'Beverages',
      unit: 'Box',
      sellingPrice: 120.0,
      purchasePrice: 90.0,
      mrp: 130.0,
      gstRate: 12.0,
      currentStock: 4, // Low stock demo!
      lowStockLimit: 5,
    ),
    const Item(
      id: 'item_6',
      businessId: demoBusinessId,
      type: ItemType.roomCharge,
      name: 'Deluxe Room 204 (1 Night)',
      category: 'Hotel Accommodation',
      unit: 'Night',
      sellingPrice: 2500.0,
      gstRate: 12.0,
    ),
  ];

  static final List<Expense> demoExpenses = [
    Expense(
      id: 'exp_1',
      businessId: demoBusinessId,
      category: 'Rent',
      title: 'Monthly Shop Rent',
      description: 'Main market premises rent',
      amount: 15000.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      paymentMethod: 'UPI',
    ),
    Expense(
      id: 'exp_2',
      businessId: demoBusinessId,
      category: 'Utilities',
      title: 'Electricity Bill',
      description: 'MSEDCL Commercial Power bill',
      amount: 2450.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      paymentMethod: 'Cash',
    ),
    Expense(
      id: 'exp_3',
      businessId: demoBusinessId,
      category: 'Internet',
      title: 'Fiber Broadband',
      description: 'High-speed shop internet',
      amount: 999.0,
      date: DateTime.now().subtract(const Duration(days: 4)),
      paymentMethod: 'Card',
    ),
  ];

  static final List<SmartInsight> demoInsights = [
    const SmartInsight(
      id: 'ins_1',
      title: 'Weekly Sales Up by 18%',
      message: 'Your total sales revenue is ₹18,450 higher than last week. Top contributor: Basmati Rice 5kg.',
      category: 'Sales',
      actionLabel: 'View Sales Report',
      actionRoute: '/reports',
      isPositive: true,
    ),
    const SmartInsight(
      id: 'ins_2',
      title: 'Low Stock Alert (2 Items)',
      message: 'Assam Tea 250g and Bathing Soap are below minimum stock limits. Restock recommended.',
      category: 'Inventory',
      actionLabel: 'View Inventory',
      actionRoute: '/shop',
      isPositive: false,
    ),
    const SmartInsight(
      id: 'ins_3',
      title: 'Pending Credit Dues',
      message: '₹3,650 is currently pending from 2 registered credit customers.',
      category: 'Credit',
      actionLabel: 'View Customers',
      actionRoute: '/customers',
      isPositive: false,
    ),
  ];

  static final List<Customer> demoCustomers = [
    const Customer(
      id: 'cust_walk_in',
      businessId: demoBusinessId,
      name: 'Walk-in Customer',
      phone: 'N/A',
      email: '',
      address: '',
      gstin: '',
      outstandingBalance: 0.0,
      totalInvoices: 42,
    ),
    const Customer(
      id: 'cust_1',
      businessId: demoBusinessId,
      name: 'Rajesh Sharma',
      phone: '9876543211',
      email: 'rajesh@example.com',
      address: 'Plot 42, Green Park Society',
      gstin: '27AAAAA0000A1Z5',
      outstandingBalance: 2450.0,
      totalInvoices: 8,
    ),
    const Customer(
      id: 'cust_2',
      businessId: demoBusinessId,
      name: 'Anita Verma',
      phone: '9876543212',
      email: 'anita.v@example.com',
      address: 'B-202, Sunshine Apartments',
      gstin: '',
      outstandingBalance: 0.0,
      totalInvoices: 5,
    ),
  ];

  static final List<Invoice> demoInvoices = [
    Invoice(
      id: 'inv_1025',
      businessId: demoBusinessId,
      invoiceNumber: 'INV-1025',
      invoiceDate: DateTime.now().subtract(const Duration(minutes: 42)),
      customerId: 'cust_1',
      customerName: 'Rajesh Sharma',
      customerPhone: '9876543211',
      items: const [
        InvoiceItem(
          id: 'item_1',
          productId: 'item_1',
          productName: 'Basmati Rice 5kg',
          quantity: 2,
          unitPrice: 350.0,
          discountAmount: 0.0,
          gstRate: 5.0,
          taxAmount: 35.0,
          totalAmount: 735.0,
        ),
        InvoiceItem(
          id: 'item_2',
          productId: 'item_3',
          productName: 'Haircut & Styling',
          quantity: 1,
          unitPrice: 300.0,
          discountAmount: 0.0,
          gstRate: 18.0,
          taxAmount: 54.0,
          totalAmount: 354.0,
        ),
      ],
      subtotal: 1000.0,
      discount: 0.0,
      cgst: 44.5,
      sgst: 44.5,
      igst: 0.0,
      grandTotal: 1089.0,
      paymentType: PaymentType.cash,
      paidAmount: 1089.0,
      dueAmount: 0.0,
      status: InvoiceStatus.paid,
    ),
  ];
}
