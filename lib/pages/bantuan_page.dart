import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

class BantuanPage extends StatefulWidget {
  const BantuanPage({super.key});

  @override
  State<BantuanPage> createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
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
    {
      "pertanyaan": "Jenis sampah apa saja yang diterima?",
      "jawaban": "Kami menerima berbagai jenis sampah daur ulang seperti kertas, plastik, dan logam.",
    },
    {
      "pertanyaan": "Apakah ada biaya untuk menggunakan aplikasi ini?",
      "jawaban": "Tidak, aplikasi BangJAKI dapat digunakan secara gratis.",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'lib/images/bantuan_image.png', // Ganti dengan path gambar bantuan Anda
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Butuh Bantuan?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Temukan jawaban untuk pertanyaan yang sering diajukan di bawah ini.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Pertanyaan yang Sering Diajukan:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final faq = faqList[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      faq["pertanyaan"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    childrenPadding: const EdgeInsets.all(16.0),
                    children: [
                      Text(faq["jawaban"]!),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}