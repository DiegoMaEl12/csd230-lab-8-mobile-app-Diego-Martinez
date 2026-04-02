import 'magazine.dart';

class DiscMag extends Magazine {
  final bool hasDisc;

  DiscMag({
    required super.id,
    required super.price,
    required super.qty,
    required super.productType,
    required super.title,
    required super.orderQty,
    super.currentIssue,
    required this.hasDisc,
  });

  factory DiscMag.fromJson(Map<String, dynamic> json) {
    return DiscMag(
      id: json['id'],
      price: (json['price'] ?? 0.0).toDouble(),
      qty: json['copies'] ?? 0,
      productType: json['productType'],
      title: json['title'] ?? '',
      orderQty: json['orderQty'] ?? 0,
      currentIssue: json['currentIssue'] != null
          ? DateTime.parse(json['currentIssue'])
          : null,
      hasDisc: json['hasDisc'] ?? false,
    );
  }
}