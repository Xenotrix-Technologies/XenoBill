import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String businessId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String gstin;
  final double outstandingBalance;
  final int totalInvoices;

  const Customer({
    required this.id,
    required this.businessId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.gstin,
    required this.outstandingBalance,
    required this.totalInvoices,
  });

  Customer copyWith({
    String? id,
    String? businessId,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? gstin,
    double? outstandingBalance,
    int? totalInvoices,
  }) {
    return Customer(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstin: gstin ?? this.gstin,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      totalInvoices: totalInvoices ?? this.totalInvoices,
    );
  }

  @override
  List<Object?> get props => [
        id,
        businessId,
        name,
        phone,
        email,
        address,
        gstin,
        outstandingBalance,
        totalInvoices,
      ];
}
