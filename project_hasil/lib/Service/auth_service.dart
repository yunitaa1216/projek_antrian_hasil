import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_hasil/Model/LoginModel/login_model.dart';

// import '../Model/login_response_model.dart';

class AuthService {

  /// Flutter Web
  final String baseUrl = 'http://localhost:3000';

  /// Android Emulator
  // final String baseUrl = 'http://10.0.2.2:3000';

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(data);
    } else {
      throw Exception(data['message']);
    }
  }
}