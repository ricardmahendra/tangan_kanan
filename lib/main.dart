import 'package:flutter/material.dart';
import 'core/pocketbase/pb.dart';
import 'core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPocketBase(); // restore token sebelum runApp
  runApp(const TanganKananApp());
}

class TanganKananApp extends StatelessWidget {
  const TanganKananApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}