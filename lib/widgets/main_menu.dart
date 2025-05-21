import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.recycling, 'label': 'Jual Sampah'},
      {'icon': Icons.location_on, 'label': 'Titik Poin'},
      {'icon': Icons.menu_book, 'label': 'Panduan'},
      {'icon': Icons.school, 'label': 'Sekolah\nBebas Sampah'},
      {'icon': Icons.event, 'label': 'Bisnis &\nEvent'},
      {'icon': Icons.apps, 'label': 'Program\nLainnya'},
    ];

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: menuItems.map((item) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.2),
              radius: 28,
              child: Icon(item['icon'], color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 6),
            Text(
              item['label'],
              textAlign: TextAlign.center,
              style: AppTextStyle.menuLabel,
            )
          ],
        );
      }).toList(),
    );
  }
}
