import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'halaman_registrasi.dart';
import '../admin/dashboard_admin.dart';
import '../kasir/dashboard_kasir.dart';
import '../pengguna/halaman_sampul.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // GANTI dengan URL Web App Google Apps Script Anda yang baru
  final String urlGoogleScript = 'https://script.google.com/macros/s/AKfycby8l_DtCoWgPRJ7-4uxyX4IQjk5UoAD2izt1pBqwFxPcLPHffVG8iMv5Y9KryMfUM8s/exec';

  Future<void> _prosesLogin() async {
    final user = _usernameController.text.trim();
    final pass = _passwordController.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan Password tidak boleh kosong!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Kirim request login ke Google Spreadsheet
      final response = await http.post(
        Uri.parse(urlGoogleScript),
        body: jsonEncode({
          "action": "login",
          "username": user,
          "password": pass,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        final dataRespon = jsonDecode(response.body);

        if (dataRespon['status'] == 'success') {
          // Tangkap nama asli pengguna dari spreadsheet
          String namaUser = dataRespon['nama'] ?? user; 

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Berhasil! Selamat datang, $namaUser'), backgroundColor: Colors.green),
          );

          // 2. Cek Role Akun Secara Manual (Bisa disesuaikan jika admin/kasir masih lokal)
          if (user.toLowerCase() == 'admin' && pass == '123') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardAdmin()),
            );
          } else if (user.toLowerCase() == 'kasir' && pass == '123') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardKasir()),
            );
          } else {
            // Oper DATA NAMA USER ke HalamanSampul agar halaman history bisa membaca datanya
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HalamanSampul(namaPengguna: namaUser),
              ),
            );
          }
        } else {
          // Gagal login (Username/Password salah)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(dataRespon['message'] ?? 'Login Gagal!'), backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal terhubung ke server!'), backgroundColor: Colors.red),
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

  void _prosesLoginGoogle() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login via Google Berhasil!'), backgroundColor: Colors.green),
      );
      // Untuk Google Auth simulasi, kita default kan nama pengguna sebagai "Pelanggan Google"
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HalamanSampul(namaPengguna: "Pelanggan Google")),
      );
    });
  }

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
                        radius: 40,
                        backgroundColor: Color.fromARGB(255, 174, 23, 23),
                        child: Icon(Icons.restaurant_menu, size: 45, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'RM PADANG JEMA',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 174, 23, 23), letterSpacing: 1.5),
                      ),
                      const Text('Sistem Akses Portal Pengguna', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 25),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: 'Username',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 174, 23, 23),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading ? null : _prosesLogin,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('MASUK SISTEM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("atau", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          icon: Image.network(
                            'https://thumbs.dreamstime.com/b/google-logo-vector-format-white-background-illustration-407571048.jpg',
                            height: 22,
                          ),
                          label: const Text('Masuk dengan Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading ? null : _prosesLoginGoogle,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? ", style: TextStyle(fontSize: 13)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HalamanRegistrasi()),
                              );
                            },
                            child: const Text(
                              "Daftar Sekarang",
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13, decoration: TextDecoration.underline),
                            ),
                          )
                        ],
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