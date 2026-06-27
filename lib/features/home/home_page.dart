import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
  final services = [
    {"icon": Icons.cleaning_services, "title": "Pembersihan"},
    {"icon": Icons.ac_unit, "title": "Service AC"},
    {"icon": Icons.handyman, "title": "Perbaikan"},
    {"icon": Icons.grass, "title": "Berkebun"},
    {"icon": Icons.spa, "title": "Pijat"},
    {"icon": Icons.directions_car, "title": "Cuci Mobil"},
    {"icon": Icons.local_laundry_service, "title": "Laundry"},
    {"icon": Icons.more_horiz, "title": "Lainnya"},
  ];
  

      return Scaffold(
    backgroundColor: const Color(0xFFF6F8FC),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF0050CB),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Jepara, Indonesia',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.person),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: 'Cari jasa (bersih-bersih, AC, dll)',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0050CB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Diskon 20%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
              const SizedBox(height: 20),

              /// GRID MENU
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: .9,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            const Color(0xFFEAF2FF),
                        child: Icon(
                          services[index]["icon"]
                              as IconData,
                          color: const Color(0xFF0050CB),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        services[index]["title"]
                            as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              /// HEADER LAYANAN
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Layanan Populer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// CARD POPULER
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _serviceCard(),
                    const SizedBox(width: 12),
                    _serviceCard(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// KEUNGGULAN
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mengapa Pilih TanganKanan?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _featureCard(
                      Icons.verified_user,
                      'Mitra Terverifikasi',
                      'Semua pekerja telah melalui seleksi ketat.',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _featureCard(
                      Icons.payments,
                      'Harga Transparan',
                      'Tidak ada biaya tersembunyi.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _serviceCard() {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Container(
              height: 120,
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(
                  Icons.cleaning_services,
                  size: 50,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'TERPOPULER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Deep Cleaning Rumah',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Mulai dari Rp150.000',
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Pesanan'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _featureCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF0050CB),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}