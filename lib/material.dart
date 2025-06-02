import 'package:flutter/material.dart';

// Class untuk menyimpan warna-warna aplikasi
class AppColors {
  // Warna utama aplikasi
  static const primary = Color(0xFFFC8C4C);
  // Warna latar belakang aplikasi
  static const background = Color(0xFFFDF6F2);
  // Warna border untuk kartu
  static const cardBorder = Color(0xFFE0E0E0);
  // Warna untuk teks gelap
  static const textDark = Color(0xFF333333);
  // Warna putih
  static const white = Colors.white;

  // Warna utama dengan transparansi
  static var primaryLight = primary;
}

// Class untuk menyimpan gaya teks aplikasi
class AppTextStyle {
  // Gaya teks untuk salam
  static const greeting = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  // Gaya teks untuk saldo
  static const balance = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  // Gaya teks untuk label menu
  static const menuLabel = TextStyle(fontSize: 12);
}

