import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project_hasil/View/Widget/sidebar_widget.dart';
import 'package:project_hasil/ViewModel/queue_viewmodel.dart';
import 'package:project_hasil/ViewModel/queue_list_viewmodel.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  bool isSidebarOpen = true;

  String? selectedLayanan;
  String? selectedKategori;
  String? selectedReason;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  final List<String> layananList = [
    'Pembuatan KTP',
    'Pembuatan KK',
    'Akta Kelahiran',
    'Akta Kematian',
    'KIA',
    'SKPWNI',
    'Pelayanan KK/KTP',
  ];

  final List<String> kategoriList = [
    'Umum',
    'Prioritas',
  ];

  final List<String> reasonList = [
    'Perubahan Data',
    'Rusak',
    'Hilang',
    'Luar Daerah',
  ];

  bool get isKtpSelected => selectedLayanan == 'Pembuatan KTP';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<QueueListViewModel>().getAllQueue();
    });
  }

  @override
  void dispose() {
    namaController.dispose();
    nikController.dispose();
    alamatController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  String mapLayananToApi(String layanan) {
    switch (layanan) {
      case 'Pembuatan KTP':
        return 'pembuatan ktp';
      case 'Pembuatan KK':
        return 'pembuatan kartu keluarga';
      case 'Akta Kelahiran':
        return 'akta kelahiran';
      case 'Akta Kematian':
        return 'akta kematian';
      case 'KIA':
        return 'kia';
      case 'SKPWNI':
        return 'skpwni';
      case 'Pelayanan KK/KTP':
        return 'pelayanan kartu keluarga/ktp';
      default:
        return layanan.toLowerCase();
    }
  }

  String mapKategoriToApi(String kategori) {
    return kategori.toLowerCase();
  }

  String mapReasonToApi(String reason) {
    return reason.toLowerCase();
  }

  void clearForm() {
    namaController.clear();
    nikController.clear();
    alamatController.clear();
    teleponController.clear();

    setState(() {
      selectedLayanan = null;
      selectedKategori = null;
      selectedReason = null;
    });
  }

  Future<void> handleTambahAntrian() async {
    final nama = namaController.text.trim();
    final nik = nikController.text.trim();
    final alamat = alamatController.text.trim();
    final telepon = teleponController.text.trim();

    if (nama.isEmpty ||
        nik.isEmpty ||
        alamat.isEmpty ||
        telepon.isEmpty ||
        selectedLayanan == null ||
        selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data wajib diisi'),
        ),
      );
      return;
    }

    if (isKtpSelected && selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alasan wajib dipilih untuk layanan Pembuatan KTP'),
        ),
      );
      return;
    }

    final queueVM = context.read<QueueViewModel>();

    final success = await queueVM.createQueue(
      nama: nama,
      nik: nik,
      alamat: alamat,
      telepon: telepon,
      kategori: mapKategoriToApi(selectedKategori!),
      jenisLayanan: mapLayananToApi(selectedLayanan!),
      reason: isKtpSelected ? mapReasonToApi(selectedReason!) : null,
    );

    if (!mounted) return;

    if (success) {
      await context.read<QueueListViewModel>().refreshQueue();

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        '/cetak_antrian',
        arguments: {
          'uuid': queueVM.uuid ?? '',
          'nomor_antrian': queueVM.nomorAntrian ?? '',
          'nama': nama,
          'nik': nik,
          'jenis_layanan': selectedLayanan ?? '-',
          'kategori': selectedKategori ?? '-',
          'estimated_time': queueVM.estimatedTime ?? '-',
        },
      );

      clearForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(queueVM.errorMessage ?? 'Gagal menambah antrian'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final queueVM = context.watch<QueueViewModel>();
    final queueListVM = context.watch<QueueListViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Row(
        children: [
          if (isSidebarOpen)
            SidebarWidget(
              isSidebarOpen: isSidebarOpen,
              activeMenu: "Input Antrian",
              onClose: () {
                setState(() {
                  isSidebarOpen = false;
                });
              },
            ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
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
                              'Input Antrian',
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
                      'Home / Input Antrian',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// CARD ANTRIAN
                    Row(
                      children: [
                        Expanded(
                          child: Container(
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
                                    const Spacer(),
                                    IconButton(
                                      onPressed: queueListVM.isLoading
                                          ? null
                                          : () {
                                              queueListVM.refreshQueue();
                                            },
                                      icon: const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Antrian Umum',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          queueListVM.isLoading
                                              ? '...'
                                              : '${queueListVM.antrianUmum.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Antrian Prioritas',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          queueListVM.isLoading
                                              ? '...'
                                              : '${queueListVM.antrianPrioritas.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/daftar_antrian');
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
                            'Lihat Antrian Saat Ini',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    const Divider(),

                    const SizedBox(height: 20),

                    const Text(
                      'Informasi User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            hint: 'Nama Lengkap',
                            controller: namaController,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: buildTextField(
                            hint: 'NIK',
                            controller: nikController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            hint: 'Alamat',
                            controller: alamatController,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: buildDropdownLayanan(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 110,
                                child: Container(
                                  height: 56,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE8EEF8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        '🇮🇩',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(width: 5),
                                      Text('+62'),
                                      Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: buildTextField(
                                  hint: 'Nomor Telepon',
                                  controller: teleponController,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: buildDropdownKategori(),
                        ),
                      ],
                    ),

                    if (isKtpSelected) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: buildDropdownReason(),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed:
                          queueVM.isLoading ? null : handleTambahAntrian,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2E2BAF),
                        disabledBackgroundColor:
                            const Color(0xff2E2BAF).withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: queueVM.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Tambah Antrian',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),

                    const SizedBox(height: 30),

                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xffE8EEF8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }

  Widget buildDropdownLayanan() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffE8EEF8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLayanan,
          hint: const Text('Jenis Layanan'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: layananList.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedLayanan = value;

              if (selectedLayanan != 'Pembuatan KTP') {
                selectedReason = null;
              }
            });
          },
        ),
      ),
    );
  }

  Widget buildDropdownKategori() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffE8EEF8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedKategori,
          hint: const Text('Kategori Antrian'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: kategoriList.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedKategori = value;
            });
          },
        ),
      ),
    );
  }

  Widget buildDropdownReason() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffE8EEF8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xff2E2BAF),
          width: 1.2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedReason,
          hint: const Text('Alasan Pembuatan KTP'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: reasonList.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedReason = value;
            });
          },
        ),
      ),
    );
  }
}