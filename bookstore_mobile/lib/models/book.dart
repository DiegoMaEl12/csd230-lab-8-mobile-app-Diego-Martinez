import 'publication.dart';

class Book extends Publication {
  final String author;

  Book({
    required super.id,
    required super.price,
    required super.qty,
    required super.productType,
    required super.title,
    required this.author,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      price: (json['price'] ?? 0.0).toDouble(),
      qty: json['copies'] ?? 0, // Maps 'copies' to 'qty'
      productType: json['productType'],
      title: json['title'] ?? '',
      author: json['author'] ?? '',
    );
  }
}