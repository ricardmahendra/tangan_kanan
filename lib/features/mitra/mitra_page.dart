import 'package:flutter/material.dart';
import '../../core/pocketbase/pb.dart';

class MitraPage extends StatelessWidget {
  const MitraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mitra Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              pb.authStore.clear();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Selamat datang di Halaman Mitra',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
