import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../api/api_service.dart';
import '../models/magazine.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'magazine_form_screen.dart'; // We will create this next

class MagazineListScreen extends StatefulWidget {
  const MagazineListScreen({super.key});

  @override
  State<MagazineListScreen> createState() => _MagazineListScreenState();
}

class _MagazineListScreenState extends State<MagazineListScreen> {
  final ApiService _api = ApiService();

  Future<List<Magazine>> fetchMagazines() async {
    final res = await _api.client.get('/magazines');
    return (res.data as List).map((json) => Magazine.fromJson(json)).toList();
  }

  void _handleAddToCart(BuildContext context, int productId) async {
    try {
      await Provider.of<CartProvider>(context, listen: false).addToCart(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to cart!"), duration: Duration(seconds: 1)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error adding to cart")),
      );
    }
  }

  void _handleDelete(BuildContext context, Magazine mag) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Magazine"),
        content: Text("Are you sure you want to delete '${mag.title}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCEL")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("DELETE", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );



    if (confirm == true) {
      try {
        await _api.client.delete('/magazines/${mag.id}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Magazine deleted")));
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
        title: const Text("Magazines"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: FutureBuilder<List<Magazine>>(
        future: fetchMagazines(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final mag = snapshot.data![index];
              String dateStr = mag.currentIssue != null
                  ? DateFormat.yMMMMd().format(mag.currentIssue!)
                  : "N/A";

              return ListTile(
                leading: const Icon(Icons.newspaper),
                title: Text(mag.title),
                subtitle: Text("Issue: $dateStr\nPrice: \$${mag.price.toStringAsFixed(2)}"),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                      onPressed: () => _handleAddToCart(context, mag.id),
                    ),
                    if (isAdmin) ...[
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () async { /* navigate to form */ },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _handleDelete(context, mag),
                      ),
                    ],
                  ],
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
            MaterialPageRoute(builder: (context) => const MagazineFormScreen()),
          );
          if (refresh == true) setState(() {});
        },
      ) : null,
    );
  }
}