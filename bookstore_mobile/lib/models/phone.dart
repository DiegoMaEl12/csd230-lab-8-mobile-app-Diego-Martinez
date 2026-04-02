import 'electronic.dart';

class Phone extends Electronic {
  final String os;

  Phone({
    required super.id,
    required super.price,
    required super.qty,
    required super.productType,
    required super.brand,
    required super.model,
    required super.storage,
    required this.os,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id'],
      price: (json['price'] ?? 0.0).toDouble(),
      qty: json['quantity'] ?? 0,
      productType: json['productType'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      storage: json['storage'] ?? 0,
      os: json['os'] ?? 'Unknown',
    );
  }
}