// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final token = await AuthService.login(email, password);

    _isLoading = false;

    if (token != null) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Credenciales inválidas';
      notifyListeners();
      return false;
    }
  }
}
