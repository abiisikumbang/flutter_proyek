import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

/// Halaman untuk menjual sampah.
class JualSampahPage extends StatelessWidget {
  const JualSampahPage({super.key});

  /// Membuat tampilan halaman jual sampah.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// Warna background app bar.
        backgroundColor: AppColors.primary,
        title: const Text(
          "Jual Sampah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        /// Warna teks app bar.
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Jenis Sampah",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  sampahItem(context, 'images/plastik.png', 'Plastik', 'Rp 1.500/kg'),
                  sampahItem(context, 'images/kertas.png', 'Kertas', 'Rp 1.000/kg'),
                  sampahItem(context, 'images/logam.png', 'Logam', 'Rp 3.500/kg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membuat item untuk tiap-tiap jenis sampah.
  ///
  /// [context] adalah konteks widget yang sedang dibuat.
  /// [img] adalah nama file gambar yang akan ditampilkan.
  /// [title] adalah judul item yang akan ditampilkan.
  /// [price] adalah harga item yang akan ditampilkan.
  Widget sampahItem(BuildContext context, String img, String title, String price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Image.asset(img, width: 48),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            /// Menampilkan dialog konfirmasi ketika tombol jual diklik.
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Konfirmasi"),
                  content: Text("Apakah Anda yakin ingin menjual $title?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Batal"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Jual"),
                      onPressed: () {
                        /// Logika untuk menjual item.
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$title berhasil dijual!')),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Text("Jual", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

