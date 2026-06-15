import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiCafe());
}

class AplikasiCafe extends StatelessWidget {
  const AplikasiCafe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafe Kopi Senja',
      home: const HalamanBeranda(),
    );
  }
}

// 1. PERUBAHAN BESAR: HalamanBeranda sekarang menggunakan StatefulWidget
class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  // 2. VARIABEL STATE: Kita membuat variabel untuk menyimpan jumlah pesanan
  int jumlahKopi = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Kopi Senja'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekomendasi Hari Ini',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=150',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kopi Susu Senja',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Perpaduan espresso, susu segar, dan gula aren.',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Rp 20.000',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),

                              // 3. KONTROL JUMLAH (PLUS MINUS)
                              Row(
                                children: [
                                  // Tombol Minus
                                  IconButton(
                                    onPressed: () {
                                      // Mencegah pesanan menjadi minus (kurang dari 0)
                                      if (jumlahKopi > 0) {
                                        // setState adalah perintah WAJIB untuk memperbarui layar
                                        setState(() {
                                          jumlahKopi--; // Mengurangi nilai variabel 1
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    color: Colors.brown,
                                  ),

                                  // Menampilkan nilai dari variabel jumlahKopi
                                  Text(
                                    '$jumlahKopi',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // Tombol Plus
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        jumlahKopi++; // Menambah nilai variabel 1
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    color: Colors.brown,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
