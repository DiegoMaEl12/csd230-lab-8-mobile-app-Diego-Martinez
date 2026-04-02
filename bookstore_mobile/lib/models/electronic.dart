import 'product.dart';

abstract class Electronic extends Product {
  final String brand;
  final String model;
  final int storage;

  Electronic({
    required super.id,
    required super.price,
    required super.qty,
    required super.productType,
    required this.brand,
    required this.model,
    required this.storage,
  });

  @override
  String get displayName => "$brand $model";
}