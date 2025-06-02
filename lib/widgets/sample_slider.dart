import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

/// Widget untuk menampilkan slider dari beberapa sampel
class SampleSlider extends StatelessWidget {
  const SampleSlider({super.key});

  @override
  Widget build(BuildContext context) {
    /// Daftar sampel yang akan ditampilkan
    final List<Map<String, String>> samples = [
      {'image': 'images/sample1.png', 'name': 'Botol Plastik'},
      {'image': 'images/sample2.png', 'name': 'Kardus'},
      {'image': 'images/sample3.png', 'name': 'Kaleng'},
    ];

    /// Ukuran tinggi dari slider
    return SizedBox(
      height: 120,
      child: ListView.separated(
        /// Arah scrolling dari slider
        scrollDirection: Axis.horizontal,
        /// Jumlah item yang akan ditampilkan
        itemCount: samples.length,
        /// Builder untuk membuat separator antar item
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        /// Builder untuk membuat item
        itemBuilder: (context, index) {
          return Container(
            /// Lebar dari setiap item
            width: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              /// Border dari setiap item
              border: Border.all(color: AppColors.cardBorder),
              /// Bentuk sudut dari setiap item
              borderRadius: BorderRadius.circular(12),
              /// Warna background dari setiap item
              color: Colors.white,
            ),
            child: Column(
              children: [
                /// Gambar dari setiap item
                Expanded(
                  child: Image.asset(
                    samples[index]['image']!,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 6),
                /// Nama dari setiap item
                Text(
                  samples[index]['name']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

