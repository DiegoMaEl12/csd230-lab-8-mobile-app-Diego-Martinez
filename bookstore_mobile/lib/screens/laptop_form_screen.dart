import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/laptop.dart';

class LaptopFormScreen extends StatefulWidget {
  final Laptop? laptop;

  const LaptopFormScreen({super.key, this.laptop});

  @override
  State<LaptopFormScreen> createState() => _LaptopFormScreenState();
}

class _LaptopFormScreenState extends State<LaptopFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();

  late String _brand;
  late String _model;
  late double _price;
  late String _cpu;
  late int _ram;
  late int _storage;

  @override
  void initState() {
    super.initState();
    _brand = widget.laptop?.brand ?? '';
    _model = widget.laptop?.model ?? '';
    _price = widget.laptop?.price ?? 0.0;
    _cpu = widget.laptop?.cpu ?? '';
    _ram = widget.laptop?.ram ?? 16;
    _storage = widget.laptop?.storage ?? 512;
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final data = {
        "brand": _brand,
        "model": _model,
        "price": _price,
        "cpu": _cpu,
        "ram": _ram,
        "storage": _storage,
        "quantity": 10, // Default inventory
        "productType": "LaptopEntity"
      };

      try {
        if (widget.laptop == null) {
          await _api.client.post('/laptops', data: data);
        } else {
          await _api.client.put('/laptops/${widget.laptop!.id}', data: data);
        }
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving laptop")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.laptop == null ? "Add Laptop" : "Edit Laptop")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _brand,
              decoration: const InputDecoration(labelText: "Brand (e.g. Apple, Dell)"),
              validator: (v) => v!.isEmpty ? "Required" : null,
              onSaved: (v) => _brand = v!,
            ),
            TextFormField(
              initialValue: _model,
              decoration: const InputDecoration(labelText: "Model (e.g. MacBook Pro)"),
              validator: (v) => v!.isEmpty ? "Required" : null,
              onSaved: (v) => _model = v!,
            ),
            TextFormField(
              initialValue: _cpu,
              decoration: const InputDecoration(labelText: "CPU (e.g. M3, Intel i7)"),
              validator: (v) => v!.isEmpty ? "Required" : null,
              onSaved: (v) => _cpu = v!,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _ram.toString(),
                    decoration: const InputDecoration(labelText: "RAM (GB)"),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _ram = int.parse(v!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _storage.toString(),
                    decoration: const InputDecoration(labelText: "Storage (GB)"),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _storage = int.parse(v!),
                  ),
                ),
              ],
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
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("SAVE LAPTOP"),
            ),
          ],
        ),
      ),
    );
  }
}