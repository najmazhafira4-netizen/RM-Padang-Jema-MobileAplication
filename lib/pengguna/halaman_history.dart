import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HalamanHistory extends StatefulWidget {
  // Variabel untuk menampung nama akun yang sedang aktif
  final String namaPengguna; 

  const HalamanHistory({super.key, required this.namaPengguna});

  @override
  State<HalamanHistory> createState() => _HalamanHistoryState();
}

class _HalamanHistoryState extends State<HalamanHistory> {
  // URL Web App Google Apps Script Anda (Sesuaikan dengan URL Deployment Anda)
  final String urlGoogleScript = 'https://script.google.com/macros/s/AKfycby8l_DtCoWgPRJ7-4uxyX4IQjk5UoAD2izt1pBqwFxPcLPHffVG8iMv5Y9KryMfUM8s/exec';
  
  List<dynamic> _listRiwayat = [];
  bool _isLoading = true;
  String _pesanError = '';

  @override
  void initState() {
    super.initState();
    _ambilDataRiwayat();
  }

  // Fungsi untuk mengambil data riwayat berdasarkan nama akun
  Future<void> _ambilDataRiwayat() async {
    setState(() {
      _isLoading = true;
      _pesanError = '';
    });

    try {
      // Mengirim request GET dengan parameter action dan nama khusus akun tersebut
      final String urlLengkap = "$urlGoogleScript?action=ambilRiwayat&nama=${Uri.encodeComponent(widget.namaPengguna)}";
      final response = await http.get(Uri.parse(urlLengkap));

      if (response.statusCode == 200 || response.statusCode == 302) {
        final data = jsonDecode(response.body);
        setState(() {
          _listRiwayat = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _pesanError = 'Gagal memuat data dari server (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _pesanError = 'Terjadi kesalahan jaringan: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat: ${widget.namaPengguna}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 174, 23, 23),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _ambilDataRiwayat,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 174, 23, 23)))
          : _pesanError.isNotEmpty
              ? Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(_pesanError, style: const TextStyle(color: Colors.red, fontSize: 15), textAlign: TextAlign.center)))
              : _listRiwayat.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in_outlined, size: 70, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text('Halo ${widget.namaPengguna},\nAnda belum memiliki riwayat pesanan.', 
                            style: const TextStyle(color: Colors.grey, fontSize: 14), 
                            textAlign: TextAlign.center
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _listRiwayat.length,
                      itemBuilder: (context, index) {
                        final pesanan = _listRiwayat[index];
                        
                        // Format mata uang sederhana ke Rupiah lokal
                        int totalHarga = pesanan['total'] ?? 0;
                        String formatRupiah = totalHarga.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
                          (Match m) => '${m[1]}.'
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(pesanan['waktu'] ?? '-', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        pesanan['pembayaran'] ?? '-',
                                        style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                Row(
                                  children: [
                                    const Icon(Icons.table_restaurant_outlined, size: 18, color: Colors.redAccent),
                                    const SizedBox(width: 8),
                                    Text('Nomor Meja: ${pesanan['meja']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.restaurant_menu, size: 18, color: Colors.amber),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        pesanan['menu'] ?? '-',
                                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Pembayaran:', style: TextStyle(fontSize: 13, color: Colors.black54)),
                                    Text(
                                      'Rp $formatRupiah',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 174, 23, 23)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}