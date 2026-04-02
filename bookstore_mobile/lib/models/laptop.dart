import 'electronic.dart';

class Laptop extends Electronic {
  final String cpu;
  final int ram;

  Laptop({
    required super.id,
    required super.price,
    required super.qty,
    required super.productType,
    required super.brand,
    required super.model,
    required super.storage,
    required this.cpu,
    required this.ram,
  });

  factory Laptop.fromJson(Map<String, dynamic> json) {
    return Laptop(
      id: json['id'],
      price: (json['price'] ?? 0.0).toDouble(),
      qty: json['quantity'] ?? 0, // Maps 'quantity' to 'qty'
      productType: json['productType'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      storage: json['storage'] ?? 0,
      cpu: json['cpu'] ?? '',
      ram: json['ram'] ?? 0,
    );
  }
}