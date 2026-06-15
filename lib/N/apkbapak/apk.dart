// ==============================================================
// STEP 1: DEKLARASI LIBRARY & ENTRY POINT
// Mengimpor library yang dibutuhkan (UI, navigasi sistem, format JSON, dan HTTP request).
// Fungsi main() adalah titik awal berjalannya aplikasi.
// ==============================================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AplikasiResto());
}

// ==============================================================
// STEP 2: STRUKTUR UTAMA APLIKASI (AplikasiResto)
// Menggunakan StatelessWidget karena ini hanya kerangka dasar.
// MaterialApp mengatur tema, mematikan banner debug, dan menentukan
// layar pertama yang terbuka (home).
// ==============================================================
class AplikasiResto extends StatelessWidget {
  const AplikasiResto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Resto',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HalamanBeranda(),
    );
  }
}

// ==========================================
// HALAMAN 1: BERANDA
// ==========================================
// STEP 3: HALAMAN BERANDA & DATA MAKANAN
// Menggunakan StatefulWidget karena data keranjang bisa bertambah/berubah.
// Di sini kita menyiapkan variabel list kosong untuk keranjang
// dan list statis berisi daftar menu, harga, dan URL gambar.
// ==============================================================
class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  List<Map<String, dynamic>> keranjang = [];

  final List<Map<String, dynamic>> menuMakanan = [
    {
      'nama': 'Rendang Daging',
      'harga': 'Rp 25.000',
      'gambar':
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    },
    {
      'nama': 'Ayam Pop',
      'harga': 'Rp 22.000',
      'gambar':
          'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    },
    {
      'nama': 'Dendeng Batokok',
      'harga': 'Rp 24.000',
      'gambar':
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    },
    {
      'nama': 'Gulai Tunjang Spesial',
      'harga': 'Rp 23.000',
      'gambar':
          'https://images.unsplash.com/photo-1564834724105-918b73d1b9e0?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    },
    {
      'nama': 'Sate Padang',
      'harga': 'Rp 20.000',
      'gambar':
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    },
  ];

  // ==============================================================
  // STEP 4: LOGIKA "TAMBAH KE KERANJANG"
  // Mengecek apakah makanan sudah ada (tambah jumlah) atau belum ada (buat item baru).
  // Juga mengubah harga format teks ("Rp 25.000") menjadi angka murni (25000)
  // serta memunculkan SnackBar (notifikasi bawah) saat berhasil ditambahkan.
  // ==============================================================
  void tambahKeKeranjang(Map<String, dynamic> menu) {
    setState(() {
      int index = keranjang.indexWhere((item) => item['nama'] == menu['nama']);

      if (index != -1) {
        keranjang[index]['jumlah']++;
      } else {
        int hargaMurni = int.parse(
          menu['harga'].replaceAll(RegExp(r'[^0-9]'), ''),
        );
        keranjang.add({
          'nama': menu['nama'],
          'hargaLayar': menu['harga'],
          'hargaInt': hargaMurni,
          'jumlah': 1,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menu['nama']} masuk ke keranjang!'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  // ==============================================================
  // STEP 5: TAMPILAN ANTARMUKA HALAMAN BERANDA (build)
  // Menggambar UI (AppBar, ListView dari data menu, dan Card).
  // Termasuk logika memunculkan tombol Keranjang Mengambang (FAB)
  // yang bisa menghitung jumlah total item dan menavigasi ke halaman checkout.
  // ==============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Menu Restoran'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          // Tombol keluar aplikasi
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => SystemNavigator.pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Menu Pilihan Kami',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: menuMakanan.length,
                itemBuilder: (context, index) {
                  final menu = menuMakanan[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(8.0),
                          ),
                          child: Image.network(
                            menu['gambar'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu['nama'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  menu['harga'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Memanggil fungsi Step 4
                        IconButton(
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.green,
                            size: 30,
                          ),
                          onPressed: () => tambahKeKeranjang(menu),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Tombol Mengambang (Hanya muncul jika keranjang tidak kosong)
      floatingActionButton: keranjang.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.shopping_basket),
              label: Text(
                '${keranjang.fold(0, (sum, item) => sum + (item['jumlah'] as int))} Item',
              ),
              onPressed: () async {
                // Pindah ke Halaman Keranjang
                final hasil = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HalamanKeranjang(isiKeranjang: keranjang),
                  ),
                );

                // Me-refresh status keranjang jika kembali dari halaman checkout
                if (hasil == true) {
                  setState(() {
                    keranjang.clear();
                  });
                } else {
                  setState(() {});
                }
              },
            )
          : null,
    );
  }
}

// ==========================================
// HALAMAN 2: KERANJANG & CHECKOUT
// ==========================================
// STEP 6: HALAMAN KERANJANG & CHECKOUT
// Menerima data pesanan dari beranda. Menyiapkan variabel pengendali
// form (_formKey, _namaController, _mejaController) dan status _isLoading.
// ==============================================================
class HalamanKeranjang extends StatefulWidget {
  final List<Map<String, dynamic>> isiKeranjang;
  const HalamanKeranjang({super.key, required this.isiKeranjang});

  @override
  State<HalamanKeranjang> createState() => _HalamanKeranjangState();
}

class _HalamanKeranjangState extends State<HalamanKeranjang> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _mejaController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Membersihkan memori saat halaman ditutup
    _namaController.dispose();
    _mejaController.dispose();
    super.dispose();
  }

  // ==============================================================
  // STEP 9: PENGIRIMAN DATA KE DATABASE
  // Berjalan saat tombol "PROSES PESANAN" ditekan. Memvalidasi form, 
  // mengaktifkan efek loading, memformat data pesanan menjadi teks gabungan,
  // dan mengirimkannya via HTTP POST ke Google Apps Script. 
  // ==============================================================
  Future<void> kirimPesananKeDatabase() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      const String urlGAS =
          'https://script.google.com/macros/s/AKfycbzL_99vC-1TMLcp_1WLeAIrcqSXtscU4V9cLhKw64NS7doekUZmWnOz5jyLnBa460QU/exec';

      try {
        String teksMenuGabungan = widget.isiKeranjang
            .map((item) => "${item['jumlah']}x ${item['nama']}")
            .join(", ");

        Map<String, dynamic> dataPesanan = {
          "nama": _namaController.text,
          "meja": _mejaController.text,
          "menu": teksMenuGabungan,
        };

        final response = await http.post(
          Uri.parse(urlGAS),
          body: jsonEncode(dataPesanan),
        );

        if (response.statusCode == 200 || response.statusCode == 302) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pesanan berhasil dikirim ke Dapur!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Sukses, kembali & reset keranjang
          }
        } else {
          throw Exception('Gagal. Status: ${response.statusCode}');
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terjadi Kesalahan: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Matikan animasi putar
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ==============================================================
    // STEP 7 (Bagian A): KALKULASI TOTAL HARGA
    // Menghitung total harga sebelum digambar di layar
    // ==============================================================
    int totalHarga = widget.isiKeranjang.fold(
      0,
      (sum, item) => sum + (item['hargaInt'] as int) * (item['jumlah'] as int),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Keranjang Pesanan'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Belanja',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // ==============================================================
              // STEP 7 (Bagian B): DAFTAR ITEM & TOMBOL HAPUS
              // Menampilkan daftar pesanan menggunakan ListView.separated.
              // Tombol Delete akan menghapus item spesifik dan otomatis menutup
              // halaman ini jika keranjang menjadi kosong.
              // ==============================================================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.isiKeranjang.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = widget.isiKeranjang[index];
                    int subTotal =
                        (item['hargaInt'] as int) * (item['jumlah'] as int);
                    return ListTile(
                      title: Text(
                        item['nama'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text('${item['jumlah']}x ${item['hargaLayar']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Rp $subTotal',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Logika Pintar Menghapus Item
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.isiKeranjang.removeAt(index);
                                if (widget.isiKeranjang.isEmpty) {
                                  Navigator.pop(context, false);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Menampilkan total harga
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL TAGIHAN:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp $totalHarga',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                'Data Pemesan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // ==============================================================
              // STEP 8: FORM DATA PEMESAN (Form)
              // Membungkus input text agar bisa divalidasi massal.
              // Terdapat validasi isEmpty untuk nama dan angka valid untuk meja.
              // ==============================================================
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Pemesan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama wajib diisi!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mejaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Meja',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.table_restaurant),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor meja wajib diisi!';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Harus berupa angka!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // ==============================================================
                    // BAGIAN DARI STEP 9 (Eksekusi Pengiriman)
                    // Tombol untuk memanggil fungsi kirimPesananKeDatabase.
                    // Menampilkan indikator loading jika status _isLoading bernilai true.
                    // ==============================================================
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoading ? null : kirimPesananKeDatabase,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'PROSES PESANAN SEKARANG',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
