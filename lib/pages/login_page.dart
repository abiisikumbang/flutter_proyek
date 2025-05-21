// Halaman login, berisi form email dan password, serta tombol login
import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_cbt_tpa_app/controller/authentication_controller.dart';

class LoginPage extends StatefulWidget {
  // final AuthenticationController authController = Get.find();
  final authController = Get.put(AuthenticationController());
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengatur input email dan password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Controller untuk mengatur proses autentikasi
  // final _authenticationController = Get.put(authenticationController());
  // Variabel untuk mengatur apakah password ditampilkan atau disembunyikan
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // Ukuran lebar layar
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(255, 248, 133, 9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo bangJaki
              Image.asset(
                'lib/images/logo_bangJAKI.png',
                width: size * 0.500,
                height: size * 0.500,
              ),
              const SizedBox(height: 30),
              // Form email
              InputWidget(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
                textStyle: GoogleFonts.poppins(
                  fontSize: size * 0.040,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Form password
              InputWidget(
                hintText: 'Password',
                obscureText: _obscurePassword,
                controller: _passwordController,
                textStyle: GoogleFonts.poppins(
                  fontSize: size * 0.040,
                  color: Colors.black,
                ),
                // Tombol untuk mengatur apakah password ditampilkan atau disembunyikan
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Tombol login
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  onPressed:
                      widget.authController.isLoading.value
                          ? null // tombol disable saat loading
                          : () async {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Email dan Password wajib diisi",
                              );
                              return;
                            }
                            await widget.authController.login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          },
                  child:
                      widget.authController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.blue)
                          : Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: size * 0.040,
                              color: Color.fromARGB(255, 248, 133, 9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     elevation: 0,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 50,
              //       vertical: 15,
              //     ),
              //   ),
              //   onPressed: () async {
              //     if (_emailController.text.isEmpty ||
              //         _passwordController.text.isEmpty) {
              //       Get.snackbar("Error", "Email dan Password wajib diisi");
              //       return;
              //     }
              //     // Proses autentikasi
              //     await widget.authController.login(
              //       email: _emailController.text.trim(),
              //       password: _passwordController.text.trim(),
              //     );
              //   },
              //   child: Obx(() {
              //     // Jika sedang dalam proses autentikasi, maka tampilkan loading indicator
              //     return widget.authController.isLoading.value
              //         ? const CircularProgressIndicator(color: Colors.blue)
              //         : Text(
              //           'Login',
              //           style: GoogleFonts.poppins(
              //             fontSize: size * 0.040,
              //             color: Color.fromARGB(255, 248, 133, 9),
              //             fontWeight: FontWeight.bold,
              //           ),
              //         );
              //   }),
              // ),
              // const SizedBox(height: 20),
              // Tombol register
              TextButton(
                onPressed: () {
                  Get.to(() => RegisterPage());
                },
                child: Text(
                  'Register',
                  style: GoogleFonts.poppins(
                    fontSize: size * 0.040,
                    color: Colors.white,
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

// Widget untuk menampilkan form input
class InputWidget extends StatelessWidget {
  // Text hint untuk input
  final String hintText;
  // Apakah input harus disembunyikan atau tidak
  final bool obscureText;
  // Controller untuk mengatur input
  final TextEditingController controller;
  // Gaya font untuk input
  final TextStyle textStyle;
  // Widget untuk menampilkan icon di sebelah kanan input
  final Widget? suffixIcon;

  const InputWidget({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.textStyle,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyle,
        suffixIcon: suffixIcon,
      ),
      style: textStyle,
    );
  }
}
