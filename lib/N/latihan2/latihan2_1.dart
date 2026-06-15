import 'package:flutter/material.dart';

// 1. Titik awal program berjalan
void main() {
  runApp(const AplikasiCafe());
}

// 2. Pengaturan Tema Utama Aplikasi
class AplikasiCafe extends StatelessWidget {
  const AplikasiCafe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafe Kopi Senja',
      home: const HalamanBeranda(), // Memanggil halaman beranda
    );
  }
}

// 3. Desain Halaman Beranda
class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- APPBAR: Bagian Header/Navigasi atas ---
      appBar: AppBar(
        title: const Text('Kopi Senja'), // Ini juga sebuah label (Text)
        backgroundColor: Colors.brown, // Kita gunakan warna tema kopi (cokelat)
        foregroundColor: Colors.white, // Warna teks di AppBar
      ),
      
      // --- BODY: Isi Utama Halaman ---
      body: Center( // Center akan membuat label berada persis di tengah layar
        // INI ADALAH TARGET KITA: Widget Text (Label)
        child: const Text(
          'Selamat Datang di Kopi Senja!',
          style: TextStyle(
            fontSize: 24, // Memperbesar ukuran huruf
            fontWeight: FontWeight.bold, // Menebalkan huruf (Bold)
            color: Colors.brown, // Memberi warna huruf
          ),
        ),
      ),
    );
  }
}