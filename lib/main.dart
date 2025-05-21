import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔧 Untuk menyimpan data lokal

// Import halaman login dan halaman utama (main page)
import 'package:flutter_cbt_tpa_app/pages/login_page.dart';
import 'package:flutter_cbt_tpa_app/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

// Root widget aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 🔧 Matikan banner debug
      title: 'BangJaki',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ), // 🔧 Set tema aplikasi
      ),
      initialRoute: '/login', // 🔧 Routing awal ke halaman login
      getPages: [
        // 🔧 Daftar semua route aplikasi di sini
        GetPage(name: '/login', page: () => LoginPage()), //
        GetPage(name: '/main', page: () => flutter_cbt_tpa_app()), //
      ],
    );
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
