import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiCafe());
}

class AplikasiCafe extends StatelessWidget {
  const AplikasiCafe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jemas Beauty',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const HalamanAwal(),
    );
  }
}

// --- HALAMAN AWAL (SPLASH/ONBOARDING) ---
class HalamanAwal extends StatelessWidget {
  const HalamanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 161, 174),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.spa, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'JEMAS BEAUTY',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Temukan Kecantikan Anda',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanBeranda()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 164, 30, 84),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Mulai Belanja'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MODEL PRODUK & DATA ---
class Produk {
  final String nama;
  final String deskripsi;
  final int harga;
  final String gambar;

  Produk({required this.nama, required this.deskripsi, required this.harga, required this.gambar});
}

final List<Produk> daftarProduk = [
  Produk(nama: 'Toner Npure Centella', deskripsi: 'Membersihkan dan mengatasi jerawat', harga: 100000, gambar: 'https://npureofficial.id/cdn/shop/files/id-11134207-7r98r-ltm4sq6excat12_800x.jpg?v=1713931174'),
  Produk(nama: 'Serum Vitamin C', deskripsi: 'Kulit cerah dan glowing', harga: 150000, gambar: 'https://via.placeholder.com/150'),
  Produk(nama: 'Moisturizer Hyaluronic', deskripsi: 'Kulit terhidrasi maksimal', harga: 120000, gambar: 'https://via.placeholder.com/150'),
  Produk(nama: 'Sunscreen SPF 50', deskripsi: 'Sun protection ringan', harga: 85000, gambar: 'https://via.placeholder.com/150'),
];

// --- HALAMAN BERANDA ---
class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  List<int> jumlahProduk = List.filled(daftarProduk.length, 0);

  @override
  Widget build(BuildContext context) {
    int totalItem = jumlahProduk.reduce((a, b) => a + b);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Find Your Beauty'),
        backgroundColor: const Color.fromARGB(255, 223, 161, 174),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: daftarProduk.length,
        itemBuilder: (context, index) {
          final produk = daftarProduk[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(produk.gambar, width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 60),
                ),
              ),
              title: Text(produk.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(produk.deskripsi, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text('Rp ${produk.harga}', style: const TextStyle(color: Color.fromARGB(255, 164, 30, 84), fontWeight: FontWeight.bold)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.pink),
                    onPressed: () {
                      if (jumlahProduk[index] > 0) setState(() => jumlahProduk[index]--);
                    },
                  ),
                  Text('${jumlahProduk[index]}'),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.pink),
                    onPressed: () => setState(() => jumlahProduk[index]++),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: totalItem > 0 ? FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanKeranjang(daftarProduk: daftarProduk, jumlahProduk: jumlahProduk))),
        backgroundColor: const Color.fromARGB(255, 164, 30, 84),
        label: Text('Keranjang ($totalItem)', style: const TextStyle(color: Colors.white)),
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
      ) : null,
    );
  }
}

// --- HALAMAN KERANJANG ---
class HalamanKeranjang extends StatelessWidget {
  final List<Produk> daftarProduk;
  final List<int> jumlahProduk;

  const HalamanKeranjang({super.key, required this.daftarProduk, required this.jumlahProduk});

  @override
  Widget build(BuildContext context) {
    int totalHarga = 0;
    for (int i = 0; i < daftarProduk.length; i++) {
      totalHarga += daftarProduk[i].harga * jumlahProduk[i];
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang'), backgroundColor: const Color.fromARGB(255, 164, 30, 84), foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: daftarProduk.length,
              itemBuilder: (context, index) {
                if (jumlahProduk[index] > 0) {
                  return ListTile(
                    title: Text(daftarProduk[index].nama),
                    subtitle: Text('${jumlahProduk[index]} x Rp ${daftarProduk[index].harga}'),
                    trailing: Text('Rp ${daftarProduk[index].harga * jumlahProduk[index]}'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Rp $totalHarga', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 164, 30, 84)),
                    child: const Text('Bayar Sekarang', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}