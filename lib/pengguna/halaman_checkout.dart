import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HalamanCheckout extends StatefulWidget {
  final List<Map<String, dynamic>> isiKeranjang;
  final String namaPengguna;
  const HalamanCheckout({super.key, required this.isiKeranjang, required this.namaPengguna});

  @override
  State<HalamanCheckout> createState() => _HalamanCheckoutState();
}

class _HalamanCheckoutState extends State<HalamanCheckout> {
  late final TextEditingController _namaController;
  final _mejaController = TextEditingController();
  String _metodeBayar = 'Tunai (Kasir)';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.namaPengguna);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _mejaController.dispose();
    super.dispose();
  }

  final Map<String, String> infoPembayaran = {
    'GoPay': '0812-3456-7890 (Najma Zhafira Nofika)',
    'DANA': '0812-3456-7890 (Najma Zhafira Nofika)',
    'Bank BRI': '1234-01-000123-50-1 (Najma Zhafira Nofika)',
    'Bank BSI': '7123456789 (Najma Zhafira Nofika)',
    'QRIS': 'Silakan scan kode QR di bawah ini'
  };

  // Fungsi pembantu untuk menghitung total belanja agar bisa diakses di kirimPesanan()
  int _hitungTotalKeseluruhan() {
    return widget.isiKeranjang.fold(0, (sum, item) => sum + (item['hargaInt'] as int) * (item['jumlah'] as int));
  }

  Future<void> kirimPesanan() async {
    if (_namaController.text.isEmpty || _mejaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi nama dan meja dulu ya!')));
      return;
    }
    
    setState(() => _isLoading = true);
    const String urlGAS = 'https://script.google.com/macros/s/AKfycbwIQDaiP-5iVaKHuS9vJFS43tEh2Mt1LrrLe3eoS1YPTJUn29lTJohIDaqXIUKduGlB/exec';
    
    try {
      // Format waktu yang lebih rapi untuk lokal Indonesia (DD/MM/YYYY HH:mm)
      String waktuSekarang = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";

      // Ambil nilai total belanja dari fungsi pembantu
      int totalBelanja = _hitungTotalKeseluruhan();

      Map<String, dynamic> data = {
        "action": "tambah_pesanan",
        "nama": _namaController.text.trim(),
        "meja": _mejaController.text.trim(), 
        "waktu": waktuSekarang, 
        "total": totalBelanja, 
        "metode_pembayaran": _metodeBayar, 
        "status": "Pending", 
        "isiKeranjang": widget.isiKeranjang.map((item) => {
          "nama": item['nama'],
          "jumlah": item['jumlah'] 
        }).toList(), // PERBAIKAN: Penutupan map ke list yang benar
      };

      final response = await http.post(
        Uri.parse(urlGAS), 
        body: jsonEncode(data),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 302) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan Berhasil Dikirim!'), backgroundColor: Color.fromARGB(255, 125, 19, 19))
          );
          Navigator.pop(context, true);
        }
      } else {
        throw Exception("Gagal terhubung ke server (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color.fromARGB(255, 174, 23, 23))
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalKeseluruhan = _hitungTotalKeseluruhan();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Rincian Pesanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
          Container(color: Colors.black.withOpacity(0.7)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: Card(
                color: Colors.white.withOpacity(0.9), 
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("DATA PEMESAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 174, 23, 23))),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _namaController, 
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Nama Lengkap', 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _mejaController, 
                        keyboardType: TextInputType.number, 
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.table_restaurant),
                          labelText: 'Nomor Meja', 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                      const Divider(height: 40, thickness: 1.5),
                      const Text("DETAIL MENU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent)),
                      const SizedBox(height: 10),
                      ...widget.isiKeranjang.map((item) {
                        int subTotal = (item['hargaInt'] as int) * (item['jumlah'] as int);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text("${item['nama']} (${item['jumlah']}x)", style: const TextStyle(fontSize: 15)),
                              ),
                              Text("Rp ${subTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(height: 30, thickness: 1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL BAYAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Rp ${totalKeseluruhan.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', 
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _metodeBayar,
                        decoration: InputDecoration(
                          labelText: "Metode Pembayaran",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        items: ['Tunai (Kasir)', 'QRIS', 'GoPay', 'DANA', 'Bank BRI', 'Bank BSI']
                            .map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                        onChanged: (val) => setState(() => _metodeBayar = val!),
                      ),
                      if (_metodeBayar != 'Tunai (Kasir)') ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.redAccent.withOpacity(0.3))
                          ),
                          child: Column(
                            children: [
                              Text("INFO PEMBAYARAN ${_metodeBayar.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.redAccent)),
                              const SizedBox(height: 8),
                              SelectableText(
                                infoPembayaran[_metodeBayar] ?? "",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                              if (_metodeBayar == 'QRIS') ...[
                                const SizedBox(height: 15),
                                Image.network(
                                  'https://cdn.pixabay.com/photo/2023/02/28/01/50/qr-code-7819652_640.jpg',
                                  height: 130, 
                                  width: 130,  
                                  fit: BoxFit.contain,
                                ),
                              ],
                              const SizedBox(height: 10),
                              const Text("*Harap simpan bukti transfer untuk dikonfirmasi", style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 174, 45, 45), 
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                          ),
                          onPressed: _isLoading ? null : kirimPesanan,
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : const Text('KONFIRMASI SEKARANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
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