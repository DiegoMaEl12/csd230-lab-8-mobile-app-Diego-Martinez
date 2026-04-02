import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../api/api_service.dart';
import '../models/magazine.dart';
import '../providers/cart_provider.dart';

class MagazineListScreen extends StatelessWidget {
  final ApiService _api = ApiService();

  MagazineListScreen({super.key});

  Future<List<Magazine>> fetchMagazines() async {
    final res = await _api.client.get('/magazines');
    return (res.data as List).map((json) => Magazine.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Magazines")),
      body: FutureBuilder<List<Magazine>>(
        future: fetchMagazines(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final mag = snapshot.data![index];
              // Format date: e.g., "March 11, 2026"
              String dateStr = mag.currentIssue != null
                  ? DateFormat.yMMMMd().format(mag.currentIssue!)
                  : "N/A";

              return ListTile(
                leading: const Icon(Icons.newspaper),
                title: Text(mag.title),
                subtitle: Text("Issue: $dateStr | Order Qty: ${mag.orderQty}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("\$${mag.price.toStringAsFixed(2)}"),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                      onPressed: () => Provider.of<CartProvider>(context, listen: false).addToCart(mag.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}