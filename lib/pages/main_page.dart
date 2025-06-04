import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/pages/home_content.dart';
import 'package:flutter_cbt_tpa_app/pages/transaksi_page.dart';
import 'package:flutter_cbt_tpa_app/pages/jual_sampah_page.dart';
import 'package:flutter_cbt_tpa_app/pages/bantuan_page.dart';
import 'package:flutter_cbt_tpa_app/pages/akun_page.dart';


class FlutterCbtTpaApp extends StatefulWidget {
  const FlutterCbtTpaApp({super.key});

  @override
  State<FlutterCbtTpaApp> createState() => FlutterCbtTpaAppState();
}

class FlutterCbtTpaAppState extends State<FlutterCbtTpaApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const TransaksiPage(),
    const JualSampahPage(),
    const BantuanPage(),
    const AkunPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- Start: Custom Bottom Navigation Bar Implementation ---
  Widget _buildCustomBottomNavigationBar() {
    const backgroundColor = Color(0xFFFFFFFF); // Using white for a cleaner look, similar to the image
    const selectedColor = Colors.orange; // Color for selected icon/text
    const unselectedColor = Colors.grey; // Color for unselected icon/text

    // Define your original menu items with their icons and labels
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.home, 'label': 'Beranda'},
      {'icon': Icons.receipt_long, 'label': 'Transaksi'},
      {'icon': Icons.sell, 'label': 'Jual'},
      {'icon': Icons.help_outline, 'label': 'Bantuan'},
      {'icon': Icons.person, 'label': 'Akun'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: backgroundColor, // Background color for the custom bar
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)), // Rounded top corners
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Subtle shadow for depth
            blurRadius: 10.0,
            offset: Offset(0, -5), // Shadow offset upwards
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Vertical padding inside the bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute items evenly
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          return _buildCustomNavItem(
            index,
            item['icon'] as IconData, // Cast to IconData
            item['label'] as String, // Cast to String
            selectedColor,
            unselectedColor,
          );
        }),
      ),
    );
  }

  // Helper method for building each custom navigation item
  Widget _buildCustomNavItem(int index, IconData iconData, String label, Color selectedColor, Color unselectedColor) {
    final isSelected = _selectedIndex == index;
    // Adjust size for selected icon
    final double iconSize = isSelected ? 30.0 : 24.0;
    final color = isSelected ? selectedColor : unselectedColor;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: MouseRegion( // Added MouseRegion for hover effect (will show cursor pointer on web/desktop)
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          // You could add more complex visual feedback on hover here if needed,
          // like a subtle color change or scale animation, if not selected.
          // For now, the cursor change is the main hover indicator.
        },
        child: Column(
          mainAxisSize: MainAxisSize.min, // Make column take minimum space
          children: [
            Icon(iconData, color: color, size: iconSize), // Dynamic icon size
            const SizedBox(height: 4), // Space between icon and label
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12), // Label text style
            ),
            if (isSelected) // Show indicator line only if selected
              Container(
                margin: const EdgeInsets.only(top: 4), // Space above the indicator line
                height: 2, // Height of the indicator line
                width: 20, // Width of the indicator line
                decoration: BoxDecoration(
                  color: selectedColor, // Color of the indicator line
                  borderRadius: BorderRadius.circular(1), // Slightly rounded ends for the indicator
                ),
              ),
          ],
        ),
      ),
    );
  }
  // --- End: Custom Bottom Navigation Bar Implementation ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Use the custom bottom navigation bar here
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    );
  }
}