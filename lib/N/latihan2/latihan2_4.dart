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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // --- KARTU MENU ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Padding dalam kartu sedikit diperbesar
                child: Row(
                  children: [
                    // Gambar Kopi
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
                    
                    // Detail Teks dan Tombol
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
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          // ROW BARU: Untuk menata Harga dan Tombol bersebelahan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Memisahkan kiri dan kanan sejauh mungkin
                            children: [
                              const Text(
                                'Rp 20.000',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              
                              // TOMBOL PESAN
                              ElevatedButton(
                                onPressed: () {
                                  // Perintah untuk memunculkan notifikasi pop-up
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('☕ Kopi Susu Senja ditambahkan ke pesanan!'),
                                      backgroundColor: Colors.green[700],
                                      duration: const Duration(seconds: 2), // Muncul selama 2 detik
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Pesan'),
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