import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

/// Halaman untuk menampilkan titik poin kantor.
class TitikPoinPage extends StatefulWidget {
  const TitikPoinPage({super.key});

  @override
  State<TitikPoinPage> createState() => _TitikPoinPageState();
}

class _TitikPoinPageState extends State<TitikPoinPage> {
  final List<Map<String, String>> bgJakiPoints = [
    {
      'name': 'BangJaki Point Binjai',
      'address':
          'Palam Permai, Nangka, Kec. Binjai Utara, Kota Binjai, Sumatera Utara 20351',
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tombol back seperti di gambar pertama (panah kiri)
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   color: Colors.white, // Warna ikon agar terlihat di app bar biru
        //   onPressed: () {
        //     Navigator.pop(context); // Kembali ke halaman sebelumnya
        //   },
        // ),
        /// Warna background.
        backgroundColor: AppColors.primary,
        title: const Text(
          "BgJaki Point",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        /// Warna teks app bar.
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // Gunakan SingleChildScrollView agar bisa discroll
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Atur alignment konten
          children: [
            // Bagian Header dengan ilustrasi dan teks
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.primary, // Background sesuai app bar
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      // Ganti dengan path aset gambar Anda
                      // Atau gunakan Image.network jika gambar dari URL
                      'lib/images/bgjaki_images.png', // Contoh: sesuaikan path
                      height: 180, // Sesuaikan tinggi gambar
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Antar dan jual sampah daur ulangmu di",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "BgJaki Point terdekat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spasi setelah header
            // Bagian "Semua Lokasi BgJaki Point"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Semua Lokasi BgJaki Point :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Daftar Lokasi BgJaki Point
            ListView.builder(
              shrinkWrap:
                  true, // Penting agar ListView bisa di dalam SingleChildScrollView
              physics:
                  const NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView
              itemCount: bgJakiPoints.length,
              itemBuilder: (context, index) {
                final point = bgJakiPoints[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15.0),
                    leading: Icon(
                      Icons.location_on,
                      color:
                          AppColors.primary, // Icon lokasi dengan warna primary
                      size: 30,
                    ),
                    title: Text(
                      point['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      point['address']!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // TODO: Implementasi navigasi ke detail lokasi atau peta
                      // Contoh: Jika ingin menampilkan peta lokasi tertentu saat diklik
                      // Get.to(() => MapDetailPage(point: point));
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20), // Spasi di bagian bawah
          ],
        ),
      ),
    );
  }
}
