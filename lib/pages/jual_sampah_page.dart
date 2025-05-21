import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

class JualSampahPage extends StatelessWidget {
  const JualSampahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Jual Sampah"),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            sampahItem('images/plastik.png', 'Plastik', 'Rp 1.500/kg'),
            sampahItem('images/kertas.png', 'Kertas', 'Rp 1.000/kg'),
            sampahItem('images/logam.png', 'Logam', 'Rp 3.500/kg'),
          ],
        ),
      ),
    );
  }

  Widget sampahItem(String img, String title, String price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Image.asset(img, width: 48),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {},
          child: const Text("Jual", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}