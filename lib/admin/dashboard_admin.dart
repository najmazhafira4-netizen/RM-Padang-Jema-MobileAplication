import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail_laporan.dart';
import 'struk_transaksi.dart';
import '../auth/halaman_login.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  List<dynamic> _riwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    const String url = 'https://script.google.com/macros/s/AKfycby8l_DtCoWgPRJ7-4uxyX4IQjk5UoAD2izt1pBqwFxPcLPHffVG8iMv5Y9KryMfUM8s/exec?p=riwayat';
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

  void _bukaHalamanLaporan(String tipe) {
    DateTime sekarang = DateTime.now();
    List<dynamic> dataTerfilter = [];
    for (var pesanan in _riwayat) {
      String? stringWaktu = pesanan['Waktu'] ?? pesanan['waktu'];
      if (stringWaktu == null || stringWaktu.isEmpty) continue;
      try {
        DateTime? waktuPesanan = DateTime.tryParse(stringWaktu);
        if (waktuPesanan == null) {
          String tanggalSaja = stringWaktu.split(' ')[0];
          if (tanggalSaja.contains('/')) {
            var splitMiring = tanggalSaja.split('/');
            String hari = splitMiring[0].padLeft(2, '0');
            String bulan = splitMiring[1].padLeft(2, '0');
            String tahun = splitMiring[2];
            waktuPesanan = DateTime.tryParse("$tahun-$bulan-$hari");
          }
        }
        if (waktuPesanan == null) continue;
        bool masukKriteria = false;
        if (tipe == 'Harian') {
          masukKriteria = (waktuPesanan.year == sekarang.year && waktuPesanan.month == sekarang.month && waktuPesanan.day == sekarang.day);
        } else if (tipe == 'Bulanan') {
          masukKriteria = (waktuPesanan.year == sekarang.year && waktuPesanan.month == sekarang.month);
        } else if (tipe == 'Tahunan') {
          masukKriteria = (waktuPesanan.year == sekarang.year);
        } else if (tipe == 'Mingguan') {
          int selisihHari = sekarang.difference(waktuPesanan).inDays;
          masukKriteria = (selisihHari >= 0 && selisihHari <= 7);
        }
        if (masukKriteria) dataTerfilter.add(pesanan);
      } catch (e) {
        continue;
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanDetailLaporan(tipeLaporan: tipe, daftarPesanan: dataTerfilter),
      ),
    );
  }

  void _pilihJenisLaporan() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('PILIH PERIODE LAPORAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.today, color: Colors.redAccent),
                title: const Text('Laporan Harian'),
                onTap: () { Navigator.pop(context); _bukaHalamanLaporan('Harian'); },
              ),
              ListTile(
                leading: const Icon(Icons.date_range, color: Colors.orange),
                title: const Text('Laporan Mingguan'),
                onTap: () { Navigator.pop(context); _bukaHalamanLaporan('Mingguan'); },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_view_month, color: Colors.blue),
                title: const Text('Laporan Bulanan'),
                onTap: () { Navigator.pop(context); _bukaHalamanLaporan('Bulanan'); },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.purple),
                title: const Text('Laporan Tahunan'),
                onTap: () { Navigator.pop(context); _bukaHalamanLaporan('Tahunan'); },
              ),
            ],
          ),
        );
      },
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Sistem'),
        content: const Text('Apakah Anda yakin ingin keluar dari halaman admin ini?'),
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
        title: const Text('Dashboard Admin - Riwayat'),
        backgroundColor: const Color.fromARGB(255, 174, 23, 23),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.analytics_outlined), tooltip: 'Laporan Keuangan', onPressed: _pilihJenisLaporan),
          IconButton(icon: const Icon(Icons.logout), tooltip: 'Logout Sistem', onPressed: _logoutDialog),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 174, 23, 23))) 
          : _riwayat.isEmpty 
              ? const Center(child: Text('Belum ada pesanan.')) 
              : ListView.builder(
                  itemCount: _riwayat.length,
                  itemBuilder: (context, index) {
                    final dataPesanan = _riwayat[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanStruk(dataPesanan: dataPesanan)));
                        },
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 174, 23, 23),
                          child: Icon(Icons.receipt_long, color: Colors.white),
                        ),
                        title: Text(dataPesanan['Nama'] ?? dataPesanan['nama'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("Waktu: ${dataPesanan['Waktu'] ?? dataPesanan['waktu'] ?? '-'}"),
                            Text("Meja: ${dataPesanan['Meja'] ?? dataPesanan['meja'] ?? '-'}"),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    );
                  },
                ),
    );
  }
}