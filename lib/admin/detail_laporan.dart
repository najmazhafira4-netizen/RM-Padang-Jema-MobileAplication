import 'package:flutter/material.dart';

class HalamanDetailLaporan extends StatelessWidget {
  final String tipeLaporan;
  final List<dynamic> daftarPesanan;

  const HalamanDetailLaporan({super.key, required this.tipeLaporan, required this.daftarPesanan});

  String formatRupiah(double nilai) {
    return "Rp ${nilai.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    double totalOmzet = 0;
    for (var pesanan in daftarPesanan) {
      var totalBayar = pesanan['Total'] ?? pesanan['total'] ?? pesanan['Total_Bayar'] ?? 0;
      String bersih = totalBayar.toString().replaceAll(RegExp(r'[^0-9]'), '');
      totalOmzet += double.tryParse(bersih) ?? 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Keuangan $tipeLaporan'),
        backgroundColor: const Color.fromARGB(255, 174, 23, 23),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue[50],
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Transaksi', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('${daftarPesanan.length} Pesanan', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: Colors.green[50],
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Omzet', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(formatRupiah(totalOmzet), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Rincian Riwayat Transaksi Tabel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 174, 23, 23))),
            const SizedBox(height: 10),
            daftarPesanan.isEmpty 
                ? const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(child: Text("Tidak ada transaksi pada periode ini.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))),
                  )
                : Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 240, 240, 240)),
                          columns: const [
                            DataColumn(label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Meja', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Waktu', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: daftarPesanan.map((pesanan) {
                            var totalBayar = pesanan['Total'] ?? pesanan['total'] ?? 0;
                            String bersih = totalBayar.toString().replaceAll(RegExp(r'[^0-9]'), '');
                            double nilaiTotal = double.tryParse(bersih) ?? 0;
                            return DataRow(cells: [
                              DataCell(Text((pesanan['Nama'] ?? pesanan['nama'] ?? '-').toString())),
                              DataCell(Text((pesanan['Meja'] ?? pesanan['meja'] ?? '-').toString())),
                              DataCell(Text((pesanan['Waktu'] ?? pesanan['waktu'] ?? '-').toString())),
                              DataCell(Text(formatRupiah(nilaiTotal), style: const TextStyle(fontWeight: FontWeight.w600))),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}