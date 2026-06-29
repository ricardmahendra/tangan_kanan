import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Base URL otomatis sesuai platform
String get _baseUrl {
  if (kIsWeb) return 'http://10.119.44.44:8090';
  return 'http://10.119.44.44:8090';
}

// Instance global PocketBase
final pb = PocketBase(_baseUrl);

// Notifier untuk GoRouter refresh saat auth berubah
final authNotifier = _AuthNotifier();

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier() {
    pb.authStore.onChange.listen((_) {
      notifyListeners();
    });
  }
}

// Panggil ini di main() sebelum runApp
Future<void> initPocketBase() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('pb_token') ?? '';

  // Restore token kalau ada
  if (token.isNotEmpty) {
    pb.authStore.save(token, null);

    // Validasi token ke server
    try {
      await pb.collection('users').authRefresh();
    } catch (_) {
      // Token expired atau invalid — bersihkan
      pb.authStore.clear();
      await prefs.remove('pb_token');
    }
  }

  // Listen perubahan token — simpan atau hapus
  pb.authStore.onChange.listen((event) async {
    final prefs = await SharedPreferences.getInstance();
    if (event.token.isNotEmpty) {
      await prefs.setString('pb_token', event.token);
    } else {
      await prefs.remove('pb_token');
    }
  });
}

// Logout helper
Future<void> logout() async {
  pb.authStore.clear();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('pb_token');
}

// Helper ambil role user yang sedang login
String get currentRole {
  final model = pb.authStore.model;
  if (model == null) return '';
  return (model.data['role'] as String?) ?? 'user';
}

// Helper ambil nama user yang sedang login
String get currentName {
  final model = pb.authStore.model;
  if (model == null) return '';
  return (model.data['name'] as String?) ?? '';
}