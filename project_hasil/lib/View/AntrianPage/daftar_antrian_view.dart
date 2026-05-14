import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project_hasil/Model/AntrianModel/queue_list_model.dart';
import 'package:project_hasil/View/Widget/sidebar_widget.dart';
import 'package:project_hasil/ViewModel/queue_list_viewmodel.dart';

class DaftarAntrianView extends StatefulWidget {
  const DaftarAntrianView({super.key});

  @override
  State<DaftarAntrianView> createState() => _DaftarAntrianViewState();
}

class _DaftarAntrianViewState extends State<DaftarAntrianView> {
  bool isSidebarOpen = true;
  String selectedKategori = 'umum';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<QueueListViewModel>().getAllQueue();
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

  String getStatusValue(String value) {
    if (value == 'menunggu' || value == 'proses' || value == 'selesai') {
      return value;
    }

    return 'menunggu';
  }

  @override
  Widget build(BuildContext context) {
    final queueVM = context.watch<QueueListViewModel>();

    final selectedData = selectedKategori == 'umum'
        ? queueVM.antrianUmum
        : queueVM.antrianPrioritas;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSidebarOpen)
            SidebarWidget(
              isSidebarOpen: isSidebarOpen,
              activeMenu: "Daftar Antrian",
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
                            'Daftar Antrian',
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
                    'Home / Daftar Antrian',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// CARD + BUTTON
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 620,
                        child: buildCardAntrian(queueVM),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/riwayat_antrian');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2E2BAF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Lihat Riwayat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: queueVM.isLoading
                            ? null
                            : () {
                                queueVM.refreshQueue();
                              },
                        icon: const Icon(Icons.refresh, color: Colors.white),
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

                  const SizedBox(height: 30),

                  /// PILIH KATEGORI
                  Wrap(
                    spacing: 14,
                    runSpacing: 12,
                    children: [
                      buildKategoriButton(
                        title: 'Antrian Umum',
                        value: 'umum',
                        icon: Icons.people_outline,
                      ),
                      buildKategoriButton(
                        title: 'Antrian Prioritas',
                        value: 'prioritas',
                        icon: Icons.priority_high_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (queueVM.isLoading)
                    const SizedBox(
                      height: 430,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (queueVM.errorMessage != null)
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
                          queueVM.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    buildTable(
                      title: selectedKategori == 'umum'
                          ? 'Tabel Antrian Umum'
                          : 'Tabel Antrian Prioritas',
                      data: selectedData,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardAntrian(QueueListViewModel queueVM) {
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
                  Icons.people_outline,
                  color: Color(0xff2E2BAF),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Antrian',
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
                count: queueVM.antrianUmum.length.toString(),
              ),
              buildCardCount(
                title: 'Antrian Prioritas',
                count: queueVM.antrianPrioritas.length.toString(),
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
          style: const TextStyle(color: Colors.white70),
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

  Widget buildKategoriButton({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final active = selectedKategori == value;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          selectedKategori = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: active ? const Color(0xff2E2BAF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? const Color(0xff2E2BAF) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? Colors.white : const Color(0xff2E2BAF),
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xff1F2937),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTable({
    required String title,
    required List<QueueItemModel> data,
  }) {
    return Container(
      width: double.infinity,
      height: 430,
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
                width: 260,
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
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, size: 20, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1050,
                child: Column(
                  children: [
                    buildTableHeader(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: data.isEmpty
                          ? const Center(
                              child: Text(
                                'Belum ada data antrian',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];

                                return tableRow(
  id: item.uuid,
  nomorAntrian: item.nomorAntrian,
  nama: item.nama,
  nik: item.nik,
  layanan: formatLayanan(item.jenisLayanan),
  kategori: item.kategori,
  telepon: item.telepon,
  status: item.status,
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
          SizedBox(
            width: 90,
            child: Text(
              'AKSI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableRow({
  required String id,
  required String nomorAntrian,
  required String nama,
  required String nik,
  required String layanan,
  required String kategori,
  required String telepon,
  required String status,
  required String estimasi,
}) {
    final String currentStatus = getStatusValue(status);

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
            child: Text(layanan.isEmpty ? '-' : layanan),
          ),

          Expanded(
            flex: 2,
            child: Text(telepon.isEmpty ? '-' : telepon),
          ),

          Expanded(
            flex: 2,
            child: Text(estimasi.isEmpty ? '-' : estimasi),
          ),

          Expanded(
            flex: 2,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: getStatusColor(currentStatus).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentStatus,
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: getStatusColor(currentStatus),
                  ),
                  dropdownColor: Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: 'menunggu',
                      child: Text(
                        'Menunggu',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'proses',
                      child: Text(
                        'Sedang Diproses',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'selesai',
                      child: Text(
                        'Selesai',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  onChanged: (String? value) async {
                    if (value == null) return;
                    if (value == currentStatus) return;

                    final queueVM = context.read<QueueListViewModel>();

                    final success = await queueVM.updateStatusQueue(
                      id: id,
                      status: value,
                    );

                    if (!mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Status berhasil diubah'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            queueVM.errorMessage ?? 'Gagal mengubah status',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),

          SizedBox(
            width: 90,
            child: Row(
              children: [
                IconButton(
  onPressed: () {
    Navigator.pushNamed(
      context,
      '/cetak_antrian',
      arguments: {
        'uuid': id,
        'nomor_antrian': nomorAntrian,
        'nama': nama,
        'nik': nik,
        'jenis_layanan': layanan,
        'kategori': kategori,
        'estimated_time': estimasi,
      },
    );
  },
  icon: const Icon(
    Icons.print,
    color: Colors.indigo,
    size: 18,
  ),
),
                IconButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Antrian'),
          content: const Text(
            'Yakin ingin menghapus data antrian ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                final queueVM = context.read<QueueListViewModel>();

                final success = await queueVM.deleteQueue(
                  id: id,
                );

                if (!mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Antrian berhasil dihapus'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        queueVM.errorMessage ?? 'Gagal menghapus antrian',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  },
  icon: const Icon(
    Icons.delete,
    color: Colors.red,
    size: 18,
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'proses':
        return Colors.orange;
      case 'menunggu':
      default:
        return Colors.indigo;
    }
  }
}