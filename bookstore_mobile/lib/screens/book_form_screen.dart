import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/book.dart';

class BookFormScreen extends StatefulWidget {
  final Book? book; // If this is null, we are "Adding". If not, we are "Editing".

  const BookFormScreen({super.key, this.book});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();

  late String _title;
  late String _author;
  late double _price;

  @override
  void initState() {
    super.initState();
    // Pre-populate fields if we are editing
    _title = widget.book?.title ?? '';
    _author = widget.book?.author ?? '';
    _price = widget.book?.price ?? 0.0;
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final data = {
        "title": _title,
        "author": _author,
        "price": _price,
        "copies": 10,
        "productType": "BookEntity"
      };

      try {
        if (widget.book == null) {
          // CREATE mode
          await _api.client.post('/books', data: data);
        } else {
          // UPDATE mode - uses PUT /books/{id}
          await _api.client.put('/books/${widget.book!.id}', data: data);
        }

        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book == null ? "Add Book" : "Edit Book")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: "Title"),
              onSaved: (v) => _title = v!,
            ),
            TextFormField(
              initialValue: _author,
              decoration: const InputDecoration(labelText: "Author"),
              onSaved: (v) => _author = v!,
            ),
            TextFormField(
              initialValue: _price.toString(),
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              onSaved: (v) => _price = double.parse(v!),
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _saveForm, child: const Text("SAVE")),
          ],
        ),
      ),
    );
  }
}