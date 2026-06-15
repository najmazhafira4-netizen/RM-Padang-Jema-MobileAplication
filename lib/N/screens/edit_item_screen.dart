import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditItemScreen extends StatefulWidget {
  // Variabel untuk menampung data barang yang dilempar dari HomeScreen
  final dynamic item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _kategoriController;
  late TextEditingController _stokController;

  @override
  void initState() {
    super.initState();
    // Mengisi form otomatis dengan data lama yang diterima dari parameter 'item'
    _namaController = TextEditingController(
      text: widget.item['nama_barang'].toString(),
    );
    _kategoriController = TextEditingController(
      text: widget.item['kategori'].toString(),
    );
    _stokController = TextEditingController(
      text: widget.item['stok'].toString(),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kategoriController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  void _updateData() async {
    if (_formKey.currentState!.validate()) {
      // Tampilkan animasi loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Panggil fungsi update dari ApiService, JANGAN LUPA KIRIM ID!
      bool success = await ApiService.updateItem(
        widget.item['id']
            .toString(), // ID dibutuhkan agar Apps Script tahu baris mana yang diubah
        _namaController.text,
        _kategoriController.text,
        _stokController.text,
      );

      // PERBAIKAN: Tambahkan pengecekan mounted sebelum menggunakan context
      if (!mounted) return;

      Navigator.pop(context); // Tutup animasi loading

      if (success) {
        Navigator.pop(context); // Kembali ke halaman utama
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Barang'),
        backgroundColor: Colors.orange, // Bedakan warna agar UI lebih intuitif
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Stok'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: _updateData,
                  child: const Text(
                    'SIMPAN PERUBAHAN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
