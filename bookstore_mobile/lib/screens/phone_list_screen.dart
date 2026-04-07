import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/phone.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'phone_form_screen.dart'; // We will create this next

class PhoneListScreen extends StatefulWidget {
  const PhoneListScreen({super.key});

  @override
  State<PhoneListScreen> createState() => _PhoneListScreenState();
}

class _PhoneListScreenState extends State<PhoneListScreen> {
  final ApiService _api = ApiService();

  Future<List<Phone>> fetchPhones() async {
    final res = await _api.client.get('/phones');
    return (res.data as List).map((json) => Phone.fromJson(json)).toList();
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

  void _handleDelete(BuildContext context, Phone phone) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Phone"),
        content: Text("Delete ${phone.brand} ${phone.model}?"),
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
        await _api.client.delete('/phones/${phone.id}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Phone deleted")));
        setState(() {}); // Refresh list
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
        title: const Text("Phones"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: FutureBuilder<List<Phone>>(
        future: fetchPhones(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final phone = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.phone_android, size: 40),
                  title: Text("${phone.brand} ${phone.model}"),
                  subtitle: Text("OS: ${phone.os} | Storage: ${phone.storage}GB\nPrice: \$${phone.price.toStringAsFixed(2)}"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                        onPressed: () => _handleAddToCart(context, phone.id),
                      ),
                      if (isAdmin) ...[
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async { /* navigate to form */ },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _handleDelete(context, phone),
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
            MaterialPageRoute(builder: (context) => const PhoneFormScreen()),
          );
          if (refresh == true) setState(() {});
        },
      ) : null,
    );
  }
}