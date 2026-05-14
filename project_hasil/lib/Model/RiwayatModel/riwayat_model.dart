class RiwayatAntrianModel {
  final String uuid;
  final String nama;
  final String nik;
  final String alamat;
  final String telepon;
  final String kategori;
  final String jenisLayanan;
  final String status;
  final String estimatedTime;
  final String? reason;
  final String? date;

  RiwayatAntrianModel({
    required this.uuid,
    required this.nama,
    required this.nik,
    required this.alamat,
    required this.telepon,
    required this.kategori,
    required this.jenisLayanan,
    required this.status,
    required this.estimatedTime,
    this.reason,
    this.date,
  });

  factory RiwayatAntrianModel.fromJson(Map<String, dynamic> json) {
    return RiwayatAntrianModel(
      uuid: json['uuid'] ?? '',
      nama: json['nama'] ?? '',
      nik: json['nik'] ?? '',
      alamat: json['alamat'] ?? '',
      telepon: json['telepon'] ?? '',
      kategori: json['kategori'] ?? '',
      jenisLayanan: json['jenis_layanan'] ?? '',
      status: json['status'] ?? '',
      estimatedTime: json['estimated_time'] ?? '',
      reason: json['reason'],
      date: json['date']?.toString(),
    );
  }
}