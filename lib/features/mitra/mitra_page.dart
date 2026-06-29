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
<<<<<<< HEAD
            onPressed: () async {
              await logout();
              // GoRouter otomatis redirect ke '/' via authNotifier
            },
          ),
=======
            onPressed: () {
              pb.authStore.clear();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
>>>>>>> cbea306aca70b10588f96e97e3bd6e433435fd8a
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
<<<<<<< HEAD
}
=======
}
>>>>>>> cbea306aca70b10588f96e97e3bd6e433435fd8a
