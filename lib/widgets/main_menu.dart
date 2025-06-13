import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/pages/bantuan_page.dart';
import '../pages/titik_poin_page.dart';
import '../pages/daftar_sampah_page.dart';
import '../pages/sekolah_page.dart';



class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.recycling, 'label': 'Daftar Sampah'},
      {'icon': Icons.location_on, 'label': 'Titik Poin'},
      {'icon': Icons.menu_book, 'label': 'Panduan'},
      {'icon': Icons.school, 'label': 'Sekolah\nBebas Sampah'},
      // {'icon': Icons.event, 'label': 'Bisnis &\nEvent'}, // Dicomment out seperti versi Anda
      {'icon': Icons.apps, 'label': 'Program\nLainnya'},
      // Jika 'Jual Sampah' ingin ditambahkan, uncomment baris ini:
      // {'icon': Icons.attach_money, 'label': 'Jual Sampah'},
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: GridView.count(
            crossAxisCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(menuItems.length, (index) {
              final item = menuItems[index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (item['label'] == 'Daftar Sampah') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DaftarSampahPage()),
                      );
                    } else if (item['label'] == 'Titik Poin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TitikPoinPage()),
                      );
                    } else if (item['label'] == 'Panduan') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BantuanPage()),
                      );
                    } else if (item['label'] == 'Sekolah\nBebas Sampah') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SekolahPage()),
                      );
                    }
                    // Jika Jual Sampah ingin ditambahkan, tambahkan logika ini:
                    // else if (item['label'] == 'Jual Sampah') {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => JualSampahPage()),
                    //   );
                    // }
                    else if (item['label'] == 'Program\nLainnya') {
                      // Menampilkan notifikasi di tengah layar
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                              "Program lainnya dari bangJAKI akan segera keluar",
                              textAlign: TextAlign.center,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Tutup dialog
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
                        CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          child: Icon(item['icon'], color: Colors.orange, size: 28),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child:
                          Text(
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
    );
  }
}