import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 

void main() {
  runApp(const AplikasiRumahMakanPadang());
}

class AplikasiRumahMakanPadang extends StatelessWidget {
  const AplikasiRumahMakanPadang({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Rumah Makan Padang',
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const HalamanSampul(),
    );
  }
}

// ==========================================
// HALAMAN 0: SAMPUL (WELCOME SCREEN)
// ==========================================
class HalamanSampul extends StatelessWidget {
  const HalamanSampul({super.key});

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
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SELAMAT DATANG DI\nRM PADANG JEMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HalamanBeranda()),
                    );
                  },
                  child: const Text('MAU PESAN SEKARANG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// HALAMAN 1: BERANDA
// ==========================================
class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  List<Map<String, dynamic>> keranjang = [];
  Map<String, dynamic> _stokMenu = {}; 

  final List<Map<String, dynamic>> menuMakanan = [
    {'nama': 'Nasi Putih', 'harga': 'Rp 5.000', 'gambar': 'https://tse3.mm.bing.net/th/id/OIP.OJ2pGhBzT9FR_Wf66kpsIQHaG1?pid=Api&P=0&h=220'},
    {'nama': 'Rendang Daging', 'harga': 'Rp 25.000', 'gambar': 'https://api.meatguy.id/admin/image/blogs/711dcbdb-4451-409d-b916-ed525bc23954'},
    {'nama': 'Kalio Daging', 'harga': 'Rp 22.000', 'gambar': 'https://i1.wp.com/resepkoki.id/wp-content/uploads/2020/02/Resep-Kalio-Daging.jpg?fit=1838%2C1906&ssl=1'},
    {'nama': 'Dendeng Batokok Cabe Hijau', 'harga': 'Rp 24.000', 'gambar': 'https://akcdn.detik.net.id/visual/2020/03/05/871d3687-349d-43ff-9737-ae04ef9abe57_169.jpeg?w=428&q=90'},
    {'nama': 'Dendeng Batokok Cabe Merah', 'harga': 'Rp 24.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/07/02/4086094382.jpg'},
    {'nama': 'Sate Padang', 'harga': 'Rp 20.000', 'gambar': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'},
    {'nama': 'Rendang Ayam', 'harga': 'Rp 25.000', 'gambar': 'https://1.bp.blogspot.com/-EoK1S3YHppg/XI3-j8Cq5lI/AAAAAAAAABQ/28N1d-kY8sgWRALbM1O6edXzmvZVBWLGQCLcBGAs/s1600/rendang_ayam.jpg'},
    {'nama': 'Ayam Kurma', 'harga': 'Rp 25.000', 'gambar': 'https://2.bp.blogspot.com/-R3TuyGIEG8k/WS6wgYuW5tI/AAAAAAAAQbo/dA1XbmXxK2op-s36T3BbaVbX2O5TL_QlwCLcB/s1600/IMG_7612.1.JPG'},
    {'nama': 'Opor Ayam', 'harga': 'Rp 22.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/x/photo/2022/04/28/2090476305.jpeg'},
    {'nama': 'Ayam Kecap', 'harga': 'Rp 20.000', 'gambar': 'https://i1.wp.com/resepkoki.id/wp-content/uploads/2017/01/Resep-Ayam-Goreng-Kecap.jpg?fit=1920%2C1865&ssl=1'},
    {'nama': 'Ayam Goreng Cabe Merah', 'harga': 'Rp 20.000', 'gambar': 'https://i.ytimg.com/vi/lG8ByF8cQl4/maxresdefault.jpg'},
    {'nama': 'Ayam Pop', 'harga': 'Rp 26.000', 'gambar': 'https://3.bp.blogspot.com/-yQt2zQJTkrw/VZAFY9HtCnI/AAAAAAAAH5c/jJD6cm-YzOY/s1600/ayam%2Bpop.jpg'},
    {'nama': 'Ayam Goreng Bawang Putih', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/703x0/webp/photo/2024/08/06/2040093833.png'},
    {'nama': 'Gulai Ayam', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/1200x675/photo/2025/01/08/189283282.png'},
    {'nama': 'Kalio Ayam', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/188x97:1118x620/703x0/webp/photo/2024/07/26/2670157318.jpg'},
    {'nama': 'Ayam Cabe Hijau', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/03/29/3713652780.jpeg'},
    {'nama': 'Ayam Bakar', 'harga': 'Rp 25.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/08/31/990639215.jpg'},
    {'nama': 'Ayam Bumbu Goreng', 'harga': 'Rp 25.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/12/06/762061582.png'},
    {'nama': 'Rendang Telur', 'harga': 'Rp 18.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/132x89:1156x665/720x0/webp/photo/2025/01/11/777921618.jpg'},
    {'nama': 'Telur Barendo', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/219x119:1065x595/720x0/webp/photo/2025/01/28/475820457.jpg'},
    {'nama': 'Gulai Ikan', 'harga': 'Rp 25.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/01/24/1795834145.jpg'},
    {'nama': 'Ikan Bakar', 'harga': 'Rp 23.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/462x49:1250x512/720x0/webp/photo/2025/03/27/133163464.jpg'},
    {'nama': 'Lele Goreng Sambal Santan', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/09/13/783075428.jpg'},
    {'nama': 'Gulai Cincang', 'harga': 'Rp 25.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/06/07/1083893.jpg'},
    {'nama': 'Paru Cabe Hijau', 'harga': 'Rp 25.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2022/07/13/2756886439.jpg'},
    {'nama': 'Gulai Tambusu', 'harga': 'Rp 25.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2022/06/16/2159940365.jpg'},
    {'nama': 'Gulai Kikil', 'harga': 'Rp 24.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2021/04/27/2909867931.jpg'},
    {'nama': 'Sambalado Tanak', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/11/21/3899340847.jpg'},
    {'nama': 'Gulai Jengkol', 'harga': 'Rp 17.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/07/22/600285258.png'},
    {'nama': 'Sambalado Jengkol', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/128x72:1152x648/720x0/webp/photo/2024/09/18/3522349429.jpg'},
    {'nama': 'Udang Balado', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/10/28/2543992276.png'},
    {'nama': 'Cumi Hitam', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/10/28/3172154435.jpg'},
    {'nama': 'Gulai Nangka', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/07/17/1917386004.png'},
    {'nama': 'Gulai Daun Singkong', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/559x133:1279x576/720x0/webp/photo/2026/02/19/2637894161.jpg'},
    {'nama': 'Gulai Pakis', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/226x308:728x775/720x0/webp/photo/2022/03/02/3683945499.png'},
    {'nama': 'Sup Daging', 'harga': 'Rp 25.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/69x78:804x536/720x0/webp/photo/2025/08/01/110566766.png'},
    {'nama': 'Sup Ayam', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/06/23/859681341.jpg'},
    {'nama': 'Nasi Goreng Cabe Hijau', 'harga': 'Rp 25.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/332x56:982x419/720x0/webp/photo/2024/10/14/3055391563.jpg'},
  ];

  final List<Map<String, dynamic>> menuMinuman = [
    {'nama': 'Teh Talua', 'harga': 'Rp 12.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/x/photo/2024/01/16/516644067.jpg'},
    {'nama': 'Es Jeruk', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/06/20/2209205825.jpg'},
    {'nama': 'Jus Alpukat', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/04/14/2068146317.jpg'},
    {'nama': 'Es Teh Manis', 'harga': 'Rp 5.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/10/22/3604818908.jpg'},
    {'nama': 'Jus Naga', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/300x362:953x1052/720x0/webp/photo/2025/04/09/2103472169.jpg'},
    {'nama': 'Jus Tomat', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2020/03/30/4248124589.jpg'},
    {'nama': 'Jus Mangga', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2022/05/07/747637637.jpg'},
    {'nama': 'Jus Pisang', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2022/05/31/1952605336.jpg'},
    {'nama': 'Jus Sirsak', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/07/20/2385864692.jpg'},
    {'nama': 'Lemon Tea', 'harga': 'Rp 5.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/02/22/218571680.png'},
    {'nama': 'Kopi Hitam', 'harga': 'Rp 5.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2024/09/01/3181429665.jpg'},
    {'nama': 'Kopi Susu', 'harga': 'Rp 6.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2026/02/16/3690655848.png'},
    {'nama': 'Susu', 'harga': 'Rp 8.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2021/05/31/2558549240.png'},
    {'nama': 'Boba Milk Tea', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/08/08/1561665625.jpg'},
    {'nama': 'Thai Tea', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2020/09/12/3918509625.jpg'},
    {'nama': 'Teh Tarik', 'harga': 'Rp 8.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2022/06/10/98377070.jpg'},
    {'nama': 'Matcha Latte', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/73x53:1033x593/720x0/webp/photo/2026/04/26/354505903.jpg'},
    {'nama': 'Fanta Susu', 'harga': 'Rp 8.000', 'gambar': 'https://1.bp.blogspot.com/-g64VgO3CFTY/XdTabRBDKmI/AAAAAAAAFMw/ZnJvp1exa2UbwP0vCGG_g_jfa_jTPYznACLcBGAsYHQ/s1600/Cara-Membuat-Es-Soda-Gembira_41_20180228172400.jpg'},
    {'nama': 'Extrajoss Susu', 'harga': 'Rp 8.000', 'gambar': 'https://cf.shopee.co.id/file/id-11134207-8224s-mgzq32qw1vyh4e'},
    {'nama': 'Milo', 'harga': 'Rp 9.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2021/12/15/527216156.jpg'},
  ];

  final List<Map<String, dynamic>> menuDessert = [
    {'nama': 'Es Tebak', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/02/20/2486348497.png'},
    {'nama': 'Es Cendol', 'harga': 'Rp 18.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/03/16/2244782273.jpg'},
    {'nama': 'Bubur Kampiun', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/05/25/3887249853.jpg'},
    {'nama': 'Bubur Sumsum', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/317x568:983x1025/720x0/webp/photo/2024/10/24/2169815216.jpg'},
    {'nama': 'Kolak Pisang', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/202x6:998x669/720x0/webp/photo/2024/08/13/1024812040.jpg'},
    {'nama': 'Serabi Kuah', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/05/28/1263369480.jpg'},
    {'nama': 'Klepon', 'harga': 'Rp 10.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/1200x675/webp/photo/2024/06/16/1633124760.jpg'},
    {'nama': 'Lamang Tapai', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2021/01/21/420979875.png'},
    {'nama': 'Pinyaram', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/177x135:1137x675/720x0/webp/photo/2023/10/27/2977105551.jpg'},
    {'nama': 'Cheese Cake', 'harga': 'Rp 20.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/02/22/413169463.jpg'},
    {'nama': 'Puding Caramel', 'harga': 'Rp 15.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/179x145:1109x668/720x0/webp/photo/2024/07/12/2766901676.jpg'},
    {'nama': 'Waffle', 'harga': 'Rp 18.000', 'gambar': 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2023/03/14/1937683218.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchStok();
  }

  Future<void> _fetchStok() async {
  // PASTIKAN INI ADALAH URL DARI SHEET "STOK"
  const String urlGAS = 'https://script.google.com/macros/s/AKfycbxb2xMPdUAhcOXOxVOUs-kA85x82a30TFovz_vVn8K_dcAw8Lfj9cUstEapgt6vbh4i/exec'; 

  try {
    final response = await http.get(Uri.parse(urlGAS));
    if (response.statusCode == 200) {
      setState(() {
        _stokMenu = jsonDecode(response.body);
      });
      print("Stok berhasil diperbarui: $_stokMenu");
    }
  } catch (e) {
    print("Gagal mengambil stok: $e");
  }
}

  void tambahKeKeranjang(Map<String, dynamic> menu) {
    setState(() {
      int index = keranjang.indexWhere((item) => item['nama'] == menu['nama']);
      if (index != -1) {
        keranjang[index]['jumlah']++;
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
                leading: const Icon(Icons.history),
                title: const Text('Riwayat Pesanan'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanRiwayat()));
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
                    content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('BATAL')),
                      TextButton(onPressed: () => SystemNavigator.pop(), child: const Text('YA', style: TextStyle(color: Colors.red))),
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
              child: TabBarView(
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
                        MaterialPageRoute(builder: (context) => HalamanCheckout(isiKeranjang: keranjang)),
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
    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemBuilder: (context, index) {
        final menu = data[index];
        final jumlahDipilih = ambilJumlahItem(menu['nama']);
        final sisaStok = _stokMenu[menu['nama_menu']] ?? 0;

        return Card(
          color: Colors.white.withOpacity(0.85),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10), 
              child: Image.network(menu['gambar'], width: 65, height: 65, fit: BoxFit.cover)
            ),
            title: Text(menu['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menu['harga'], style: const TextStyle(color: Color.fromARGB(255, 174, 23, 23), fontWeight: FontWeight.bold)),
                // PERBAIKAN: Stok dipaksa jadi string agar tidak error "int is not subtype of String"
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

// ==========================================
// HALAMAN 3: RIWAYAT PESANAN (VERSI PERBAIKAN)
// ==========================================
class HalamanRiwayat extends StatefulWidget {
  const HalamanRiwayat({super.key});

  @override
  State<HalamanRiwayat> createState() => _HalamanRiwayatState();
}

class _HalamanRiwayatState extends State<HalamanRiwayat> {
  List<dynamic> _riwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    const String urlGAS = 'https://script.google.com/macros/s/AKfycbyLMxGDGkSJLQYnG6Aye4obBrC-tHvA-5T8SVdc-7ZqcPfztv5zK9bx3aLxHmLjMpY_6Q/exec';
    try {
      final response = await http.get(Uri.parse(urlGAS));
      if (response.statusCode == 200) {
        setState(() {
          _riwayat = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: const Color.fromARGB(255, 174, 23, 23),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 174, 23, 23)))
          : _riwayat.isEmpty
              ? const Center(child: Text('Belum ada pesanan.'))
              : ListView.builder(
  itemCount: _riwayat.length,
  itemBuilder: (context, index) {
    // Ambil data satu per satu berdasarkan index
    final dataPesanan = _riwayat[index]; 
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
          // Pastikan mengirim 'dataPesanan' ke HalamanStruk
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanStruk(dataPesanan: dataPesanan),
            ),
          );
        },
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 174, 23, 23),
          child: Icon(Icons.receipt, color: Colors.white),
        ),
        title: Text(dataPesanan['Nama'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Waktu: ${dataPesanan['waktu'] ?? '-'}\nMeja: ${dataPesanan['Meja']}"),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  },
)
    );
  }
}

// ==========================================
// HALAMAN 4: STRUK (PASTIKAN PAKAI KODE INI)
// ==========================================
class HalamanStruk extends StatelessWidget {
  final dynamic dataPesanan; // Menggunakan dynamic agar lebih fleksibel menerima data

  const HalamanStruk({super.key, required this.dataPesanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Struk Transaksi'),
        backgroundColor: const Color.fromARGB(255, 174, 23, 23),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 60),
                    const SizedBox(height: 10),
                    const Text("TRANSAKSI BERHASIL", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Divider(height: 30),
                    
                    // Memanggil data dengan pengecekan null
                    _itemStruk("Nama Pemesan", "${dataPesanan['nama'] ?? 'Tidak Ada'}"),
                    _itemStruk("Nomor Meja", "${dataPesanan['meja'] ?? 'Tidak Ada'}"),
                    _itemStruk("Waktu", "${dataPesanan['waktu'] ?? 'Tidak Ada'}"),
                    _itemStruk("Metode Bayar", "${dataPesanan['pembayaran'] ?? 'Tidak Ada'}"),
                    
                    const Divider(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Menu Dipesan:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${dataPesanan['menu'] ?? 'Tidak ada detail menu'}", 
                        style: const TextStyle(fontSize: 15)
                      ),
                    ),
                    const Divider(height: 30),
                    const Text(
                      "Terima kasih sudah memesan di\nRM Padang Jema", 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("KEMBALI KE RIWAYAT"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 174, 23, 23),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
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
          // Gunakan Expanded agar teks panjang tidak error/potong
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }
}

// HALAMAN 2: CHECKOUT & KIRIM DATA
// ==========================================
class HalamanCheckout extends StatefulWidget {
  final List<Map<String, dynamic>> isiKeranjang;
  const HalamanCheckout({super.key, required this.isiKeranjang});

  @override
  State<HalamanCheckout> createState() => _HalamanCheckoutState();
}

class _HalamanCheckoutState extends State<HalamanCheckout> {
  final _namaController = TextEditingController();
  final _mejaController = TextEditingController();
  String _metodeBayar = 'Tunai (Kasir)';
  bool _isLoading = false;

  final Map<String, String> infoPembayaran = {
    'GoPay': '0812-3456-7890 (Najma Zhafira Nofika)',
    'DANA': '0812-3456-7890 (Najma Zhafira Nofika)',
    'Bank BRI': '1234-01-000123-50-1 (Najma Zhafira Nofika)',
    'Bank BSI': '7123456789 (Najma Zhafira Nofika)',
    'QRIS': 'Silakan scan kode QR di bawah ini'
  };

  Future<void> kirimPesanan() async {
    if (_namaController.text.isEmpty || _mejaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi nama dan meja dulu ya!')));
      return;
    }
    
    setState(() => _isLoading = true);
    
    const String urlGAS = 'https://script.google.com/macros/s/AKfycbyLMxGDGkSJLQYnG6Aye4obBrC-tHvA-5T8SVdc-7ZqcPfztv5zK9bx3aLxHmLjMpY_6Q/exec';
    
    try {
    String teksMenu = widget.isiKeranjang.map((i) => "${i['jumlah']}x ${i['nama']}").join(", ");
    
    // TAMBAHKAN VARIABEL WAKTU DI SINI
    String waktuSekarang = DateTime.now().toString().split('.')[0]; // Format: YYYY-MM-DD HH:MM:SS

    Map<String, dynamic> data = {
      "nama": _namaController.text,
      "meja": _mejaController.text,
      "menu": teksMenu,
      "pembayaran": _metodeBayar,
      "waktu": waktuSekarang // Mengirimkan keterangan waktu
    };

      final response = await http.post(
        Uri.parse(urlGAS), 
        body: jsonEncode(data)
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan Berhasil Dikirim!'), backgroundColor: Color.fromARGB(255, 125, 19, 19))
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Color.fromARGB(255, 174, 23, 23))
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalKeseluruhan = widget.isiKeranjang.fold(0, (sum, item) => sum + (item['hargaInt'] as int) * (item['jumlah'] as int));

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
                                child: Text("${item['nama']} (${item['jumlah']}x)", 
                                  style: const TextStyle(fontSize: 15)),
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
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.redAccent.withOpacity(0.3))
                          ),
                          child: Column(
                            children: [
                              Text("INFO PEMBAYARAN ${_metodeBayar.toUpperCase()}", 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.redAccent)),
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
                              const Text("*Harap simpan bukti transfer untuk dikonfirmasi", 
                                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
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