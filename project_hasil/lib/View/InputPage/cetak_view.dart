import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CetakAntrianView extends StatelessWidget {
  const CetakAntrianView({super.key});

  static const Color primaryColor = Color(0xff2E2BAF);
  static const Color bgColor = Color(0xffF5F6FA);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String uuid = args?['uuid']?.toString() ?? '-';
    final String nomorAntrian = args?['nomor_antrian']?.toString() ?? '-';
    final String nama = args?['nama']?.toString() ?? '-';
    final String nik = args?['nik']?.toString() ?? '-';
    final String jenisLayanan = args?['jenis_layanan']?.toString() ?? '-';
    final String kategori = args?['kategori']?.toString() ?? '-';
    final String estimatedTime = args?['estimated_time']?.toString() ?? '-';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cetak Antrian',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            icon: const Icon(Icons.home_rounded),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 390,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF2FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.account_balance_outlined,
                    color: primaryColor,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'SIADU',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Sistem Antrian Dukcapil',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                dashedDivider(),

                const SizedBox(height: 24),

                const Text(
                  'NOMOR ANTRIAN',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff2E2BAF),
                        Color(0xff5B5FEF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    nomorAntrian == '-' || nomorAntrian.isEmpty
                        ? generateFallbackNumber(uuid)
                        : nomorAntrian,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                buildInfoRow(
                  icon: Icons.person_outline,
                  label: 'Nama',
                  value: nama,
                ),

                buildInfoRow(
                  icon: Icons.badge_outlined,
                  label: 'NIK',
                  value: nik,
                ),

                buildInfoRow(
                  icon: Icons.category_outlined,
                  label: 'Jenis Layanan',
                  value: jenisLayanan,
                ),

                buildInfoRow(
                  icon: Icons.people_outline,
                  label: 'Kategori',
                  value: kategori,
                ),

                buildInfoRow(
                  icon: Icons.timer_outlined,
                  label: 'Estimasi',
                  value: estimatedTime,
                ),

                const SizedBox(height: 18),

                dashedDivider(),

                const SizedBox(height: 18),

                const Text(
                  'Silakan menunggu hingga nomor antrian Anda dipanggil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/input',
                          );
                        },
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Input Lagi'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: const BorderSide(
                            color: primaryColor,
                            width: 1.3,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
  await printTicket(
    nomorAntrian: nomorAntrian == '-' || nomorAntrian.isEmpty
        ? generateFallbackNumber(uuid)
        : nomorAntrian,
    nama: nama,
    jenisLayanan: jenisLayanan,
    kategori: kategori,
    estimatedTime: estimatedTime,
  );
},
                        icon: const Icon(
                          Icons.print_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Cetak',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/daftar_antrian',
                      );
                    },
                    child: const Text(
                      'Lihat Daftar Antrian',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateFallbackNumber(String uuid) {
    if (uuid == '-' || uuid.isEmpty) {
      return 'U000';
    }

    final cleanUuid = uuid.replaceAll('-', '').toUpperCase();

    if (cleanUuid.length >= 4) {
      return 'U${cleanUuid.substring(0, 4)}';
    }

    return 'U$cleanUuid';
  }

  Future<void> printTicket({
  required String nomorAntrian,
  required String nama,
  required String jenisLayanan,
  required String kategori,
  required String estimatedTime,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: const PdfPageFormat(
        80 * PdfPageFormat.mm,
        140 * PdfPageFormat.mm,
        marginAll: 8 * PdfPageFormat.mm,
      ),
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'SIADU',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                'Sistem Antrian Dukcapil',
                style: const pw.TextStyle(
                  fontSize: 10,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Divider(),

              pw.SizedBox(height: 10),

              pw.Text(
                'NOMOR ANTRIAN',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  nomorAntrian,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 34,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 16),

              pdfInfoRow('Nama', nama),
              pdfInfoRow('Jenis Layanan', jenisLayanan),
              pdfInfoRow('Kategori', kategori),
              pdfInfoRow('Estimasi', estimatedTime),

              pw.SizedBox(height: 12),

              pw.Divider(),

              pw.SizedBox(height: 8),

              pw.Text(
                'Silakan menunggu hingga nomor antrian Anda dipanggil.',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text(
                'Terima kasih',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

pw.Widget pdfInfoRow(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(
            fontSize: 10,
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Text(
            value.isEmpty ? '-' : value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF7F8FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: primaryColor,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dashedDivider() {
    return Row(
      children: List.generate(
        24,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 1,
            color: index.isEven ? Colors.grey.shade300 : Colors.transparent,
          ),
        ),
      ),
    );
  }
}