import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/phone.dart';
import '../providers/cart_provider.dart';

class PhoneListScreen extends StatelessWidget {
  final ApiService _api = ApiService();

  PhoneListScreen({super.key});

  Future<List<Phone>> fetchPhones() async {
    final res = await _api.client.get('/phones');
    return (res.data as List).map((json) => Phone.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phones")),
      body: FutureBuilder<List<Phone>>(
        future: fetchPhones(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final phone = snapshot.data![index];
              return ListTile(
                leading: const Icon(Icons.phone_android),
                title: Text("${phone.brand} ${phone.model}"),
                subtitle: Text("OS: ${phone.os} | Storage: ${phone.storage}GB"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("\$${phone.price.toStringAsFixed(2)}"),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                      onPressed: () => Provider.of<CartProvider>(context, listen: false).addToCart(phone.id),
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