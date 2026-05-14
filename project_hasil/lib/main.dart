import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project_hasil/View/AntrianPage/daftar_antrian_view.dart';
import 'package:project_hasil/View/AntrianPage/riwayat_antrian_view.dart';
import 'package:project_hasil/View/InputPage/cetak_view.dart';
import 'package:project_hasil/View/InputPage/input_view.dart';
import 'package:project_hasil/View/LoginPage/login_view.dart';
import 'package:project_hasil/View/DashboardPage/dashboard_view.dart';
import 'package:project_hasil/View/ProfilPage/profil_view.dart';
import 'package:project_hasil/ViewModel/queue_viewmodel.dart';
import 'package:project_hasil/Viewmodel/login_viewmodel.dart';
import 'package:project_hasil/ViewModel/queue_list_viewmodel.dart';
import 'package:project_hasil/ViewModel/riwayat_viewmodel.dart';
import 'package:project_hasil/ViewModel/dashboard_viewmodel.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => QueueViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => QueueListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => RiwayatViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Dukcapil',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // halaman pertama
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginView(),
        '/dashboard': (context) => const DashboardView(),
        '/input': (context) => const InputView(),
        '/daftar_antrian': (context) => const DaftarAntrianView(),
        '/riwayat_antrian': (context) => const RiwayatAntrianView(),
        '/profil': (context) => const ProfilView(),
        '/cetak_antrian': (context) => const CetakAntrianView(),
      },
    );
  }
}