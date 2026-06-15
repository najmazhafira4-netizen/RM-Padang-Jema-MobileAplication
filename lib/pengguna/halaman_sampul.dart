import 'package:flutter/material.dart';
import 'halaman_beranda.dart';
import '../auth/halaman_login.dart';

class HalamanSampul extends StatelessWidget {
  final String namaPengguna;
  const HalamanSampul({super.key, required this.namaPengguna});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://4.bp.blogspot.com/-2EBV6oRFjYA/T_sH2JkIXdI/AAAAAAAAABc/r1Dj-Aqdp5w/s1600/DSC_7063gggggggggggggg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanLogin()));
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SELAMAT DATANG DI\nRM PADANG JEMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    // Pastikan namaPengguna ikut dikirim saat berpindah ke HalamanBeranda
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanBeranda(namaPengguna: namaPengguna),
                  ),
                    );
                  },
                  child: const Text('MAU PESAN SEKARANG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}