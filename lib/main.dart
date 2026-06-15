import 'package:flutter/material.dart';
import 'auth/halaman_login.dart';

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
      home: const HalamanLogin(),
    );
  }
}