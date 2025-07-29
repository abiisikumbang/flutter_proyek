import 'package:flutter/material.dart'; // Importing Flutter Material package for UI widgets
import 'package:flutter_cbt_tpa_app/pages/home_content.dart'; // Importing HomeContent page
import 'package:flutter_cbt_tpa_app/pages/transaksi_page.dart'; // Importing TransaksiPage
import 'package:flutter_cbt_tpa_app/pages/jual_sampah_page.dart'; // Importing JualSampahPage
import 'package:flutter_cbt_tpa_app/pages/bantuan_page.dart'; // Importing BantuanPage
import 'package:flutter_cbt_tpa_app/pages/akun_page.dart'; // Importing AkunPage

class FlutterCbtTpaApp extends StatefulWidget { // Defining a stateful widget
  const FlutterCbtTpaApp({super.key}); // Constructor for the widget

  @override
  State<FlutterCbtTpaApp> createState() => FlutterCbtTpaAppState(); // Creating state for the widget
}

class FlutterCbtTpaAppState extends State<FlutterCbtTpaApp> { // State class for FlutterCbtTpaApp
  int _selectedIndex = 0; // Index of the currently selected bottom navigation item

  final List<Widget> _pages = [ // List of pages to navigate through
    const HomeContent(), // HomeContent page
    const TransaksiPage(), // TransaksiPage
    const JualSampahPage(), // JualSampahPage
    const BantuanPage(), // BantuanPage
    const AkunPage(), // AkunPage
  ];

  void _onItemTapped(int index) { // Function to handle item tap on bottom navigation
    setState(() { // Update the state
      _selectedIndex = index; // Change the selected index
    });
  }

  // --- Start: Custom Bottom Navigation Bar Implementation ---
  Widget _buildCustomBottomNavigationBar() { // Function to build a custom bottom navigation bar
    const backgroundColor = Color(0xFFFFFFFF); // Background color for the navigation bar
    const selectedColor = Colors.orange; // Color for selected item
    const unselectedColor = Colors.grey; // Color for unselected items

    // Define menu items with their icons and labels
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.home, 'label': 'Beranda'}, // Home item
      {'icon': Icons.receipt_long, 'label': 'Transaksi'}, // Transaksi item
      {'icon': Icons.sell, 'label': 'Jual'}, // Jual item
      {'icon': Icons.help_outline, 'label': 'Bantuan'}, // Bantuan item
      {'icon': Icons.person, 'label': 'Akun'}, // Akun item
    ];

    return Container( // Creating a container for the navigation bar
      decoration: const BoxDecoration( // Setting decoration for the container
        color: backgroundColor, // Background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)), // Rounded corners on top
        boxShadow: [ // Shadow properties
          BoxShadow(
            color: Colors.black12, // Shadow color
            blurRadius: 10.0, // Shadow blur radius
            offset: Offset(0, -5), // Shadow offset
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Padding inside the container
      child: Row( // Using a row to layout the items
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Space items evenly
        children: List.generate(menuItems.length, (index) { // Generate a list of navigation items
          final item = menuItems[index]; // Get the current menu item
          return _buildCustomNavItem( // Build navigation item
            index, // Index of the item
            item['icon'] as IconData, // Icon for the item
            item['label'] as String, // Label for the item
            selectedColor, // Selected item color
            unselectedColor, // Unselected item color
          );
        }),
      ),
    );
  }

  // Helper method for building each custom navigation item
  Widget _buildCustomNavItem(int index, IconData iconData, String label, Color selectedColor, Color unselectedColor) {
    final isSelected = _selectedIndex == index; // Check if the item is selected
    final double iconSize = isSelected ? 30.0 : 24.0; // Set icon size based on selection
    final color = isSelected ? selectedColor : unselectedColor; // Set color based on selection

    return GestureDetector( // Use GestureDetector for handling taps
      onTap: () => _onItemTapped(index), // Handle tap event
      child: MouseRegion( // MouseRegion for hover effects
        cursor: SystemMouseCursors.click, // Change cursor to pointer
        onHover: (event) {}, // Handle hover event
        child: Column( // Use Column to stack icon and label
          mainAxisSize: MainAxisSize.min, // Take minimum space
          children: [
            Icon(iconData, color: color, size: iconSize), // Display the icon
            const SizedBox(height: 4), // Space between icon and label
            Text( // Display the label
              label,
              style: TextStyle(color: color, fontSize: 12), // Style for the label
            ),
            if (isSelected) // Conditional rendering for selected item indicator
              Container(
                margin: const EdgeInsets.only(top: 4), // Margin above the indicator
                height: 2, // Height of the indicator
                width: 20, // Width of the indicator
                decoration: BoxDecoration(
                  color: selectedColor, // Indicator color
                  borderRadius: BorderRadius.circular(1), // Rounded ends for the indicator
                ),
              ),
          ],
        ),
      ),
    );
  }
  // --- End: Custom Bottom Navigation Bar Implementation ---

  @override
  Widget build(BuildContext context) { // Build method for the widget
    return Scaffold( // Return a Scaffold widget
      body: IndexedStack( // Use IndexedStack for body content
        index: _selectedIndex, // Current selected index
        children: _pages, // Pages to display in the stack
      ),
      bottomNavigationBar: _buildCustomBottomNavigationBar(), // Custom bottom navigation bar
    );
  }
}
