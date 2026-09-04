import '../../domain/entities/business.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/repositories.dart';
import '../database/app_database.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final AppDatabase db = AppDatabase.instance;

  @override
  Future<Business?> getBusiness(String id) async {
    return db.currentBusiness;
  }

  @override
  Future<void> saveBusiness(Business business) async {
    db.currentBusiness = business;
    db.isBusinessConfigured = true;
    db.isDemoMode = false;
    await db.saveLocalState();
  }
}

class ProductRepositoryImpl implements ProductRepository {
  final AppDatabase db = AppDatabase.instance;

  @override
  Future<List<Item>> getProducts(String businessId) async {
    return List.from(db.items);
  }

  @override
  Future<Item?> getProductById(String id) async {
    try {
      return db.items.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addProduct(Item item) async {
    db.items.add(item);
    await db.saveLocalState();
  }

  @override
  Future<void> updateProduct(Item item) async {
    final index = db.items.indexWhere((p) => p.id == item.id);
    if (index != -1) {
      db.items[index] = item;
      await db.saveLocalState();
    }
  }

  @override
  Future<void> updateStock(String productId, int newStock) async {
    final index = db.items.indexWhere((p) => p.id == productId && p.isProduct);
    if (index != -1) {
      db.items[index] = db.items[index].copyWith(currentStock: newStock);
      await db.saveLocalState();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    db.items.removeWhere((p) => p.id == id);
    await db.saveLocalState();
  }
}

class CustomerRepositoryImpl implements CustomerRepository {
  final AppDatabase db = AppDatabase.instance;

  @override
  Future<List<Customer>> getCustomers(String businessId) async {
    return List.from(db.customers);
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    try {
      return db.customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    db.customers.add(customer);
    await db.saveLocalState();
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    final index = db.customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      db.customers[index] = customer;
      await db.saveLocalState();
    }
  }

  @override
  Future<void> recordPayment(String customerId, double amount) async {
    final index = db.customers.indexWhere((c) => c.id == customerId);
    if (index != -1) {
      final updatedBal = (db.customers[index].outstandingBalance - amount).clamp(0.0, double.infinity);
      db.customers[index] = db.customers[index].copyWith(outstandingBalance: updatedBal);
      await db.saveLocalState();
    }
  }
}

class InvoiceRepositoryImpl implements InvoiceRepository {
  final AppDatabase db = AppDatabase.instance;

  @override
  Future<List<Invoice>> getInvoices(String businessId) async {
    return List.from(db.invoices);
  }

  @override
  Future<Invoice?> getInvoiceById(String id) async {
    try {
      return db.invoices.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveInvoice(Invoice invoice) async {
    db.invoices.insert(0, invoice);

    // 2. Deduct stock ONLY for products (Services do NOT affect stock)
    for (final item in invoice.items) {
      final itemIndex = db.items.indexWhere((p) => p.id == item.productId && p.isProduct);
      if (itemIndex != -1) {
        final current = db.items[itemIndex].currentStock;
        final updatedStock = (current - item.quantity).clamp(0, 999999);
        db.items[itemIndex] = db.items[itemIndex].copyWith(currentStock: updatedStock);
      }
    }

    // 3. Update customer outstanding balance if credit sale
    if (invoice.paymentType == PaymentType.credit && invoice.customerId.isNotEmpty) {
      final cIndex = db.customers.indexWhere((c) => c.id == invoice.customerId);
      if (cIndex != -1) {
        final currentBal = db.customers[cIndex].outstandingBalance;
        final newBal = currentBal + invoice.dueAmount;
        final invCount = db.customers[cIndex].totalInvoices + 1;
        db.customers[cIndex] = db.customers[cIndex].copyWith(
          outstandingBalance: newBal,
          totalInvoices: invCount,
        );
      }
    }

    if (db.currentBusiness != null) {
      db.currentBusiness = db.currentBusiness!.copyWith(
        nextInvoiceNumber: db.currentBusiness!.nextInvoiceNumber + 1,
      );
    }

    await db.saveLocalState();
  }

  @override
  Future<void> cancelInvoice(String id) async {
    final index = db.invoices.indexWhere((i) => i.id == id);
    if (index != -1) {
      db.invoices[index] = Invoice(
        id: db.invoices[index].id,
        businessId: db.invoices[index].businessId,
        invoiceNumber: db.invoices[index].invoiceNumber,
        invoiceDate: db.invoices[index].invoiceDate,
        customerId: db.invoices[index].customerId,
        customerName: db.invoices[index].customerName,
        customerPhone: db.invoices[index].customerPhone,
        items: db.invoices[index].items,
        subtotal: db.invoices[index].subtotal,
        discount: db.invoices[index].discount,
        cgst: db.invoices[index].cgst,
        sgst: db.invoices[index].sgst,
        igst: db.invoices[index].igst,
        grandTotal: db.invoices[index].grandTotal,
        paymentType: db.invoices[index].paymentType,
        paidAmount: db.invoices[index].paidAmount,
        dueAmount: db.invoices[index].dueAmount,
        status: InvoiceStatus.cancelled,
      );
      await db.saveLocalState();
    }
  }
}
