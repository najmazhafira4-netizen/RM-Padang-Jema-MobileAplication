import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HalamanRegistrasi extends StatefulWidget {
  const HalamanRegistrasi({super.key});

  @override
  State<HalamanRegistrasi> createState() => _HalamanRegistrasiState();
}

class _HalamanRegistrasiState extends State<HalamanRegistrasi> {
  // Tambahkan controller untuk nama lengkap agar riwayat pesanan sinkron
  final _namaController = TextEditingController(); 
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // GANTI dengan URL Web App Google Apps Script Anda yang baru di-deploy
  final String urlGoogleScript = 'https://script.google.com/macros/s/AKfycbwIQDaiP-5iVaKHuS9vJFS43tEh2Mt1LrrLe3eoS1YPTJUn29lTJohIDaqXIUKduGlB/exec';

  Future<void> _prosesRegistrasi() async {
    final nama = _namaController.text.trim();
    final user = _usernameController.text.trim();
    final pass = _passwordController.text.trim();
    final konfirmasiPass = _konfirmasiPasswordController.text.trim();

    // Validasi input kosong
    if (nama.isEmpty || user.isEmpty || pass.isEmpty || konfirmasiPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi!')),
      );
      return;
    }

    // Validasi kesamaan password
    if (pass != konfirmasiPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok!'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Mengirim data pendaftaran ke Google Spreadsheet
      var response = await http.post(
        Uri.parse(urlGoogleScript),
        body: jsonEncode({
          "action": "register",
          "nama_lengkap": nama,
          "username": user,
          "password": pass,
        }),
      );

      // Ikuti redirect 302/301 secara manual (sangat penting untuk platform mobile Android/iOS)
      int redirectCount = 0;
      while ((response.statusCode == 302 || response.statusCode == 301) && redirectCount < 5) {
        final location = response.headers['location'];
        if (location == null || location.isEmpty) break;
        response = await http.get(Uri.parse(location));
        redirectCount++;
      }

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 302) {
        final dataRespon = jsonDecode(response.body);

        if (dataRespon['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(dataRespon['message'] ?? 'Registrasi Berhasil!'), backgroundColor: Colors.green),
          );
          // Kembali ke halaman Login jika berhasil
          Navigator.pop(context);
        } else {
          // Menampilkan pesan error dari server jika username sudah dipakai
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(dataRespon['message'] ?? 'Registrasi Gagal'), backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal terhubung ke server'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://4.bp.blogspot.com/-2EBV6oRFjYA/T_sH2JkIXdI/AAAAAAAAABc/r1Dj-Aqdp5w/s1600/DSC_7063gggggggggggggg.jpg'), // Link gambar fallback yang valid
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.65)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: Colors.white.withOpacity(0.92),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person_add, size: 38, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'BUAT AKUN BARU',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const Text('Daftar akun pelanggan Anda gratis', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 25),
                      
                      // INPUT NAMA LENGKAP
                      TextField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge_outlined),
                          labelText: 'Nama Lengkap',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // INPUT USERNAME
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: 'Username Baru',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // INPUT PASSWORD
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // INPUT KONFIRMASI PASSWORD
                      TextField(
                        controller: _konfirmasiPasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_clock_outlined),
                          labelText: 'Konfirmasi Password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      
                      // TOMBOL DAFTAR
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading ? null : _prosesRegistrasi,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('DAFTAR SEKARANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Kembali ke Login', style: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}