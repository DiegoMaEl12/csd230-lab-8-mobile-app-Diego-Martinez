import 'package:bookstore_mobile/models/phone.dart';
import 'package:bookstore_mobile/models/ticket.dart';

import 'book.dart';
import 'disc_mag.dart';
import 'laptop.dart';
import 'magazine.dart';

abstract class Product {
  final int id;
  final double price;
  final int qty;
  final String productType;

  Product({
    required this.id,
    required this.price,
    required this.qty,
    required this.productType,
  });

  static Product fromJson(Map<String, dynamic> json) {
    String type = json['productType'] ?? '';

    if (type == 'BookEntity') return Book.fromJson(json);
    if (type == 'MagazineEntity') return Magazine.fromJson(json);
    if (type == 'LaptopEntity') return Laptop.fromJson(json);
    if (type == 'PhoneEntity') return Phone.fromJson(json);
    if (type == 'TicketEntity') return Ticket.fromJson(json);
    if (type == 'DiscMagEntity') return DiscMag.fromJson(json);

    throw Exception("Unknown Product Type: $type");
  }

  // Helper for UI display logic (Common to all)
  String get displayName;
}