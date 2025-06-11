import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/controller/authentication_controller.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/widgets/main_menu.dart';
import 'package:flutter_cbt_tpa_app/widgets/sample_slider.dart';
import 'package:flutter_cbt_tpa_app/pages/daftar_sampah_page.dart';
import 'package:get/get.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final authenticationController = Get.find<AuthenticationController>();
  @override
  Widget build(BuildContext context) {
    // Memanggil fungsi getUser() untuk mengambil data pengguna
    authenticationController.getUser();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset('lib/images/logo_bangJAKI.png', width: 100),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Obx(
                  () => Text(
                    "Hi, ${authenticationController.name.value}!",
                    style: AppTextStyle.greeting,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Saldo Anda", style: TextStyle(fontSize: 14)),
                      Text("Rp 271.000.000.000.000", style: AppTextStyle.balance),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const MainMenu(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Harga Sampah",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaftarSampahPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SampleSlider(),
          ],
        ),
      ),
    );
  }
}
