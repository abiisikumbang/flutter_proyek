import 'package:flutter/material.dart';
// import 'package:flutter_cbt_tpa_app/pages/bantuan_page.dart';
import '../pages/titik_poin_page.dart';
import '../pages/daftar_sampah_page.dart';
import '../pages/sekolah_page.dart';
import '../pages/redeem_page.dart';

/// Widget untuk menampilkan menu utama
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.recycling, 'label': 'Daftar Sampah', 'color': Colors.green},
      {'icon': Icons.location_on, 'label': 'Titik Poin', 'color': Colors.blue},
      // {'icon': Icons.menu_book, 'label': 'Panduan', 'color': Colors.purple},
      {'icon': Icons.school, 'label': 'Sekolah\nBebas Sampah', 'color': Colors.red},
      {'icon': Icons.redeem, 'label': 'Redeem\nPoint', 'color': Colors.amber},
      {'icon': Icons.apps, 'label': 'Program\nLainnya', 'color': Colors.teal},
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: GridView.count(
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(), 
                shrinkWrap: true,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.58,
                children: List.generate(menuItems.length, (index) {
                  final item = menuItems[index];

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (item['label'] == 'Daftar Sampah') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DaftarSampahPage(),
                            ),
                          );
                        } else if (item['label'] == 'Titik Poin') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TitikPoinPage(),
                            ),
                          );
                        } else if (item['label'] == 'Redeem\nPoint') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RedeemPage(),
                            ),
                          );
                        } else if (item['label'] == 'Sekolah\nBebas Sampah') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SekolahPage()),
                          );
                        } else if (item['label'] == 'Program\nLainnya') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Program Lainnya"),
                                content: const Text(
                                  "Fitur 'Program Lainnya' sedang dalam pengembangan. Nantikan pembaruan terbaru dari bangJAKI untuk pengalaman yang lebih menarik dan lengkap!",
                                  textAlign: TextAlign.center,
                                ), 
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: item['color'],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                item['icon'],
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Flexible(
                              child: Text(
                                item['label'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

