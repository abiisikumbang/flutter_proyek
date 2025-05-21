import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

class SampleSlider extends StatelessWidget {
  const SampleSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> samples = [
      {'image': 'images/sample1.png', 'name': 'Botol Plastik'},
      {'image': 'images/sample2.png', 'name': 'Kardus'},
      {'image': 'images/sample3.png', 'name': 'Kaleng'},
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: samples.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    samples[index]['image']!,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 6),
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
