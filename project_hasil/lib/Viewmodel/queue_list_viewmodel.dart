import 'package:flutter/material.dart';
import 'package:project_hasil/Model/AntrianModel/queue_list_model.dart';
import 'package:project_hasil/Service/queue_list_service.dart';

class QueueListViewModel extends ChangeNotifier {
  final QueueListService _queueListService = QueueListService();

  bool isLoading = false;
  String? errorMessage;

  List<QueueItemModel> antrianUmum = [];
  List<QueueItemModel> antrianPrioritas = [];

  Future<void> getAllQueue() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      antrianUmum = await _queueListService.getQueueUmum();
      antrianPrioritas = await _queueListService.getQueuePrioritas();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> refreshQueue() async {
    await getAllQueue();
  }

  Future<bool> updateStatusQueue({
    required String id,
    required String status,
  }) async {
    try {
      errorMessage = null;
      notifyListeners();

      await _queueListService.updateStatusQueue(
        id: id,
        status: status,
      );

      await refreshQueue();

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();

      return false;
    }
  }

  Future<bool> deleteQueue({
  required String id,
}) async {
  try {
    errorMessage = null;
    notifyListeners();

    await _queueListService.deleteQueue(id: id);

    await refreshQueue();

    return true;
  } catch (e) {
    errorMessage = e.toString().replaceAll('Exception: ', '');
    notifyListeners();

    return false;
  }
}
}