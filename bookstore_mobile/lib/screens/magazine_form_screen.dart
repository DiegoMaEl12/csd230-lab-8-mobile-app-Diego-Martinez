import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/api_service.dart';
import '../models/magazine.dart';

class MagazineFormScreen extends StatefulWidget {
  final Magazine? magazine;

  const MagazineFormScreen({super.key, this.magazine});

  @override
  State<MagazineFormScreen> createState() => _MagazineFormScreenState();
}

class _MagazineFormScreenState extends State<MagazineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();

  late String _title;
  late double _price;
  late int _orderQty;
  late DateTime _currentIssue;

  @override
  void initState() {
    super.initState();
    _title = widget.magazine?.title ?? '';
    _price = widget.magazine?.price ?? 0.0;
    _orderQty = widget.magazine?.orderQty ?? 100;
    _currentIssue = widget.magazine?.currentIssue ?? DateTime.now();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // The backend expects "yyyy-MM-dd'T'HH:mm:ss"
      // We'll format the DateTime to match your Spring Boot @JsonFormat
      String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_currentIssue);

      final data = {
        "title": _title,
        "price": _price,
        "copies": 20, // Default for new mags
        "orderQty": _orderQty,
        "currentIssue": formattedDate,
        "productType": "MagazineEntity"
      };

      try {
        if (widget.magazine == null) {
          await _api.client.post('/magazines', data: data);
        } else {
          await _api.client.put('/magazines/${widget.magazine!.id}', data: data);
        }

        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        print("Error saving magazine: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save magazine")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.magazine == null ? "Add Magazine" : "Edit Magazine")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: "Magazine Title"),
              validator: (v) => v!.isEmpty ? "Required" : null,
              onSaved: (v) => _title = v!,
            ),
            TextFormField(
              initialValue: _price.toString(),
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              onSaved: (v) => _price = double.parse(v!),
            ),
            TextFormField(
              initialValue: _orderQty.toString(),
              decoration: const InputDecoration(labelText: "Order Quantity"),
              keyboardType: TextInputType.number,
              onSaved: (v) => _orderQty = int.parse(v!),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("Issue Date"),
              subtitle: Text(DateFormat.yMMMMd().format(_currentIssue)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _currentIssue,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _currentIssue = picked);
                }
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("SAVE MAGAZINE"),
            ),
          ],
        ),
      ),
    );
  }
}