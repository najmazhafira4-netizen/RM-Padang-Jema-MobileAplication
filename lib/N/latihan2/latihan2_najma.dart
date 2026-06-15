import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiBeauty());
}

class AplikasiBeauty extends StatelessWidget {
  const AplikasiBeauty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jemas Beauty',
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
            const Icon(
              Icons.spa,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'JEMAS BEAUTY',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Temukan Kecantikan Anda',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HalamanBeranda(),
                  ),
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

// --- LIST PRODUK ---
class Produk {
  final String nama;
  final String deskripsi;
  final int harga;
  final String gambar;

  Produk({
    required this.nama, 
    required this.deskripsi, 
    required this.harga, 
    required this.gambar
  });
}

final List<Produk> daftarProduk = [
  Produk(
    nama: 'Toner Npure Centella',
    deskripsi: 'NPURE Centella Asiatica Face Toner dengan niacinamide untuk membersihkan, mencerahkan, dan mengatasi jerawat',
    harga: 100000,
    gambar: 'https://npureofficial.id/cdn/shop/files/150_ml_SKU_-_CICA_TONER-01_1024x.jpg?v=1721188319'
  ),
  Produk(
    nama: 'Serum Hanasui Vitamin C',
    deskripsi: 'Serum brightening dengan Vitamin C untuk kulit cerah dan glowing',
    harga: 25000,
    gambar: 'https://down-id.img.susercontent.com/file/f4e7bffcf53c948336ebdae3098e1692'
  ),
  Produk(
    nama: 'Moisturizer Facetology 5%, 10%, dan B5',
    deskripsi: 'Pelembab dengan hyaluronic acid untuk kulit terhidrasi',
    harga: 49000,
    gambar: 'https://down-my.img.susercontent.com/file/id-11134207-8224s-mh8liiu4aryjf1'
  ),
  Produk(
    nama: 'Sunscreen Wardah Acne Calm spf 35+++',
    deskripsi: 'Sun protection dengan tekstur ringan untuk kulit wajah',
    harga: 35000,
    gambar: 'https://medias.watsons.co.id/publishing/WTCID-40890-front-zoom.jpg?version=1752505907'
  ),
  Produk(
    nama: 'Face Wash Hadalabo',
    deskripsi: 'Pembersih wajah lembut untuk kulit sensitif',
    harga: 45000,
    gambar: 'https://down-id.img.susercontent.com/file/id-11134207-7rasc-m2py6en6quu87c'
  ),
  Produk(
    nama: 'Eye Cream serum skintific',
    deskripsi: 'Krim mata untuk mengurangi lingkaran hitam dan kerutan',
    harga: 98000,
    gambar: 'https://down-id.img.susercontent.com/file/id-11134207-7r991-lwl4yr970x0u17'
  ),
  Produk(
    nama: 'Sheet Mask Bioaqua',
    deskripsi: 'Sheet mask untuk kulit lembut dan bersinar',
    harga: 5000,
    gambar: 'https://cf.shopee.co.id/file/f854b162e9d25cc1b7fb024b8c90cb2c'
  ),
  Produk(
    nama: 'Lip Balm Pure Paw Paw',
    deskripsi: 'Pelembab bibir dengan vitamin E',
    harga: 65000,
    gambar: 'https://down-id.img.susercontent.com/file/id-11134207-7r98p-lne7oelg537q68'
  ),
  Produk(
    nama: 'Face Mask Gel Mugwort',
    deskripsi: 'Eksfoliator wajah untuk kulit halus',
    harga: 35000,
    gambar: 'https://down-id.img.susercontent.com/file/id-11134208-7ra0j-mckgud3d7who17'
  ),
  Produk(
    nama: 'Night Cream Wardah Crystal Secret',
    deskripsi: 'Krim malam untuk regenerasi kulit',
    harga: 60000,
    gambar: 'https://cf.shopee.com.my/file/3351780148ba9ae61638f488e68618bc'
  ),
  Produk(
    nama: 'Cleansing Oil Sea Make Up',
    deskripsi: 'Pembersih Oil makeup dan wajah',
    harga: 80000,
    gambar: 'https://down-my.img.susercontent.com/file/my-11134207-7ras9-mc7c9v39k1g727'
  ),
  Produk(
    nama: 'Micellar Water Npure',
    deskripsi: 'Pembersih makeup dan wajah',
    harga: 55000,
    gambar: 'https://lh7-rt.googleusercontent.com/docsz/AD_4nXfatLIkX-T_Of5mKorzw3QUiAOfCAhAOd7MCbor8cqvzeXxLsbdJmNvTEUA16HmzdLt8Ev6y5ERkdc3SLSxoKmGUuKPOV8PsuM4AmkwkgV_X5TK3emrgNdlyvewMgXkeGEICOop?key=prYGmJF1IC6rbT0Sp24BIfVV'
  ),
  Produk(
    nama: 'Face Mist Wardah 3 in 1',
    deskripsi: 'Mist penyegar untuk kulit kering',
    harga: 30000,
    gambar: 'https://cf.shopee.co.id/file/6d843bd37490de2eb0ea1eed2e452ca1'
  ),
  Produk(
    nama: 'Acne Spot YOU',
    deskripsi: 'Pengobatan spot untuk jerawat',
    harga: 35000,
    gambar: 'https://down-id.img.susercontent.com/file/id-11134207-7r991-lmfpr1fr29es2a'
  ),
  Produk(
    nama: 'Clay Mask Skintific',
    deskripsi: 'Masker tanah liat untuk kulit berminyak',
    harga: 90000,
    gambar: 'https://down-sg.img.susercontent.com/file/sg-11134207-7qvdr-ljyy0k84068n72'
  ),
  Produk(
    nama: 'Air Mawar Viva',
    deskripsi: 'Air Mawar untuk kulit sensitif',
    harga: 10000,
    gambar: 'https://down-my.img.susercontent.com/file/my-11134207-7qul7-lilcvtaucvgm71'
  ),
  Produk(
    nama: 'Lash and Brow Serum',
    deskripsi: 'Serum bulu mata dan alis',
    harga: 67000,
    gambar: 'https://down-id.img.susercontent.com/file/id-11134207-7rasm-m570tog4om37f3'
  ),
  Produk(
    nama: 'Lip Scrub Emina',
    deskripsi: 'Scrub bibir untuk bibir halus',
    harga: 50000,
    gambar: 'https://down-id.img.susercontent.com/file/id-11134207-7r98y-lo6ai140w4zz34'
  ),
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
      
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            'Skin Care Collection',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 20),
          
          ...List.generate(daftarProduk.length, (index) {
            final produk = daftarProduk[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        produk.gambar,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(produk.nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(
                            produk.deskripsi,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rp ${produk.harga}',
                                style: const TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.bold, 
                                  color: Color.fromARGB(255, 164, 30, 84)
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (jumlahProduk[index] > 0) {
                                        setState(() { jumlahProduk[index]--; });
                                      }
                                    },
                                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                                    color: const Color.fromARGB(255, 164, 30, 84),
                                  ),
                                  Text('${jumlahProduk[index]}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () {
                                      setState(() { jumlahProduk[index]++; });
                                    },
                                    icon: const Icon(Icons.add_circle, size: 20),
                                    color: const Color.fromARGB(255, 164, 30, 84),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      
      floatingActionButton: totalItem > 0 ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanKeranjang(
                daftarProduk: daftarProduk,
                jumlahProduk: jumlahProduk,
              ), 
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 164, 30, 84),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_cart),
        label: Text('Keranjang ($totalItem)'),
      ) : null,
    );
  }
}

// --- HALAMAN KERANJANG ---
class HalamanKeranjang extends StatelessWidget {
  final List<Produk> daftarProduk;
  final List<int> jumlahProduk;

  const HalamanKeranjang({
    super.key,
    required this.daftarProduk,
    required this.jumlahProduk
  });

  @override
  Widget build(BuildContext context) {
    int totalItem = jumlahProduk.reduce((a, b) => a + b);
    int totalHarga = 0;
    
    for (int i = 0; i < daftarProduk.length; i++) {
      totalHarga += daftarProduk[i].harga * jumlahProduk[i];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: const Color.fromARGB(255, 164, 30, 84),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                ...List.generate(daftarProduk.length, (index) {
                  if (jumlahProduk[index] > 0) {
                    final produk = daftarProduk[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Image.network(
                          produk.gambar,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                        title: Text(produk.nama),
                        subtitle: Text('${jumlahProduk[index]} x Rp ${produk.harga}'),
                        trailing: Text(
                          'Rp ${produk.harga * jumlahProduk[index]}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ].where((widget) => widget != const SizedBox.shrink()).toList(),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Item:', style: TextStyle(fontSize: 16)),
                    Text('$totalItem item', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Harga:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      'Rp $totalHarga',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 164, 30, 84)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Lanjut Belanja'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalamanPembayaran(
                                totalHarga: totalHarga,
                                totalItem: totalItem,
                                daftarProduk: daftarProduk,
                                jumlahProduk: jumlahProduk,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 164, 30, 84),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Bayar Sekarang'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- HALAMAN PEMBAYARAN ---
class HalamanPembayaran extends StatelessWidget {
  final int totalHarga;
  final int totalItem;
  final List<Produk> daftarProduk;
  final List<int> jumlahProduk;

  const HalamanPembayaran({
    super.key,
    required this.totalHarga,
    required this.totalItem,
    required this.daftarProduk,
    required this.jumlahProduk
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: const Color.fromARGB(255, 164, 30, 84),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            ...List.generate(daftarProduk.length, (index) {
              if (jumlahProduk[index] > 0) {
                final produk = daftarProduk[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.spa, size: 20),
                  ),
                  title: Text(produk.nama),
                  subtitle: Text('${jumlahProduk[index]} x Rp ${produk.harga}'),
                  trailing: Text('Rp ${produk.harga * jumlahProduk[index]}'),
                );
              }
              return const SizedBox.shrink();
            }),
            
            const Divider(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                Text('Rp $totalHarga', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Biaya Admin:', style: TextStyle(fontSize: 16)),
                Text('Rp 2000', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  'Rp ${totalHarga + 2000}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 164, 30, 84)
                  ),
                ),
              ],
            ),

            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pembayaran Berhasil!'),
                      content: const Text('Terima kasih telah berbelanja di Jemas Beauty. Pesanan Anda sedang diproses.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HalamanBeranda()),
                              (route) => false,
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 164, 30, 84),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Konfirmasi Pembayaran'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
