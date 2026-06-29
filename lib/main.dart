import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'core/pocketbase/pb.dart';
import 'core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPocketBase(); // restore token sebelum runApp
=======
import 'package:tangan_kanan/features/main/main_page.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';
import 'features/home/home_page.dart';
import 'features/admin/admin_page.dart';
import 'features/mitra/mitra_page.dart';


void main() {
>>>>>>> cbea306aca70b10588f96e97e3bd6e433435fd8a
  runApp(const TanganKananApp());
}

class TanganKananApp extends StatelessWidget {
  const TanganKananApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp.router(
      title: 'TanganKanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0050CB),
          primary: const Color(0xFF0050CB),
        ),
      ),
      routerConfig: AppRouter.router,
=======
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
>>>>>>> cbea306aca70b10588f96e97e3bd6e433435fd8a
    );
  }
}