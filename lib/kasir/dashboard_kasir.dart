import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../admin/struk_transaksi.dart';
import '../auth/halaman_login.dart';

class DashboardKasir extends StatefulWidget {
  const DashboardKasir({super.key});

  @override
  State<DashboardKasir> createState() => _DashboardKasirState();
}

class _DashboardKasirState extends State<DashboardKasir> {
  List<dynamic> _riwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    const String url = 'https://script.google.com/macros/s/AKfycbwIQDaiP-5iVaKHuS9vJFS43tEh2Mt1LrrLe3eoS1YPTJUn29lTJohIDaqXIUKduGlB/exec?p=riwayat';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _riwayat = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Kasir'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('BATAL')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanLogin()));
            },
            child: const Text('YA KELUAR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kasir - Monitor Order'),
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), tooltip: 'Logout Kasir', onPressed: _logoutDialog),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.orange)) 
          : _riwayat.isEmpty 
              ? const Center(child: Text('Belum ada pesanan masuk.')) 
              : ListView.builder(
                  itemCount: _riwayat.length,
                  itemBuilder: (context, index) {
                    final dataPesanan = _riwayat[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanStruk(dataPesanan: dataPesanan)));
                        },
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.payment, color: Colors.white),
                        ),
                        title: Text(dataPesanan['Nama'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Meja: ${dataPesanan['Meja'] ?? '-'} \nWaktu: ${dataPesanan['Waktu'] ?? '-'}"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                ),
    );
  }
}