import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_item_screen.dart';
import 'edit_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    final data = await ApiService.getItems();

    if (!mounted) return;

    setState(() {
      items = data;
      isLoading = false;
    });
  }

  void _prosesHapus(String id) async {
    // Trik Cepat: Hapus dari layar dulu
    var backup = List.from(items);
    setState(() {
      items.removeWhere((item) => item['id'].toString() == id);
    });

    bool success = await ApiService.deleteItem(id);

    if (!mounted) return;

    if (!success) {
      setState(() {
        items = backup;
      }); // Kembalikan jika gagal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menghapus")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil dihapus")));
      fetchData(); // Refresh sinkronisasi
    }
  }

  void _konfirmasiHapus(String id) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Hapus?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _prosesHapus(id);
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventaris Gudang"),
        backgroundColor: Colors.teal,
      ),
      body:
          isLoading && items.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return Card(
                    child: ListTile(
                      // PERBAIKAN: Tambahkan .toString() agar angka tidak bikin crash
                      title: Text(
                        item['nama_barang']?.toString() ?? "Tanpa Nama",
                      ),
                      subtitle: Text("Stok: ${item['stok']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) => EditItemScreen(item: item),
                                  ),
                                ).then((_) => fetchData()),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => _konfirmasiHapus(item['id'].toString()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const AddItemScreen()),
            ).then((_) => fetchData()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
