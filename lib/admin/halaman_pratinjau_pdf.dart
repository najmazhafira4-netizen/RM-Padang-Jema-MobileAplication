import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HalamanPratinjauPdf extends StatelessWidget {
  final String tipeLaporan;
  final List<dynamic> daftarPesanan;

  const HalamanPratinjauPdf({
    super.key,
    required this.tipeLaporan,
    required this.daftarPesanan,
  });

  String _formatRupiah(double nilai) {
    return "Rp ${nilai.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    // Hitung total omzet
    double totalOmzet = 0;
    for (var pesanan in daftarPesanan) {
      var totalBayar = pesanan['Total'] ?? pesanan['total'] ?? pesanan['total_harga'] ?? 0;
      String bersih = totalBayar.toString().replaceAll(RegExp(r'[^0-9]'), '');
      totalOmzet += double.tryParse(bersih) ?? 0;
    }

    // Warna brand aplikasi (Merah RM Padang Jema)
    final brandColor = PdfColor.fromInt(0xffAE1717);
    final secondaryColor = PdfColor.fromInt(0xff333333);
    final lightGrey = PdfColor.fromInt(0xffF5F5F5);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4, // Potrait Orientation
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return [
            // HEADER Restoran
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "RM PADANG JEMA",
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: brandColor,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      "Masakan Minang Asli & Higienis",
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      "Laporan Keuangan Periode: $tipeLaporan",
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Dicetak pada:",
                      style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                    ),
                    pw.Text(
                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(thickness: 1.5, color: brandColor),
            pw.SizedBox(height: 12),

            // RINGKASAN KARTU (Summary Cards)
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: lightGrey,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "TOTAL TRANSAKSI",
                          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          "${daftarPesanan.length} Pesanan",
                          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: brandColor),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: lightGrey,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "TOTAL OMZET KEUANGAN",
                          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          _formatRupiah(totalOmzet),
                          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            // TABEL RINCIAN TRANSAKSI (Skema Database disesuaikan dengan Portrait)
            pw.Text(
              "RINCIAN TRANSAKSI PENJUALAN",
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: brandColor),
            ),
            pw.SizedBox(height: 6),

            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 7.5,
              ),
              cellStyle: const pw.TextStyle(
                fontSize: 6.5,
              ),
              headerDecoration: pw.BoxDecoration(
                color: brandColor,
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                ),
              ),
              cellAlignment: pw.Alignment.centerLeft,
              columnWidths: const {
                0: pw.FixedColumnWidth(30),  // ID
                1: pw.FixedColumnWidth(65),  // Pelanggan
                2: pw.FixedColumnWidth(22),  // Meja
                3: pw.FixedColumnWidth(60),  // Waktu
                4: pw.FlexColumnWidth(2.5),  // Detail Menu (Lebar dinamis)
                5: pw.FixedColumnWidth(55),  // Total
                6: pw.FixedColumnWidth(50),  // Bayar
                7: pw.FixedColumnWidth(40),  // Status
              },
              headers: [
                "ID",
                "Pelanggan",
                "Meja",
                "Waktu",
                "Detail Menu",
                "Total",
                "Bayar",
                "Status"
              ],
              data: List<List<String>>.generate(
                daftarPesanan.length,
                (index) {
                  final order = daftarPesanan[index];
                  double valTotal = 0;
                  var tVal = order['Total'] ?? order['total'] ?? order['total_harga'] ?? 0;
                  valTotal = double.tryParse(tVal.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

                  return [
                    (order['id_pesanan'] ?? order['id'] ?? '-').toString(),
                    (order['Nama'] ?? order['nama'] ?? order['nama_pelanggan'] ?? 'Tanpa Nama').toString(),
                    (order['Meja'] ?? order['meja'] ?? '-').toString(),
                    (order['Waktu'] ?? order['waktu'] ?? '-').toString(),
                    (order['Menu'] ?? order['menu'] ?? order['detail_pesanan'] ?? '-').toString(),
                    _formatRupiah(valTotal),
                    (order['Pembayaran'] ?? order['pembayaran'] ?? order['metode_pembayaran'] ?? '-').toString(),
                    (order['Status'] ?? order['status'] ?? '-').toString(),
                  ];
                },
              ),
            ),
            pw.SizedBox(height: 20),

            // TANDA TANGAN (Sign-off)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      "Verifikasi Laporan,",
                      style: pw.TextStyle(fontSize: 8, color: secondaryColor),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Text(
                      "Admin RM Padang Jema",
                      style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: secondaryColor),
                    ),
                    pw.Container(
                      width: 100,
                      height: 0.5,
                      color: PdfColors.grey500,
                      margin: const pw.EdgeInsets.symmetric(vertical: 2),
                    ),
                    pw.Text(
                      "Sistem Keuangan Otomatis",
                      style: pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cetak Laporan $tipeLaporan"),
        backgroundColor: const Color.fromARGB(255, 174, 23, 23),
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
        allowPrinting: true,
        allowSharing: false, // Menghilangkan tombol sharing/download eksternal
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false, // Menghilangkan tombol debug layout (klick kanan/gears) di sisi kanan
        pdfFileName: "Laporan_${tipeLaporan}_${DateTime.now().millisecondsSinceEpoch}.pdf",
      ),
    );
  }
}
