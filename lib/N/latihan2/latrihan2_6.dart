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

// --- HALAMAN PERTAMA (BERANDA) ---
class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                          const Text('Kopi Susu Senja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          const Text('Perpaduan espresso, susu segar, dan gula aren.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Rp 20.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (jumlahKopi > 0) {
                                        setState(() { jumlahKopi--; });
                                      }
                                    },
                                    icon: const Icon(Icons.remove_circle_outline),
                                    color: Colors.brown,
                                  ),
                                  Text('$jumlahKopi', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () {
                                      setState(() { jumlahKopi++; });
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
      
      // 1. TOMBOL MELAYANG (FLOATING ACTION BUTTON)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 2. NAVIGASI: Perintah untuk menumpuk halaman baru (push)
          Navigator.push(
            context,
            MaterialPageRoute(
              // Mengirim data jumlahKopi ke HalamanKeranjang
              builder: (context) => HalamanKeranjang(totalPesanan: jumlahKopi), 
            ),
          );
        },
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Keranjang'),
      ),
    );
  }
}

// --- HALAMAN KEDUA (KERANJANG) ---
class HalamanKeranjang extends StatelessWidget {
  // 3. MENERIMA DATA: Kita buat variabel penampung di halaman baru
  final int totalPesanan;

  // Constructor wajib diisi dengan variabel yang kita minta
  const HalamanKeranjang({super.key, required this.totalPesanan});

  @override
  Widget build(BuildContext context) {
    // Menghitung total harga (jumlah kopi dikali Rp 20.000)
    int totalHarga = totalPesanan * 20000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Anda'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            
            // 4. MENAMPILKAN DATA DARI HALAMAN SEBELUMNYA
            Text(
              'Anda memesan $totalPesanan Kopi Susu Senja',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Pembayaran: Rp $totalHarga',
              style: const TextStyle(fontSize: 18, color: Colors.brown, fontWeight: FontWeight.w600),
            ),
            
            const SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: () {
                // Perintah untuk membuang halaman ini dan kembali ke halaman sebelumnya (pop)
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: const Text('Kembali ke Menu'),
            ),
          ],
        ),
      ),
    );
  }
}