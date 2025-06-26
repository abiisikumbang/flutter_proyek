import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authentication_controller.dart';
import '../material.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance AuthenticationController
    final authenticationController = Get.find<AuthenticationController>();

    // authenticationController.getUser();

    return Scaffold(
      appBar: AppBar(
        // Judul halaman
        title: const Text(
          "Akun",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Warna background dan foreground
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                // Radius avatar
                radius: 48,
                // Warna background
                backgroundColor: Colors.grey[300],
                // Icon yang digunakan
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Menampilkan nama, email, dan nomor telepon pengguna
              Obx(() {
                if (authenticationController.name.value.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Nama pengguna
                      Text(
                        authenticationController.name.value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      // Email pengguna
                      Text(
                        authenticationController.email.value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      // Nomor telepon pengguna
                      Text(
                        authenticationController.phoneNumber.value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Point Anda: ${authenticationController.totalPoints.value} Point",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            tooltip: 'Refresh Point',
                            onPressed: () async {
                              await authenticationController.getUser();
                            },
                          ),
                        ],
                      ),

                    ],
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  );
                }
              }),
              const SizedBox(height: 32),
              const Divider(thickness: 1.2),
              const SizedBox(height: 16),
              // Tombol logout
              Obx(
                () =>
                    authenticationController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            // Warna background dan foreground
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            // Icon yang digunakan
                            icon: const Icon(Icons.logout),
                            // Label tombol
                            label: const Text(
                              'Logout',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              // Memanggil fungsi logout dari controller
                              authenticationController.logout();
                            },
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
