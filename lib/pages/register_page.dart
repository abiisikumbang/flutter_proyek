import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cbt_tpa_app/controller/authentication_controller.dart';

// Halaman register untuk pengguna baru
class RegisterPage extends StatefulWidget {
  final authController = Get.put(AuthenticationController());
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form
  final _nameController =
      TextEditingController(); // Controller untuk input nama lengkap
  final _emailController =
      TextEditingController(); // Controller untuk input email
  final _phoneNumberController =
      TextEditingController(); // Controller untuk input nomor telepon
  final _passwordController =
      TextEditingController(); // Controller untuk input password
  bool _obscureText =
      true; // Status untuk menampilkan atau menyembunyikan password

  @override
  Widget build(BuildContext context) {
    // Membangun UI halaman register
    // Menghilangkan appBar dan menggunakan SafeArea agar form tampil full layar
    // return Scaffold(
    //   body: SafeArea(
    //     child: Container(
    //       width: double.infinity,
    //       height: double.infinity,
    //       padding: const EdgeInsets.all(16.0),
    //       decoration: const BoxDecoration(
    //         gradient: LinearGradient(
    //           colors: [Colors.white, Color.fromARGB(255, 248, 133, 9)],
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //         ),
    //       ),
    //       child: Form(
    //         key: _formKey,
    //         child: ListView(
    //           children: [
    //             const SizedBox(height: 16),
    //             // Input untuk nama lengkap
    //             TextFormField(
    //               controller: _fullNameController,
    //               decoration: InputDecoration(
    //                 labelText: 'Full Name',
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(16),
    //                 ),
    //               ),
    //               validator: (value) {
    //                 if (value == null || value.isEmpty) {
    //                   return 'Please enter your full name';
    //                 }
    //                 return null;
    //               },
    //             ),
    //             const SizedBox(height: 16),
    //             // Input untuk alamat email
    //             TextFormField(
    //               controller: _emailController,
    //               decoration: InputDecoration(
    //                 labelText: 'Email Address',
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(16),
    //                 ),
    //               ),
    //               validator: (value) {
    //                 if (value == null ||
    //                     value.isEmpty ||
    //                     !value.contains('@')) {
    //                   return 'Please enter a valid email address';
    //                 }
    //                 return null;
    //               },
    //             ),
    //             const SizedBox(height: 16),
    //             // Input untuk nomor telepon
    //             TextFormField(
    //               controller: _phoneNumberController,
    //               decoration: InputDecoration(
    //                 labelText: 'Phone Number',
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(16),
    //                 ),
    //               ),
    //               validator: (value) {
    //                 if (value == null || value.isEmpty || value.length != 10) {
    //                   return 'Please enter a valid phone number';
    //                 }
    //                 return null;
    //               },
    //             ),
    //             const SizedBox(height: 16),
    //             // Input untuk password
    //             TextFormField(
    //               controller: _passwordController,
    //               obscureText: _obscureText,
    //               decoration: InputDecoration(
    //                 labelText: 'Password',
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(16),
    //                 ),
    //                 suffixIcon: IconButton(
    //                   icon:
    //                       _obscureText
    //                           ? const Icon(Icons.visibility_off)
    //                           : const Icon(Icons.visibility),
    //                   onPressed: () {
    //                     setState(() {
    //                       _obscureText = !_obscureText;
    //                     });
    //                   },
    //                 ),
    //               ),
    //               validator: (value) {
    //                 if (value == null || value.isEmpty || value.length < 8) {
    //                   return 'Please enter a strong password';
    //                 }
    //                 return null;
    //               },
    //             ),
    //             const SizedBox(height: 16),
    //             // Tombol untuk melakukan registrasi
    //             ElevatedButton(
    //               onPressed: () {
    //                 if (_formKey.currentState!.validate()) {
    //                   AuthenticationController.register(
    //                     fullName: _fullNameController.text,
    //                     email: _emailController.text,
    //                     phoneNumber: _phoneNumberController.text,
    //                     password: _passwordController.text,
    //                   );
    //                 }
    //               },
    //               child: const Text('Register'),
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: const Color.fromARGB(255, 248, 133, 9),
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(16),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color.fromARGB(255, 248, 133, 9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 16),
                // Input untuk nama lengkap
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Input untuk alamat email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Input untuk nomor telepon
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Input untuk password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon:
                          _obscureText
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8) {
                      return 'Please enter a strong password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Tombol untuk melakukan registrasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180, // Lebar tombol diperkecil
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.authController.register(
                              name: _nameController.text,
                              email: _emailController.text,
                              phoneNumber: _phoneNumberController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            248,
                            133,
                            9,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }
}
