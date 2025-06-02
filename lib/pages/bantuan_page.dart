import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        "pertanyaan": "Bagaimana cara menjual sampah?",
        "jawaban":
            "Masuk ke menu 'Jual Sampah', pilih jenis sampah, dan ikuti langkah-langkah pengiriman.",
      },
      {
        "pertanyaan": "Apa itu titik poin?",
        "jawaban":
            "Titik poin adalah lokasi drop-off atau pengambilan sampah yang bekerja sama dengan BangJAKI.",
      },
      {
        "pertanyaan": "Bagaimana jika transaksi gagal?",
        "jawaban":
            "Silakan hubungi CS melalui fitur bantuan atau kirim email ke cs@bangjaki.id",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bantuan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return ExpansionTile(
            title: Text(
              faq["pertanyaan"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(faq["jawaban"]!),
              ),
            ],
          );
        },
      ),
    );
  }
}
