import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/laptop.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'laptop_form_screen.dart'; // We will create this next

class LaptopListScreen extends StatefulWidget {
  const LaptopListScreen({super.key});

  @override
  State<LaptopListScreen> createState() => _LaptopListScreenState();
}

class _LaptopListScreenState extends State<LaptopListScreen> {
  final ApiService _api = ApiService();

  Future<List<Laptop>> fetchLaptops() async {
    final res = await _api.client.get('/laptops');
    return (res.data as List).map((json) => Laptop.fromJson(json)).toList();
  }

  void _handleAddToCart(BuildContext context, int productId) async {
    try {
      await Provider.of<CartProvider>(context, listen: false).addToCart(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to cart!"), duration: Duration(seconds: 1)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error adding to cart")));
    }
  }

  void _handleDelete(BuildContext context, Laptop laptop) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Laptop"),
        content: Text("Delete ${laptop.brand} ${laptop.model}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCEL")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _api.client.delete('/laptops/${laptop.id}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Laptop deleted")));
        setState(() {}); // Refresh the FutureBuilder
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Delete failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AuthProvider>(context).isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laptops"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: FutureBuilder<List<Laptop>>(
        future: fetchLaptops(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final laptop = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.laptop, size: 40),
                  title: Text("${laptop.brand} ${laptop.model}"),
                  subtitle: Text("${laptop.cpu} | ${laptop.ram}GB RAM | ${laptop.storage}GB SSD"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                        onPressed: () => _handleAddToCart(context, laptop.id),
                      ),
                      if (isAdmin) ...[
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async { /* navigate to form */ },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _handleDelete(context, laptop),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          bool? refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LaptopFormScreen()),
          );
          if (refresh == true) setState(() {});
        },
      ) : null,
    );
  }
}