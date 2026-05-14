class QueueResponseModel {
  final String message;
  final String uuid;
  final String nomorAntrian;
  final String estimatedTime;

  QueueResponseModel({
    required this.message,
    required this.uuid,
    required this.nomorAntrian,
    required this.estimatedTime,
  });

  factory QueueResponseModel.fromJson(Map<String, dynamic> json) {
    return QueueResponseModel(
      message: json['message'] ?? '',
      uuid: json['uuid'] ?? '',
      nomorAntrian: json['nomor_antrian'] ?? '',
      estimatedTime: json['estimated_time'] ?? '',
    );
  }
}