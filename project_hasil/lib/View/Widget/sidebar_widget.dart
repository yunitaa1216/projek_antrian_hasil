import 'package:flutter/material.dart';
import 'package:project_hasil/View/AntrianPage/daftar_antrian_view.dart';
import 'package:project_hasil/View/AntrianPage/riwayat_antrian_view.dart';
import 'package:project_hasil/View/DashboardPage/dashboard_view.dart';
import 'package:project_hasil/View/InputPage/input_view.dart';

class SidebarWidget extends StatelessWidget {
  final bool isSidebarOpen;
  final VoidCallback onClose;
  final String activeMenu;

  const SidebarWidget({
    super.key,
    required this.isSidebarOpen,
    required this.onClose,
    required this.activeMenu,
  });

  static const Color primaryColor = Color(0xff2E2BAF);
  static const Color sidebarColor = Color(0xffF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: sidebarColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            /// HEADER
Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: primaryColor.withOpacity(0.25),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.10),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Row(
    children: [
      Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff2E2BAF),
              Color(0xff5B5FEF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.account_balance_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),

      const SizedBox(width: 12),

      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SIADU",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xff2E2BAF),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Sistem Antrian Dukcapil",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),

      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onClose,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xffEEF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: customGridIcon(color: primaryColor),
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 24),

            /// MENU SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle("MENU UTAMA"),

                    const SizedBox(height: 14),

                    menuItem(
                      context,
                      Icons.dashboard_outlined,
                      "Dashboard",
                      activeMenu == "Dashboard",
                      const DashboardView(),
                    ),

                    menuItem(
                      context,
                      Icons.groups_2_outlined,
                      "Daftar Antrian",
                      activeMenu == "Daftar Antrian",
                      const DaftarAntrianView(),
                    ),

                    menuItem(
                      context,
                      Icons.edit_note_outlined,
                      "Input Antrian",
                      activeMenu == "Input Antrian",
                      const InputView(),
                    ),

                    menuItem(
                      context,
                      Icons.history_rounded,
                      "Riwayat Antrian",
                      activeMenu == "Riwayat Antrian",
                      const RiwayatAntrianView(),
                    ),

                    const SizedBox(height: 20),

                    sectionTitle("LAINNYA"),

                    const SizedBox(height: 14),

                    menuItem(
                      context,
                      Icons.settings_outlined,
                      "Settings",
                      activeMenu == "Settings",
                      const DashboardView(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 10),

            /// OPERATOR PROFILE
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffEEF2FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Operator",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1F2937),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// LOGOUT
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                color: const Color(0xffEEF2FF),
                borderRadius: BorderRadius.circular(16),
              ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Keluar",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
        letterSpacing: 1,
      ),
    );
  }

  Widget menuItem(
    BuildContext context,
    IconData icon,
    String title,
    bool active,
    Widget page,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: active ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: active ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
              if (active)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget customGridIcon({Color color = Colors.black}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          4,
          (index) => Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: index == 2 ? primaryColor : color,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}