import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project_hasil/Model/RiwayatModel/riwayat_model.dart';
import 'package:project_hasil/View/Widget/sidebar_widget.dart';
import 'package:project_hasil/ViewModel/riwayat_viewmodel.dart';

class RiwayatAntrianView extends StatefulWidget {
  const RiwayatAntrianView({super.key});

  @override
  State<RiwayatAntrianView> createState() => _RiwayatAntrianViewState();
}

class _RiwayatAntrianViewState extends State<RiwayatAntrianView> {
  bool isSidebarOpen = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RiwayatViewModel>().getRiwayatAntrian();
    });
  }

  String formatLayanan(String value) {
    if (value.isEmpty) return '-';

    switch (value) {
      case 'pembuatan ktp':
        return 'Pembuatan KTP';
      case 'pembuatan kartu keluarga':
        return 'Pembuatan KK';
      case 'akta kelahiran':
        return 'Akta Kelahiran';
      case 'akta kematian':
        return 'Akta Kematian';
      case 'kia':
        return 'KIA';
      case 'skpwni':
        return 'SKPWNI';
      case 'pelayanan kartu keluarga/ktp':
        return 'Pelayanan KK/KTP';
      default:
        return value;
    }
  }

  String formatKategori(String value) {
    if (value == 'umum') return 'Umum';
    if (value == 'prioritas') return 'Prioritas';
    return value.isEmpty ? '-' : value;
  }

  String formatStatus(String value) {
    if (value == 'selesai') return 'Selesai';
    if (value == 'proses') return 'Proses';
    if (value == 'menunggu') return 'Menunggu';
    return value.isEmpty ? '-' : value;
  }

  @override
  Widget build(BuildContext context) {
    final riwayatVM = context.watch<RiwayatViewModel>();

    final totalUmum = riwayatVM.riwayatList
        .where((item) => item.kategori == 'umum')
        .length;

    final totalPrioritas = riwayatVM.riwayatList
        .where((item) => item.kategori == 'prioritas')
        .length;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSidebarOpen)
            SidebarWidget(
              isSidebarOpen: isSidebarOpen,
              activeMenu: "Riwayat Antrian",
              onClose: () {
                setState(() {
                  isSidebarOpen = false;
                });
              },
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (!isSidebarOpen)
                            IconButton(
                              icon: SidebarWidget.customGridIcon(),
                              onPressed: () {
                                setState(() {
                                  isSidebarOpen = true;
                                });
                              },
                            ),
                          const Text(
                            'Riwayat Antrian',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const Row(
                        children: [
                          Icon(Icons.notifications_none),
                          SizedBox(width: 20),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xff2E2BAF),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Home / Riwayat Antrian',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// CARD + REFRESH
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 520,
                        child: buildCardRiwayat(
                          totalUmum: totalUmum,
                          totalPrioritas: totalPrioritas,
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: riwayatVM.isLoading
                            ? null
                            : () {
                                riwayatVM.refreshRiwayat();
                              },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  if (riwayatVM.isLoading)
                    const SizedBox(
                      height: 430,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (riwayatVM.errorMessage != null)
                    Container(
                      width: double.infinity,
                      height: 300,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          riwayatVM.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    buildTable(
                      title: 'Riwayat Antrian Selesai',
                      data: riwayatVM.riwayatList,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardRiwayat({
    required int totalUmum,
    required int totalPrioritas,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff2E2BAF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Color(0xff2E2BAF),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Total Riwayat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCardCount(
                title: 'Antrian Umum',
                count: totalUmum.toString(),
              ),
              buildCardCount(
                title: 'Antrian Prioritas',
                count: totalPrioritas.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCardCount({
    required String title,
    required String count,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildTable({
    required String title,
    required List<RiwayatAntrianModel> data,
  }) {
    return Container(
      width: double.infinity,
      height: 460,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + SEARCH
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                width: 280,
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1250,
                child: Column(
                  children: [
                    buildTableHeader(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: data.isEmpty
                          ? const Center(
                              child: Text(
                                'Belum ada riwayat antrian',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];

                                return tableRow(
                                  nama: item.nama,
                                  nik: item.nik,
                                  alamat: item.alamat,
                                  layanan: formatLayanan(item.jenisLayanan),
                                  telepon: item.telepon,
                                  kategori: formatKategori(item.kategori),
                                  status: formatStatus(item.status),
                                  estimasi: item.estimatedTime,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '${data.length} data riwayat ditampilkan',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF7F8FC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          SizedBox(width: 30),
          Expanded(
            flex: 2,
            child: Text(
              'NAMA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'NIK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ALAMAT',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'LAYANAN',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'NO HP',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'KATEGORI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ESTIMASI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'STATUS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableRow({
    required String nama,
    required String nik,
    required String alamat,
    required String layanan,
    required String telepon,
    required String kategori,
    required String status,
    required String estimasi,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {},
          ),

          Expanded(
            flex: 2,
            child: Text(nama.isEmpty ? '-' : nama),
          ),

          Expanded(
            flex: 2,
            child: Text(nik.isEmpty ? '-' : nik),
          ),

          Expanded(
            flex: 2,
            child: Text(alamat.isEmpty ? '-' : alamat),
          ),

          Expanded(
            flex: 2,
            child: Text(layanan.isEmpty ? '-' : layanan),
          ),

          Expanded(
            flex: 2,
            child: Text(telepon.isEmpty ? '-' : telepon),
          ),

          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                kategori,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.indigo,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(estimasi.isEmpty ? '-' : estimasi),
          ),

          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}