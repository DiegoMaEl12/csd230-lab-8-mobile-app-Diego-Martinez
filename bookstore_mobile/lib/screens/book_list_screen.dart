import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
import '../models/book.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'book_form_screen.dart';

class BookListScreen extends StatelessWidget {
  final ApiService _api = ApiService();

  BookListScreen({super.key});

  Future<List<Book>> fetchBooks() async {
    final res = await _api.client.get('/books');
    return (res.data as List).map((json) => Book.fromJson(json)).toList();
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

  // Inside BookListScreen class
  void _handleDelete(BuildContext context, Book book) async {
    // 1. Show confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Book"),
        content: Text("Are you sure you want to delete '${book.title}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCEL")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("DELETE", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _api.client.delete('/books/${book.id}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Book deleted")));

        // 2. Trigger UI refresh (In a Stateless widget using FutureBuilder,
        // the easiest way is to push a replacement or use a stateful parent).
        // For now, let's just pop/push or use the refresh logic from your FAB.
        Navigator.pushReplacementNamed(context, '/home');
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
        title: const Text("Books"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                      onPressed: () => _handleAddToCart(context, book.id),
                    ),
                    if (isAdmin) ...[
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () async {
                          bool? refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookFormScreen(book: book)),
                          );
                          if (refresh == true) Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _handleDelete(context, book),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
      // ..
      floatingActionButton: isAdmin ? FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Navigate to form and wait for result
          bool? refresh = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookFormScreen())
          );
          if (refresh == true) {
            // Re-trigger the FutureBuilder to show the new book
            (context as Element).markNeedsBuild();
          }
        },
      ) : null,
    );
  }
}
