import 'package:flutter/material.dart';
import 'package:project_hasil/Service/queue_service.dart';

class QueueViewModel extends ChangeNotifier {
  final QueueService _queueService = QueueService();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  String? uuid;
  String? nomorAntrian;
  String? estimatedTime;

  Future<bool> createQueue({
    required String nama,
    required String nik,
    required String alamat,
    required String telepon,
    required String kategori,
    required String jenisLayanan,
    String? reason,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
      uuid = null;
      nomorAntrian = null;
      estimatedTime = null;
      notifyListeners();

      final result = await _queueService.createQueue(
        nama: nama,
        nik: nik,
        alamat: alamat,
        telepon: telepon,
        kategori: kategori,
        jenisLayanan: jenisLayanan,
        reason: reason,
      );

      successMessage = result.message;
      uuid = result.uuid;
      nomorAntrian = result.nomorAntrian;
      estimatedTime = result.estimatedTime;

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