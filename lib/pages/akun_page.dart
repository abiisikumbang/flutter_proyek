import 'package:flutter/material.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String namaPengguna = "Joe Fachrey";
    final String emailPengguna = "joe@example.com";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(namaPengguna, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(emailPengguna, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Pengaturan"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Keluar", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Tambahkan logika logout jika ada
            },
          ),
        ],
      ),
    );
  }
}
