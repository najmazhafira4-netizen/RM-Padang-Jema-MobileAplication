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

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Memberi warna abu-abu terang pada latar belakang
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // --- KARTU MENU ---
            Card(
              elevation: 4, // Memberikan efek bayangan agar terlihat timbul
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Membuat sudut kartu melengkung
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                // ROW: Menyusun elemen dari Kiri ke Kanan
                child: Row(
                  children: [
                    // 1. KIRI: Gambar Kopi (mengambil dari internet)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Melengkungkan sudut gambar
                      child: Image.network(
                        'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=150',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover, // Memotong gambar agar pas dengan ukuran kotak
                      ),
                    ),
                    
                    const SizedBox(width: 15), // Jarak horizontal antara gambar dan teks
                    
                    // 2. KANAN: Teks (disusun atas ke bawah dengan Column)
                    // Expanded digunakan agar teks mengambil sisa ruang yang ada dan tidak error (overflow)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Kopi Susu Senja',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Perpaduan espresso, susu segar, dan gula aren.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Rp 20.000',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
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