import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_hasil/Model/RiwayatModel/riwayat_model.dart';

class RiwayatService {
  /// Flutter Web
  final String baseUrl = 'http://localhost:3000';

  /// Android Emulator
  // final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<RiwayatAntrianModel>> getRiwayatAntrian() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/queue/riwayat'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List list = data['response'] ?? [];

      return list.map((item) {
        return RiwayatAntrianModel.fromJson(item);
      }).toList();
    } else {
      throw Exception(data['message'] ?? 'Gagal mengambil riwayat antrian');
    }
  }
}