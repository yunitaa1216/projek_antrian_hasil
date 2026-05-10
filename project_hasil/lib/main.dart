import 'package:flutter/material.dart';
import 'package:project_hasil/View/LoginPage/login_view.dart';
import 'package:project_hasil/View/DashboardPage/dashboard_view.dart';

void main() {
  runApp(const MyApp());
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
      },
    );
  }
}