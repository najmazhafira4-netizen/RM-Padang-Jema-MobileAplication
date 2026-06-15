import 'package:flutter/material.dart';

class HalamanStruk extends StatelessWidget {
  final Map<String, dynamic> dataPesanan;
  const HalamanStruk({super.key, required this.dataPesanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Nota Rincian Struk"),
        backgroundColor: const Color.fromARGB(255, 174, 23, 23),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text("RM PADANG JEMA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 174, 23, 23))),
                      const Text("Struk Bukti Pemesanan Makanan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const Divider(height: 30),
                      _itemStruk("Nama Pelanggan", "${dataPesanan['Nama'] ?? dataPesanan['nama'] ?? '-'}"),
                      _itemStruk("Nomor Meja", "${dataPesanan['Meja'] ?? dataPesanan['meja'] ?? '-'}"),
                      _itemStruk("Waktu Transaksi", "${dataPesanan['Waktu'] ?? dataPesanan['waktu'] ?? '-'}"),
                      _itemStruk("Total Pembayaran", "${dataPesanan['Total'] ?? dataPesanan['total'] ?? '-'}"),
                      _itemStruk("Metode Bayar", "${dataPesanan['Pembayaran'] ?? dataPesanan['pembayaran'] ?? 'Tidak Ada'}"),
                      const Divider(height: 30),
                      const Align(alignment: Alignment.centerLeft, child: Text("Menu Dipesan:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[300]!)),
                        child: Text("${dataPesanan['Menu'] ?? dataPesanan['menu'] ?? 'Tidak ada detail menu'}", style: const TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("KEMBALI KE LIST"),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 174, 23, 23), foregroundColor: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemStruk(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(width: 20),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}