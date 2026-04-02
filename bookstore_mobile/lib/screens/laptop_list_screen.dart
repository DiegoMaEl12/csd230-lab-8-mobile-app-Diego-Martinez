import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/laptop.dart';
import '../providers/cart_provider.dart';

class LaptopListScreen extends StatelessWidget {
  final ApiService _api = ApiService();

  LaptopListScreen({super.key});

  Future<List<Laptop>> fetchLaptops() async {
    final res = await _api.client.get('/laptops');
    return (res.data as List).map((json) => Laptop.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laptops")),
      body: FutureBuilder<List<Laptop>>(
        future: fetchLaptops(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final laptop = snapshot.data![index];
              return ListTile(
                leading: const Icon(Icons.laptop),
                title: Text("${laptop.brand} ${laptop.model}"),
                subtitle: Text("${laptop.cpu} | ${laptop.ram}GB RAM | ${laptop.storage}GB SSD"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("\$${laptop.price.toStringAsFixed(2)}"),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                      onPressed: () => Provider.of<CartProvider>(context, listen: false).addToCart(laptop.id),
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