import 'package:flutter/material.dart';
import 'package:tangan_kanan/features/main/main_page.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';
import 'features/home/home_page.dart';
import 'features/admin/admin_page.dart';
import 'features/mitra/mitra_page.dart';


void main() {
  runApp(const TanganKananApp());
}

class TanganKananApp extends StatelessWidget {
  const TanganKananApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/main': (context) => const MainPage(),
        '/admin': (context) => const AdminPage(),
        '/mitra': (context) => const MitraPage(),
      },
    );
  }
}