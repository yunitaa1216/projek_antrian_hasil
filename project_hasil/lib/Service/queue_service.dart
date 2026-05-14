import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_hasil/Model/AntrianModel/queue_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:project_hasil/Model/QueueModel/queue_model.dart';

class QueueService {
  /// Flutter Web
  final String baseUrl = 'http://localhost:3000';

  /// Android Emulator
  // final String baseUrl = 'http://10.0.2.2:3000';

  Future<QueueResponseModel> createQueue({
    required String nama,
    required String nik,
    required String alamat,
    required String telepon,
    required String kategori,
    required String jenisLayanan,
    String? reason,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final Map<String, dynamic> body = {
      'nama': nama,
      'nik': nik,
      'alamat': alamat,
      'telepon': telepon,
      'kategori': kategori,
      'jenis_layanan': jenisLayanan,
    };

    if (jenisLayanan == 'pembuatan ktp') {
      body['reason'] = reason;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/queue/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return QueueResponseModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Gagal menambah antrian');
    }
  }
}