import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  bool isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [

          /// SIDEBAR
          if (isSidebarOpen)
            Container(
              width: 230,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFFEDEFF4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 30),

                  /// HEADER SIDEBAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [

                          Text(
                            "SIADU",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "Sistem Antrian Disdukcapil",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),

                        ],
                      ),

                      IconButton(
                        icon: customGridIcon(),
                        onPressed: () {
                          setState(() {
                            isSidebarOpen = false;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// MENU
                  menuItem(Icons.home_outlined, "Dashboard", true),
                  menuItem(Icons.people_outline, "Daftar Antrian", false),
                  menuItem(Icons.edit_calendar_outlined, "Input Antrian", false),
                  menuItem(Icons.list_alt_outlined, "Riwayat Antrian", false),

                  const Spacer(),

                  /// SETTINGS
                  menuItem(Icons.settings_outlined, "Settings", false),

                  const Divider(),

                  /// ADMIN PROFILE
                  Row(
                    children: const [

                      CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/100",
                        ),
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Admin",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// LOGOUT
                  Row(
                    children: const [

                      Icon(Icons.logout, color: Colors.black54),

                      SizedBox(width: 10),

                      Text("Keluar"),
                    ],
                  ),

                  const SizedBox(height: 20)
                ],
              ),
            ),

          /// MAIN CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              color: const Color(0xFFF1F2F6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER DASHBOARD
                  Row(
                    children: [

                      if (!isSidebarOpen)
                        IconButton(
                          icon: customGridIcon(),
                          onPressed: () {
                            setState(() {
                              isSidebarOpen = true;
                            });
                          },
                        ),

                      const Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// SUMMARY CARD
                  Row(
                    children: [

                      summaryCard(
                        "Antrian Umum",
                        "5",
                        const Color(0xFF3F3D9E),
                      ),

                      const SizedBox(width: 20),

                      summaryCard(
                        "Antrian Prioritas",
                        "2",
                        Colors.white,
                        textDark: true,
                      ),

                      const SizedBox(width: 20),

                      summaryCard(
                        "Total Pengunjung",
                        "155",
                        const Color(0xFF3F3D9E),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: Row(
                      children: [

                        /// AREA GRAFIK
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "Grafik Statistik",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        /// PANEL ANTRIAN
                        Container(
                          width: 250,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Antrian Saat Ini",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 20),

                              antrianCard("Antrian Umum", "2"),

                              const SizedBox(height: 15),

                              antrianCard("Antrian Prioritas", "1"),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// MENU SIDEBAR
  Widget menuItem(IconData icon, String title, bool active) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: active
            ? [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ]
            : [],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: active ? Colors.indigo : Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget customGridIcon() {
  return SizedBox(
    width: 20,
    height: 20,
    child: GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.indigo),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
        ),
      ],
    ),
  );
}

  /// CARD SUMMARY
  Widget summaryCard(String title, String value, Color color,
      {bool textDark = false}) {
    return Expanded(
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: TextStyle(
                color: textDark ? Colors.black : Colors.white,
              ),
            ),

            const Spacer(),

            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textDark ? Colors.black : Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// CARD ANTRIAN
  Widget antrianCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [

          const Icon(Icons.list_alt, color: Colors.indigo),

          const SizedBox(width: 10),

          Expanded(child: Text(title)),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}