import 'package:flutter/material.dart';
import 'package:project_hasil/Service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _authService.login(
        username: username,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();

      /// simpan token
      await prefs.setString('token', result.token);

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      isLoading = false;

      errorMessage = e.toString().replaceAll('Exception: ', '');

      notifyListeners();

      return false;
    }
  }
}