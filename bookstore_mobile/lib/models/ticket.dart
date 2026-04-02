import 'product.dart';

class Ticket extends Product {
  final String description;

  Ticket({
    required super.id,
    required super.price,
    required super.qty,
    required super.productType,
    required this.description,
  });

  @override
  String get displayName => description;

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      price: (json['price'] ?? 0.0).toDouble(),
      qty: 1, // Tickets usually 1 or add a field if needed
      productType: json['productType'],
      description: json['description'] ?? '',
    );
  }
}