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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Transaksi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sell), label: 'Jual'),
          BottomNavigationBarItem(
              icon: Icon(Icons.help_outline), label: 'Bantuan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
