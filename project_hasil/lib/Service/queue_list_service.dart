import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_hasil/Model/AntrianModel/queue_list_model.dart';

class QueueListService {
  /// Flutter Web
  final String baseUrl = 'http://localhost:3000';

  /// Android Emulator
  // final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<QueueItemModel>> getQueueUmum() async {
    return await _getQueue('/queue/umum');
  }

  Future<List<QueueItemModel>> getQueuePrioritas() async {
    return await _getQueue('/queue/prioritas');
  }

  Future<List<QueueItemModel>> _getQueue(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List list = data['response'] ?? [];

      return list.map((item) {
        return QueueItemModel.fromJson(item);
      }).toList();
    } else {
      throw Exception(data['message'] ?? 'Gagal mengambil data antrian');
    }
  }

  Future<String> updateStatusQueue({
    required String id,
    required String status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/queue/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': status,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'] ?? 'Berhasil mengupdate status';
    } else {
      throw Exception(data['message'] ?? 'Gagal mengupdate status');
    }
  }

  Future<String> deleteQueue({
  required String id,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    throw Exception('Token tidak ditemukan, silakan login ulang');
  }

  final response = await http.delete(
    Uri.parse('$baseUrl/queue/delete/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return data['message'] ?? 'Berhasil menghapus antrian';
  } else {
    throw Exception(data['message'] ?? 'Gagal menghapus antrian');
  }
}
}