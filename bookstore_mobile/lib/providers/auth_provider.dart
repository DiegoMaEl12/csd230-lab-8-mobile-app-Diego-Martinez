import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isAdmin = false;
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  bool get isAuthenticated => _token != null;
  bool get isAdmin => _isAdmin;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.client.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      _token = response.data['token'];
      // Basic JWT role parsing (similar to your React logic)
      // For a lab, you can simplify or parse the claims here
      _isAdmin = email.contains('admin');

      await _storage.write(key: 'token', value: _token);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}