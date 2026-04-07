import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/phone.dart';

class PhoneFormScreen extends StatefulWidget {
  final Phone? phone;

  const PhoneFormScreen({super.key, this.phone});

  @override
  State<PhoneFormScreen> createState() => _PhoneFormScreenState();
}

class _PhoneFormScreenState extends State<PhoneFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();

  late String _brand;
  late String _model;
  late String _os;
  late int _storage;
  late double _price;

  @override
  void initState() {
    super.initState();
    _brand = widget.phone?.brand ?? '';
    _model = widget.phone?.model ?? '';
    _os = widget.phone?.os ?? '';
    _storage = widget.phone?.storage ?? 128;
    _price = widget.phone?.price ?? 0.0;
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final data = {
        "brand": _brand,
        "model": _model,
        "os": _os,
        "storage": _storage,
        "price": _price,
        "quantity": 15, // Default stock matching your Application.java logic
        "productType": "PhoneEntity"
      };

      try {
        if (widget.phone == null) {
          await _api.client.post('/phones', data: data);
        } else {
          await _api.client.put('/phones/${widget.phone!.id}', data: data);
        }

        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving phone")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.phone == null ? "Add Phone" : "Edit Phone")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _brand,
              decoration: const InputDecoration(labelText: "Brand (e.g. Samsung, Apple)"),
              validator: (v) => v!.isEmpty ? "Required" : null,
              onSaved: (v) => _brand = v!,
            ),
            TextFormField(
              initialValue: _model,
              decoration: const InputDecoration(labelText: "Model (e.g. Galaxy S24, iPhone 15)"),
              validator: (v) => v!.isEmpty ? "Required" : null,
              onSaved: (v) => _model = v!,
            ),
            DropdownButtonFormField<String>(
              value: ['Android', 'iOS', 'Unknown'].contains(_os) ? _os : null,
              decoration: const InputDecoration(labelText: "Operating System"),
              items: ['Android', 'iOS', 'Unknown']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (value) => setState(() => _os = value!),
              onSaved: (value) => _os = value!,
              validator: (v) => v == null ? "Required" : null,
            ),
            TextFormField(
              initialValue: _storage.toString(),
              decoration: const InputDecoration(labelText: "Storage (GB)"),
              keyboardType: TextInputType.number,
              onSaved: (v) => _storage = int.parse(v!),
            ),
            TextFormField(
              initialValue: _price.toString(),
              decoration: const InputDecoration(labelText: "Price", prefixText: "\$"),
              keyboardType: TextInputType.number,
              onSaved: (v) => _price = double.parse(v!),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50)
              ),
              child: const Text("SAVE PHONE"),
            ),
          ],
        ),
      ),
    );
  }
}