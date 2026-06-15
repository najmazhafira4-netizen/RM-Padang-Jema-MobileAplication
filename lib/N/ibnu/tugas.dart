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
      title: 'Daftar Matakuliah',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DaftarMatakuliahPage(),
    );
  }
}

// 1. Model Data untuk Matakuliah
class Matakuliah {
  final String nama;
  final int sks;
  final IconData icon;

  Matakuliah({required this.nama, required this.sks, required this.icon});
}

class DaftarMatakuliahPage extends StatefulWidget {
  const DaftarMatakuliahPage({super.key});

  @override
  State<DaftarMatakuliahPage> createState() => _DaftarMatakuliahPageState();
}

class _DaftarMatakuliahPageState extends State<DaftarMatakuliahPage> {
  // 2. Data Lokal 
  final List<Matakuliah> listMatakuliah = [
    Matakuliah(nama: 'Pemrograman Mobile', sks: 3, icon: Icons.phone_android),
    Matakuliah(nama: 'Basis Data', sks: 4, icon: Icons.storage),
    Matakuliah(nama: 'Rekayasa Perangkat Lunak', sks: 3, icon: Icons.developer_mode),
    Matakuliah(nama: 'Kecerdasan Buatan', sks: 3, icon: Icons.psychology),
    Matakuliah(nama: 'Jaringan Komputer', sks: 2, icon: Icons.lan),
    Matakuliah(nama: 'Desain UI/UX', sks: 2, icon: Icons.web),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Matakuliah'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // 3. Menggunakan ListView
        child: ListView.separated(
          itemCount: listMatakuliah.length,
          // Menggunakan Divider 
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          itemBuilder: (context, index) {
            final matkul = listMatakuliah[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                // Ketentuan 1: Icon / Gambar
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: Icon(matkul.icon, color: Colors.blue),
                ),
                // Ketentuan 2: Nama Matakuliah
                title: Text(
                  matkul.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // Ketentuan 3: Jumlah SKS
                subtitle: Text('${matkul.sks} SKS'),
                // Ketentuan 4: Tombol detail, hapus, dll.
                trailing: Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    // Tombol Detail
                    IconButton(
                      icon: const Icon(Icons.info, color: Color.fromARGB(255, 233, 42, 42)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Detail: ${matkul.nama}')),
                        );
                      },
                    ),
                    // Tombol Hapus
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 15, 15, 15)),
                      onPressed: () {
                        setState(() {
                          listMatakuliah.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${matkul.nama} dihapus')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}