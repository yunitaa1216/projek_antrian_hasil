import 'package:flutter/material.dart';
import 'package:project_hasil/Model/DashboardModel/statistik_model.dart';
import 'package:project_hasil/Service/dashboard_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  bool isLoading = false;
  String? errorMessage;
  StatistikModel? statistik;

  Future<void> getStatistik() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      statistik = await _dashboardService.getStatistik();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> refreshStatistik() async {
    await getStatistik();
  }
}