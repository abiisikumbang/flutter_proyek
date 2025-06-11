import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

// Halaman bantuan untuk pengguna
class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar FAQ yang akan ditampilkan
    final List<Map<String, String>> faqList = [
      {
        "pertanyaan": "Bagaimana cara menjual sampah?", // pertanyaan 1
        "jawaban":
            "Masuk ke menu 'Jual Sampah', pilih jenis sampah, dan ikuti langkah-langkah pengiriman.", // jawaban 1
      },
      {
        "pertanyaan": "Apa itu titik poin?", // pertanyaan 2
        "jawaban":
            "Titik poin adalah lokasi drop-off atau pengambilan sampah yang bekerja sama dengan BangJAKI.", // jawaban 2
      },
      {
        "pertanyaan": "Bagaimana jika transaksi gagal?", // pertanyaan 3
        "jawaban":
            "Silakan hubungi CS melalui fitur bantuan atau kirim email ke cs@bangjaki.id", // jawaban 3
      },
    ];

    // Struktur halaman bantuan
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bantuan", // judul halaman
          style: TextStyle(fontWeight: FontWeight.bold), // gaya teks judul
        ),
        backgroundColor: AppColors.primary, // warna background app bar
        foregroundColor: Colors.white, // warna teks app bar
        elevation: 0, // tinggi app bar
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16), // jarak antara item
        itemCount: faqList.length, // jumlah item
        itemBuilder: (context, index) {
          final faq = faqList[index]; // ambil item ke-i
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              title: Text(
                faq["pertanyaan"]!, // judul item
                style: const TextStyle(fontWeight: FontWeight.bold), // gaya teks judul
              ),
              childrenPadding: const EdgeInsets.all(16.0),
              children: [
                Text(faq["jawaban"]!),
              ],
            ),
          );
        },
      ),
    );
  }
}

