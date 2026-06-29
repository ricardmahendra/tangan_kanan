import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pocketbase/pb.dart';
import '../../features/auth/login/login_page.dart';
import '../../features/auth/register/register_page.dart';
import '../../features/main/main_page.dart';
import '../../features/admin/admin_page.dart';
import '../../features/mitra/mitra_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier, // auto refresh saat login/logout
    redirect: (context, state) {
      final isLoggedIn = pb.authStore.isValid;
      final loc = state.matchedLocation;

      final isAuthPage = loc == '/' || loc == '/register';

      // Belum login → paksa ke login
      if (!isLoggedIn && !isAuthPage) return '/';

      // Sudah login → tidak boleh ke halaman auth
      if (isLoggedIn && isAuthPage) {
        final role = currentRole;
        if (role == 'admin') return '/admin';
        if (role == 'mitra') return '/mitra';
        return '/main';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPage(),
      ),
      GoRoute(
        path: '/mitra',
        builder: (context, state) => const MitraPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Halaman tidak ditemukan: ${state.error}'),
      ),
    ),
  );
}