import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/pages/main_page.dart';
import 'package:flutter_cbt_tpa_app/pages/transaksi_page.dart';
import 'package:flutter_cbt_tpa_app/pages/jual_sampah_page.dart';
import 'package:flutter_cbt_tpa_app/pages/bantuan_page.dart';
import 'package:flutter_cbt_tpa_app/pages/akun_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  // List halaman berdasarkan indeks
  final List<Widget> _pages = const [
    FlutterCbtTpaApp(),
    TransaksiPage(),
    JualSampahPage(),
    BantuanPage(),
    AkunPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Jual'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Bantuan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
