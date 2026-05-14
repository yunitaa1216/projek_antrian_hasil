import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project_hasil/Model/DashboardModel/statistik_model.dart';
import 'package:project_hasil/View/Widget/sidebar_widget.dart';
import 'package:project_hasil/ViewModel/dashboard_viewmodel.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isSidebarOpen = true;

  static const Color primary = Color(0xFF3F3D9E);
  static const Color primaryDark = Color(0xFF25237A);
  static const Color bg = Color(0xFFF5F7FB);
  static const Color cardBg = Colors.white;
  static const Color softBlue = Color(0xFFEFF2FF);
  static const Color textDark = Color(0xFF1E1E2D);
  static const Color textGrey = Color(0xFF7A7D8C);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DashboardViewModel>().getStatistik();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardVM = context.watch<DashboardViewModel>();
    final statistik = dashboardVM.statistik;

    return Scaffold(
      backgroundColor: bg,
      body: Row(
        children: [
          if (isSidebarOpen)
            SidebarWidget(
              isSidebarOpen: isSidebarOpen,
              activeMenu: "Dashboard",
              onClose: () {
                setState(() => isSidebarOpen = false);
              },
            ),

          Expanded(
            child: Container(
              color: bg,
              child: Column(
                children: [
                  _header(dashboardVM),

                  Expanded(
                    child: dashboardVM.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : dashboardVM.errorMessage != null
                            ? Center(
                                child: Text(
                                  dashboardVM.errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Summary",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: textDark,
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    Row(
                                      children: [
                                        summaryCard(
                                          title: "Total Pengunjung",
                                          value:
                                              "${statistik?.totalPengunjung ?? 0}",
                                          icon: Icons.groups_rounded,
                                          gradient: const [
                                            primary,
                                            Color(0xFF5A56D6),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        summaryCard(
                                          title: "Total Selesai",
                                          value:
                                              "${statistik?.totalSelesai ?? 0}",
                                          icon: Icons.check_circle_rounded,
                                          isWhite: true,
                                        ),
                                        const SizedBox(width: 20),
                                        summaryCard(
                                          title: "Total Layanan",
                                          value:
                                              "${getTotalLayanan(statistik)}",
                                          icon: Icons.analytics_rounded,
                                          gradient: const [
                                            Color(0xFF312E91),
                                            primary,
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 28),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: dashboardCard(
                                            height: 500,
                                            child: statistikChart(statistik),
                                          ),
                                        ),

                                        const SizedBox(width: 24),

                                        SizedBox(
                                          width: 300,
                                          child: antrianPanel(statistik),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int getTotalLayanan(StatistikModel? statistik) {
    if (statistik == null) return 0;

    return statistik.ktp +
        statistik.aktaKelahiran +
        statistik.aktaKematian +
        statistik.kk +
        statistik.pelayananKkKtp +
        statistik.kia +
        statistik.skpwni +
        statistik.perekaman;
  }

  Widget _header(DashboardViewModel dashboardVM) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isSidebarOpen)
            IconButton(
              icon: SidebarWidget.customGridIcon(),
              onPressed: () {
                setState(() => isSidebarOpen = true);
              },
            ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Pantau statistik dan antrian hari ini",
                style: TextStyle(
                  fontSize: 12,
                  color: textGrey,
                ),
              ),
            ],
          ),

          const Spacer(),

          IconButton(
            onPressed: dashboardVM.isLoading
                ? null
                : () {
                    dashboardVM.refreshStatistik();
                  },
            icon: const Icon(
              Icons.refresh_rounded,
              color: primary,
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: softBlue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(Icons.calendar_month_rounded, size: 16, color: primary),
                SizedBox(width: 8),
                Text(
                  "Harian",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: softBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: primary,
                  size: 20,
                ),
              ),
              Positioned(
                top: 9,
                right: 10,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          const CircleAvatar(
            radius: 20,
            backgroundColor: softBlue,
            child: Icon(Icons.person_rounded, color: primary),
          ),
        ],
      ),
    );
  }

  Widget dashboardCard({
    required Widget child,
    double? height,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget summaryCard({
    required String title,
    required String value,
    required IconData icon,
    List<Color>? gradient,
    bool isWhite = false,
  }) {
    return Expanded(
      child: Container(
        height: 118,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isWhite ? cardBg : null,
          gradient: isWhite ? null : LinearGradient(colors: gradient!),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: (isWhite ? Colors.black : primary).withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isWhite ? softBlue : Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isWhite ? primary : Colors.white,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: isWhite ? textGrey : Colors.white.withOpacity(.82),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: isWhite ? textDark : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget antrianPanel(StatistikModel? statistik) {
  return dashboardCard(
    height: 470,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "Layanan",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              Spacer(),
              Text(
                "Statistik",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          antrianCard(
            title: "Pembuatan KTP",
            value: "${statistik?.ktp ?? 0}",
            icon: Icons.credit_card_rounded,
          ),

          const SizedBox(height: 12),

          antrianCard(
            title: "Pembuatan KK",
            value: "${statistik?.kk ?? 0}",
            icon: Icons.family_restroom_rounded,
          ),

          const SizedBox(height: 12),

          antrianCard(
            title: "Akta Kelahiran",
            value: "${statistik?.aktaKelahiran ?? 0}",
            icon: Icons.child_care_rounded,
          ),

          const SizedBox(height: 12),

          antrianCard(
            title: "Akta Kematian",
            value: "${statistik?.aktaKematian ?? 0}",
            icon: Icons.article_rounded,
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Pengunjung",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${statistik?.totalPengunjung ?? 0} Orang",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget antrianCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primary, size: 21),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget statistikChart(StatistikModel? statistik) {
    final ktp = (statistik?.ktp ?? 0).toDouble();
    final kk = (statistik?.kk ?? 0).toDouble();
    final aktaKelahiran = (statistik?.aktaKelahiran ?? 0).toDouble();
    final aktaKematian = (statistik?.aktaKematian ?? 0).toDouble();
    final pelayananKkKtp = (statistik?.pelayananKkKtp ?? 0).toDouble();
    final kia = (statistik?.kia ?? 0).toDouble();
    final skpwni = (statistik?.skpwni ?? 0).toDouble();
    final perekaman = (statistik?.perekaman ?? 0).toDouble();

    final maxValue = [
      ktp,
      kk,
      aktaKelahiran,
      aktaKematian,
      pelayananKkKtp,
      kia,
      skpwni,
      perekaman,
      5,
    ].reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              "Statistik Layanan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            Spacer(),
            Text(
              "Berdasarkan total data",
              style: TextStyle(
                fontSize: 12,
                color: textGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValue + 2,
              barTouchData: BarTouchData(enabled: true),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(.18),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 34,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: textGrey,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = [
                        'KTP',
                        'KK',
                        'Lahir',
                        'Mati',
                        'KK/KTP',
                        'KIA',
                        'SKPWNI',
                        'Rekam',
                      ];

                      final index = value.toInt();

                      if (index < 0 || index >= labels.length) {
                        return const SizedBox();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          labels[index],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: textGrey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                makeGroupData(0, ktp, const Color(0xFF6C63FF)),
                makeGroupData(1, kk, const Color(0xFF2E2A8F)),
                makeGroupData(2, aktaKelahiran, const Color(0xFFB7C0FF)),
                makeGroupData(3, aktaKematian, const Color(0xFF8B5CF6)),
                makeGroupData(4, pelayananKkKtp, const Color(0xFF3B82F6)),
                makeGroupData(5, kia, const Color(0xFF06B6D4)),
                makeGroupData(6, skpwni, const Color(0xFF6366F1)),
                makeGroupData(7, perekaman, const Color(0xFF1E40AF)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 22),

        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            legendItem(const Color(0xFF6C63FF), "KTP"),
            legendItem(const Color(0xFF2E2A8F), "KK"),
            legendItem(const Color(0xFFB7C0FF), "Akta Kelahiran"),
            legendItem(const Color(0xFF8B5CF6), "Akta Kematian"),
          ],
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
    Color color,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 18,
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  Widget legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}