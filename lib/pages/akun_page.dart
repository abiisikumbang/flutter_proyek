import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authentication_controller.dart';
import '../material.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance AuthenticationController
    final AuthenticationController authenticationController =
        Get.find<AuthenticationController>();

    // authenticationController.getUser();

    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Akun",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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
          radius: 48,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Obx(() {
          if (authenticationController.name.value.isNotEmpty) {
            return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
              authenticationController.name.value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
              authenticationController.email.value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
              authenticationController.phoneNumber.value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              ),
            ],
            );
          } else {
            return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Memuat data pengguna atau belum login...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            );
          }
          }),
          const SizedBox(height: 32),
          const Divider(thickness: 1.2),
          const SizedBox(height: 16),
          Obx(
          () => authenticationController.isLoading.value
            ? const CircularProgressIndicator()
            : SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                'Logout',
                style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
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

// // Halaman akun, berisi data pengguna dan tombol logout
// import 'package:flutter/material.dart';
// import 'package:flutter_cbt_tpa_app/controller/authentication_controller.dart';
// import 'package:get/get.dart';

// import '../material.dart';

// // Widget AkunPage untuk menampilkan informasi pengguna dan opsi logout
// class AkunPage extends StatelessWidget {
//   const AkunPage({super.key});

//   // Fungsi build untuk membangun tampilan halaman
//   @override
//   Widget build(BuildContext context) {
//     // Mendapatkan instance dari AuthenticationController
//     final authenticationController = Get.find<AuthenticationController>();

//     // Mengembalikan widget Scaffold sebagai struktur dasar halaman
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Akun",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 24),
//           // Widget CircleAvatar untuk menampilkan avatar pengguna
//           CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.grey[300],
//             child: const Icon(Icons.person, size: 50, color: Colors.white),
//           ),
//           const SizedBox(height: 12),
//           // Menampilkan nama pengguna
//           Text(
//             namaPengguna,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           // Menampilkan email pengguna
//           Text(emailPengguna, style: const TextStyle(color: Colors.grey)),
//           const SizedBox(height: 24),
//           const Divider(),
//           // ListTile untuk opsi logout
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text("Keluar", style: TextStyle(color: Colors.red)),
//             onTap: () async {
//               // Memanggil fungsi logout dari controller
//               await authenticationController.logout();
//               // Navigasi ke halaman login
//               Get.offAllNamed('/login');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
