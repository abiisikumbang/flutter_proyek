import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart';

class SampleSlider extends StatefulWidget {
  const SampleSlider({super.key});

  @override
  State<SampleSlider> createState() => _SampleSliderState();
}

class _SampleSliderState extends State<SampleSlider> {
  List<SampahItemModel> samples = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSamples();
  }

  Future<void> fetchSamples() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.145.6:8000/api/wastes'), // Ganti sesuai IP
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        final List<SampahItemModel> items = data.map((json) {
          return SampahItemModel(
            id: json['id'],
            name: json['name'],
            imageUrl: json['image'] ?? '',
            points: json['point_value'],
            satuan: json['satuan'],
          );
        }).toList();

        setState(() {
          samples = items.take(3).toList(); // Ambil 3 data saja
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e, stackTrace) {
      // Use Flutter's logging framework
      debugPrint("Error fetching samples: $e\n$stackTrace");
      setState(() {
      isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
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
                item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 32, color: Colors.grey);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
