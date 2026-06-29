import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../core/pocketbase/pb.dart';
import 'mitra_registration_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isChecking = true;
  bool _isPending = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  Future<void> _checkRegistrationStatus() async {
    final user = pb.authStore.model as RecordModel?;
    if (user == null || user.getStringValue('role') != 'user') {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
      return;
    }

    try {
      final email = user.getStringValue('email');
      final records = await pb.collection('partners').getList(
        filter: 'email = "$email"',
      );

      if (records.items.isNotEmpty) {
        final record = records.items.first;
        if (record.getBoolValue('is_verified') == false) {
          _isPending = true;
        }
      }
    } catch (e) {
      debugPrint('Gagal mengecek status partner: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _logout() async {
  await logout();
  }

  void _navigateToRegistration() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MitraRegistrationPage()),
    );

    // Jika pendaftaran berhasil, cek ulang statusnya
    if (result == true) {
      setState(() {
        _isChecking = true;
      });
      _checkRegistrationStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = pb.authStore.model as RecordModel?;
    final name = user?.getStringValue('name') ?? 'Pengguna';
    final email = user?.getStringValue('email') ?? '';
    final phone = user?.getStringValue('phone') ?? '';
    final role = user?.getStringValue('role') ?? 'user';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF0050CB),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: role == 'mitra' ? Colors.green : (role == 'admin' ? Colors.red : Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  role.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              if (role == 'user')
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: _isChecking || _isPending ? null : _navigateToRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPending ? Colors.grey : const Color(0xFF0050CB),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isChecking
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isPending ? 'Pendaftaran Sedang Diproses' : 'Daftar sebagai Mitra',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}