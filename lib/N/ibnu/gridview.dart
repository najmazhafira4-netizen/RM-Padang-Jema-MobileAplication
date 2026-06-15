import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true, 
      ),
      home: const KatalogProdukPremium(),
    );
  }
}

class KatalogProdukPremium extends StatelessWidget {
  const KatalogProdukPremium({super.key});

  @override
  Widget build(BuildContext context) {
    // Data produk 
    final List<Map<String, String>> daftarProduk = [
      {
        'nama': 'UltraBook 13 Pro',
        'kategori': 'High Performance Laptop',
        'rating': '4.8',
        'gambar': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500&auto=format&fit=crop&q=60'
      },
      {
        'nama': 'AuraSound Elite',
        'kategori': 'Hi-Res Wireless Audio',
        'rating': '4.9',
        'gambar': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&auto=format&fit=crop&q=60'
      },
      {
        'nama': 'Zenith Watch S5',
        'kategori': 'Fitness & Smart Tracking',
        'rating': '4.7',
        'gambar': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop&q=60'
      },
      {
        'nama': 'LensMaster F1.4',
        'kategori': 'Professional Photography',
        'rating': '5.0',
        'gambar': 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400&auto=format&fit=crop&q=60'
      },
      {
        'nama': 'Lumino Pico Pro',
        'kategori': 'Cinematic Pocket Projector',
        'rating': '4.6',
        'gambar': 'https://images.unsplash.com/photo-1535016120720-40c646be5580?w=400&auto=format&fit=crop&q=60'
      },
      {
        'nama': 'TabCraft Note+',
        'kategori': 'Creativity & Digital Art',
        'rating': '4.8',
        'gambar': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400&auto=format&fit=crop&q=60'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        title: const Text(
          'Katalog Produk Premium',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal, 
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.68, 
          ),
          itemCount: daftarProduk.length,
          itemBuilder: (context, index) {
            final produk = daftarProduk[index];
            
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), 
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Gambar Produk
                  Expanded(
                    child: Stack(
                      children: [
                        Image.network(
                          produk['gambar']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  // 2. Konten Teks & Fitur
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Produk
                        Text(
                          produk['nama']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        
                        // Kategori
                        Text(
                          produk['kategori']!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        
                        // Rating Bintang
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              produk['rating']!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Tombol Interaktif Beli/Keranjang
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {
                              // (menampilkan SnackBer)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${produk['nama']} ditambahkan!'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Tambah',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}