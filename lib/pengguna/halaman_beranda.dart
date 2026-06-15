import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'halaman_checkout.dart';
import 'package:flutter_application_1/auth/halaman_login.dart';
import 'dart:io';
import 'halaman_history.dart';

class HalamanBeranda extends StatefulWidget {
  final String namaPengguna; 
  const HalamanBeranda({super.key, required this.namaPengguna}); 

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  List<Map<String, dynamic>> keranjang = [];
  Map<String, dynamic> _stokMenu = {}; 

  // Variabel baru untuk menampung data menu dinamis dari Spreadsheet
  List<Map<String, dynamic>> menuMakanan = [];
  List<Map<String, dynamic>> menuMinuman = [];
  List<Map<String, dynamic>> menuDessert = [];
  bool _isLoadingMenu = true; // Status loading saat mengambil data menu

  @override
  void initState() {
    super.initState();
    _fetchMenu(); // Ambil daftar menu dari Spreadsheet
    _fetchStok(); // Ambil data sisa stok
  }
  
  // Fungsi untuk mengambil data menu dan sisa stok sekaligus dari Spreadsheet
  Future<void> _fetchMenu() async {
    const String urlMenu = 'https://script.google.com/macros/s/AKfycby8l_DtCoWgPRJ7-4uxyX4IQjk5UoAD2izt1pBqwFxPcLPHffVG8iMv5Y9KryMfUM8s/exec?p=menu'; 
    
    try {
      final response = await http.get(Uri.parse(urlMenu));
      if (response.statusCode == 200) {
        List<dynamic> dataMentah = jsonDecode(response.body);
        
        List<Map<String, dynamic>> tempMakanan = [];
        List<Map<String, dynamic>> tempMinuman = [];
        List<Map<String, dynamic>> tempDessert = [];
        Map<String, dynamic> tempStok = {};

        for (var item in dataMentah) {
          var hargaRaw = item['harga'];
          String hargaStr = 'Rp 0';
          if (hargaRaw != null) {
            if (hargaRaw is num) {
              String formatRupiah = hargaRaw.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
                (Match m) => '${m[1]}.'
              );
              hargaStr = 'Rp $formatRupiah';
            } else {
              hargaStr = hargaRaw.toString().trim();
              if (hargaStr.isNotEmpty && !hargaStr.startsWith('Rp')) {
                hargaStr = 'Rp $hargaStr';
              }
            }
          }

          Map<String, dynamic> menuFormatted = {
            'nama': item['nama'] ?? '',
            'harga': hargaStr,
            'gambar': item['gambar'] ?? 'https://tse3.mm.bing.net/th/id/OIP.OJ2pGhBzT9FR_Wf66kpsIQHaG1?pid=Api&P=0&h=220',
          };

          String nama = item['nama'] ?? '';
          int stokVal = 0;
          if (item['stok'] != null) {
            if (item['stok'] is num) {
              stokVal = (item['stok'] as num).toInt();
            } else {
              stokVal = int.tryParse(item['stok'].toString()) ?? 0;
            }
          }
          tempStok[nama] = stokVal;

          // Mengonversi string kategori ke huruf kecil semua agar aman dari typo penulisan di Sheet
          String kategori = item['kategori'].toString().toLowerCase().trim();

          if (kategori == 'makanan') {
            tempMakanan.add(menuFormatted);
          } else if (kategori == 'minuman') {
            tempMinuman.add(menuFormatted);
          } else if (kategori == 'dessert') {
            tempDessert.add(menuFormatted);
          }
        }

        setState(() {
          menuMakanan = tempMakanan;
          menuMinuman = tempMinuman;
          menuDessert = tempDessert;
          _stokMenu = tempStok;
          _isLoadingMenu = false;
        });
      }
    } catch (e) {
      print("Error Fetch Menu: $e");
      setState(() {
        _isLoadingMenu = false;
      });
    }
  }
  
  Future<void> _fetchStok() async {
    await _fetchMenu();
  }

  void tambahKeKeranjang(Map<String, dynamic> menu) {
    setState(() {
      int index = keranjang.indexWhere((item) => item['nama'] == menu['nama']);
      if (index != -1) {
        gridKeranjangJumlahTambah(index);
      } else {
        int hargaMurni = int.parse(menu['harga'].replaceAll(RegExp(r'[^0-9]'), ''));
        keranjang.add({
          'nama': menu['nama'],
          'hargaLayar': menu['harga'],
          'hargaInt': hargaMurni,
          'jumlah': 1,
        });
      }
    });
  }

  void gridKeranjangJumlahTambah(int index) {
    keranjang[index]['jumlah']++;
  }

  void kurangiDariKeranjang(String nama) {
    setState(() {
      int index = keranjang.indexWhere((item) => item['nama'] == nama);
      if (index != -1) {
        if (keranjang[index]['jumlah'] > 1) {
          keranjang[index]['jumlah']--;
        } else {
          keranjang.removeAt(index);
        }
      }
    });
  }

  int ambilJumlahItem(String nama) {
    int index = keranjang.indexWhere((item) => item['nama'] == nama);
    return index != -1 ? keranjang[index]['jumlah'] : 0;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color.fromARGB(255, 174, 23, 23)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Color.fromARGB(255, 174, 23, 23))),
                    SizedBox(height: 10),
                    Text('RM Padang Jema', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Beranda'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.lock_open),
                title: const Text('Log Keluar Akun'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanLogin()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Riwayat Pesanan'),
                onTap: () {
                  Navigator.pop(context); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HalamanHistory(namaPengguna: widget.namaPengguna),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
            
        appBar: AppBar(
          title: const Text('Menu Rumah Makan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              tooltip: 'Keluar Aplikasi',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Keluar'),
                    content: const Text('Apakah Anda yakin ingin menutup aplikasi?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('BATAL')),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); 
                          SystemNavigator.pop();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            exit(0); 
                          });
                        }, 
                        child: const Text('YA', style: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Makanan', icon: Icon(Icons.lunch_dining)),
              Tab(text: 'Minuman', icon: Icon(Icons.local_drink)),
              Tab(text: 'Dessert', icon: Icon(Icons.icecream)),
            ],
          ),
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
            Container(color: Colors.black.withOpacity(0.6)),
            Padding(
              padding: const EdgeInsets.only(top: 160),
              // Pengecekan status loading data menu sebelum merender daftar item menu
              child: _isLoadingMenu
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : TabBarView(
                      children: [
                        buildMenuListView(menuMakanan),
                        buildMenuListView(menuMinuman),
                        buildMenuListView(menuDessert),
                      ],
                    ),
            ),
          ],
        ),
        bottomNavigationBar: keranjang.isNotEmpty 
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Text('${keranjang.fold(0, (sum, item) => sum + (item['jumlah'] as int))} Item', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Lihat Pesanan'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                    onPressed: () async {
                      final hasil = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanCheckout(
                            isiKeranjang: keranjang,
                            namaPengguna: widget.namaPengguna,
                          ),
                        ),
                      );
                      if (hasil == true) {
                        setState(() { keranjang.clear(); });
                        _fetchStok();
                      }
                    },
                  ),
                ],
              ),
            )
          : null,
      ),
    );
  }

  Widget buildMenuListView(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "Menu tidak tersedia",
          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemBuilder: (context, index) {
        final menu = data[index];
        final jumlahDipilih = ambilJumlahItem(menu['nama']);
        final sisaStok = _stokMenu[menu['nama']] ?? 0;

        return Card(
          color: Colors.white.withOpacity(0.85),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10), 
              child: Image.network(
                menu['gambar'], 
                width: 65, 
                height: 65, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika URL gambar di sheet salah/rusak
                  return const Icon(Icons.broken_image, size: 65, color: Colors.grey);
                },
              )
            ),
            title: Text(menu['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menu['harga'], style: const TextStyle(color: Color.fromARGB(255, 174, 23, 23), fontWeight: FontWeight.bold)),
                Text("Stok: ${sisaStok.toString()}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: (jumlahDipilih == 0)
                ? IconButton(
                    icon: const Icon(Icons.restaurant, color: Color.fromARGB(255, 174, 23, 23), size: 30),
                    onPressed: () {
                      if (sisaStok > 0) {
                        tambahKeKeranjang(menu);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Stok habis!")));
                      }
                    },
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Color.fromARGB(255, 174, 23, 23), size: 30),
                        onPressed: () => kurangiDariKeranjang(menu['nama']),
                      ),
                      Text('$jumlahDipilih', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Color.fromARGB(255, 174, 23, 23), size: 30),
                        onPressed: () {
                          if (jumlahDipilih < sisaStok) {
                            tambahKeKeranjang(menu);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Stok tidak cukup!")));
                          }
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}