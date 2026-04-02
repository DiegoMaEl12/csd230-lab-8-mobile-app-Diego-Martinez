import 'publication.dart';

class Magazine extends Publication {
  final int orderQty;
  final DateTime? currentIssue;

  Magazine({
    required super.id,
    required super.price,
    required super.qty,
    required super.productType,
    required super.title,
    required this.orderQty,
    this.currentIssue,
  });

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      id: json['id'],
      price: (json['price'] ?? 0.0).toDouble(),
      qty: json['copies'] ?? 0,
      productType: json['productType'],
      title: json['title'] ?? '',
      orderQty: json['orderQty'] ?? 0,
      currentIssue: json['currentIssue'] != null
          ? DateTime.parse(json['currentIssue'])
          : null,
    );
  }
}