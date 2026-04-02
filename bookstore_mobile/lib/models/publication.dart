import 'product.dart';

abstract class Publication extends Product {
  final String title;

  Publication({
    required super.id,
    required super.price,
    required super.qty,
    required super.productType,
    required this.title,
  });

  @override
  String get displayName => title;
}