import '../entities/business.dart';
import '../entities/item.dart';
import '../entities/customer.dart';
import '../entities/customer_payment.dart';
import '../entities/invoice.dart';

abstract class BusinessRepository {
  Future<Business?> getBusiness(String id);
  Future<void> saveBusiness(Business business);
}

abstract class ProductRepository {
  Future<List<Item>> getProducts(String businessId);
  Future<Item?> getProductById(String id);
  Future<void> addProduct(Item item);
  Future<void> updateProduct(Item item);
  Future<void> updateStock(String productId, int newStock);
  Future<void> deleteProduct(String id);
}

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers(String businessId);
  Future<Customer?> getCustomerById(String id);
  Future<void> addCustomer(Customer customer);
  Future<void> updateCustomer(Customer customer);
  Future<void> recordPayment(String customerId, double amount);
  Future<void> recordCustomerPayment(CustomerPayment payment);
  Future<List<CustomerPayment>> getCustomerPayments(String customerId);
  Future<void> deleteCustomer(String id);
}

abstract class InvoiceRepository {
  Future<List<Invoice>> getInvoices(String businessId);
  Future<Invoice?> getInvoiceById(String id);
  Future<void> saveInvoice(Invoice invoice);
  Future<void> cancelInvoice(String id);
}
