import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbz4ybRlXs-Xiys9N2qhgr_SFHdNDNMzAO_UeKr-uq4KbpLX91GPLnijaJm9EQfI4mn_/exec';

  static Future<List<dynamic>> getItems() async {
    try {
      final url = "$baseUrl?t=${DateTime.now().millisecondsSinceEpoch}";
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200 ? jsonDecode(response.body) : [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addItem(String n, String k, String s) async {
    try {
      final url = "$baseUrl?action=insert&nama_barang=$n&kategori=$k&stok=$s";
      final res = await http
          .post(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      return (res.statusCode == 200 || res.statusCode == 302);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateItem(
    String id,
    String n,
    String k,
    String s,
  ) async {
    try {
      final url =
          "$baseUrl?action=update&id=$id&nama_barang=$n&kategori=$k&stok=$s";
      final res = await http
          .post(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      return (res.statusCode == 200 || res.statusCode == 302);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteItem(String id) async {
    try {
      final url = "$baseUrl?action=delete&id=$id";
      final res = await http
          .post(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      return (res.statusCode == 200 || res.statusCode == 302);
    } catch (e) {
      return true; // Asumsikan sukses jika timeout karena Google tetap memproses
    }
  }
}
