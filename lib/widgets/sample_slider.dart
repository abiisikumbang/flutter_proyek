import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sampah_item.dart'; // Pastikan path ini sesuai dengan struktur foldermu

class SampleSlider extends StatefulWidget {
  const SampleSlider({super.key});

  @override
  State<SampleSlider> createState() => _SampleSliderState();
}

class _SampleSliderState extends State<SampleSlider> {
  List<SampahItemModel> samples = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSampleItems();
  }

  Future<void> _fetchSampleItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Token tidak ditemukan. Silakan login ulang.';
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/wastes'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> wasteList = responseData['data'];
        // print("🔥 Jumlah data dari API: ${wasteList.length}");
        // print("🔥 Contoh item pertama: ${wasteList.first}");

        final sampleItems =
            wasteList
                .map((json) {
                  try {
                    return SampahItemModel.fromJson(json);
                  } catch (e) {
                    // print("⚠️ Gagal parsing item: $json \nError: $e");
                    return null;
                  }
                })
                .where((e) => e != null)
                .cast<SampahItemModel>()
                .take(3)
                .toList();

        // print("✅ Sample items ditemukan: ${sampleItems.length}");

        setState(() {
          samples = sampleItems;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Gagal mengambil data. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (samples.isEmpty) {
      return const Center(child: Text("Tidak ada sampah ditemukan."));
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: samples.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = samples[index];
          return Container(
            width: 150,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                // Tampilkan gambar jika ada
                item.imageUrl.isNotEmpty
                    ? Image.network(
                      item.imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 32,
                          color: Colors.grey,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    )
                    : const Icon(Icons.image, size: 32, color: Colors.grey),
                const SizedBox(height: 5),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
