import 'package:flutter/material.dart';
import 'package:project_hasil/Model/RiwayatModel/riwayat_model.dart';
import 'package:project_hasil/Service/riwayat_service.dart';

class RiwayatViewModel extends ChangeNotifier {
  final RiwayatService _riwayatService = RiwayatService();

  bool isLoading = false;
  String? errorMessage;

  List<RiwayatAntrianModel> riwayatList = [];

  Future<void> getRiwayatAntrian() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      riwayatList = await _riwayatService.getRiwayatAntrian();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> refreshRiwayat() async {
    await getRiwayatAntrian();
  }
}