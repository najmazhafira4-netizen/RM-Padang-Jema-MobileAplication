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
      appBar: AppBar(
        title: const Text('Kopi Senja'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      
      // --- PERUBAHAN ADA DI SINI ---
      // Kita bungkus Column dengan Padding agar teks tidak menempel ketat di pinggir layar HP
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Memberi jarak 20 pixel di semua sisi
        
        // COLUMN: Menyusun widget dari atas ke bawah
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Mengatur agar semua teks rata kiri
          children: [ // 'children' (pakai 'ren') karena isinya BANYAK widget
            
            // 1. Label Judul Utama
            const Text(
              'Menu Spesial Hari Ini',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // SizedBox berfungsi sebagai spasi kosong atau jarak enter antar komponen
            const SizedBox(height: 20), 
            
            // 2. Label Sub-judul
            const Text(
              'Kopi Pilihan:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.brown,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // 3. Label Daftar Menu 1
            const Text(
              '- Kopi Susu Senja (Rp 20.000)',
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 8),
            
            // 4. Label Daftar Menu 2
            const Text(
              '- Espresso Pagi (Rp 15.000)',
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 8),
            
            // 5. Label Daftar Menu 3
            const Text(
              '- Matcha Latte (Rp 25.000)',
              style: TextStyle(fontSize: 16),
            ),
            
          ],
        ),
      ),
    );
  }
}