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
      body: ListView.separated(
        padding: const EdgeInsets.all(16), // jarak antara item
        itemCount: faqList.length, // jumlah item
        separatorBuilder: (_, __) => const SizedBox(height: 12), // jarak antara item
        itemBuilder: (context, index) {
          final faq = faqList[index]; // ambil item ke-i
          return ExpansionTile(
            title: Text(
              faq["pertanyaan"]!, // judul item
              style: const TextStyle(fontWeight: FontWeight.bold), // gaya teks judul
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12), // jarak antara item
                child: Text(faq["jawaban"]!), // jawaban item
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
<<<<<<< HEAD
}

=======
}
>>>>>>> fc37a29171822200dac8def7e09633b7a1ca0a55
