// lib/pages/daftar_sampah_page.dart

import 'dart:convert'; // Import untuk konversi JSON

import 'package:flutter/material.dart'; // Import package material Flutter
import 'package:flutter_cbt_tpa_app/material.dart'; // Import custom material (AppColors)
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart'; // Import model SampahItemModel
import 'package:flutter_cbt_tpa_app/pages/jual_sampah_page.dart'; // Import halaman JualSampahPage
import 'package:http/http.dart' as http show get; // Import package http untuk request
import 'package:logger/logger.dart'; // Import package logger
import 'package:shared_preferences/shared_preferences.dart'; // Import untuk SharedPreferences

/// Halaman untuk menampilkan daftar jenis sampah yang tersedia untuk dijual.
class DaftarSampahPage extends StatefulWidget { // Kelas StatefulWidget DaftarSampahPage
  final List<SampahItemModel>? initialCartItems; // Daftar awal item di keranjang

  const DaftarSampahPage({super.key, this.initialCartItems}); // Konstruktor

  @override
  State<DaftarSampahPage> createState() => _DaftarSampahPageState(); // Membuat state
}

class _DaftarSampahPageState extends State<DaftarSampahPage> { // State untuk DaftarSampahPage
  final logger = Logger(); // Logger untuk mencetak pesan log
  List<SampahItemModel> _availableSampah = []; // Daftar sampah yang tersedia
  List<SampahItemModel> _cartItems = []; // Daftar item di keranjang
  bool _isLoading = true; // Status pemuatan data
  String _errorMessage = ''; // Pesan kesalahan

  // Pastikan baseUrl ini sesuai dengan IP Laravel Anda, terutama jika menggunakan Flutter Web
  final String baseUrl = "http://192.168.123.6:8000"; // URL dasar API

  @override
  void initState() { // Inisialisasi state
    super.initState(); // Panggil initState parent
    _cartItems = List.from(widget.initialCartItems ?? []); // Salin item keranjang dari widget
    _fetchAvailableSampah(); // Panggil fungsi untuk memuat sampah yang tersedia
  }

  Future<void> _fetchAvailableSampah() async { // Fungsi untuk memuat sampah yang tersedia
    setState(() { // Update state
      _isLoading = true; // Set status pemuatan data
      _errorMessage = ''; // Reset pesan kesalahan
    });

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Ambil token dari SharedPreferences

    if (token == null || token.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Autentikasi diperlukan. Silakan login kembali.';
      });
      // Opsional: Arahkan pengguna ke halaman login jika token tidak ada
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/wastes'), // Kirim request GET ke API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Header konten JSON
          'Accept': 'application/json', // Header penerimaan JSON
          'Authorization': 'Bearer $token', // PENTING: Menambahkan header Authorization
        },
      );

      if (response.statusCode == 200) { // Jika status code 200
        final Map<String, dynamic> responseData = jsonDecode(response.body); // Decode JSON
        
        // Memastikan struktur respons sesuai dengan yang dikirim WasteController@index
        // WasteController@index sekarang mengembalikan {'data': [...]}
        if (responseData['data'] != null) { 
          List<SampahItemModel> fetchedItems = (responseData['data'] as List)
              .map((itemJson) => SampahItemModel.fromJson(itemJson)) // Konversi JSON ke model
              .toList();

          setState(() { // Update state
            _availableSampah = fetchedItems; // Set daftar sampah yang tersedia
            _isLoading = false; // Set status pemuatan selesai
          });
        } else {
          // Tangani kasus di mana 'data' null atau struktur tidak sesuai
          setState(() {
            _errorMessage = 'Gagal memuat data sampah. Struktur respons tidak sesuai.'; 
            _isLoading = false;
          });
          logger.e('API Error: Invalid response structure - ${response.body}');
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Sesi Anda telah berakhir. Mohon login ulang.';
          _isLoading = false;
        });
        logger.e('API Error 401: Unauthorized - ${response.body}');
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data sampah. Status: ${response.statusCode}'; // Set pesan kesalahan
          _isLoading = false; // Set status pemuatan selesai
        });
        logger.e('API Error: ${response.statusCode} - ${response.body}'); // Log error
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan jaringan: $e'; // Set pesan kesalahan jaringan
        _isLoading = false; // Set status pemuatan selesai
      });
      logger.e('Network Error: $e'); // Log error jaringan
    }
  }

  void _addToCart(SampahItemModel item) { // Fungsi untuk menambah item ke keranjang
    setState(() { // Update state
      final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.title == item.title); // Cek item sudah ada di keranjang

      if (existingItemIndex != -1) { // Jika sudah ada
        _cartItems[existingItemIndex].quantity++; // Tambah jumlah item
      } else {
        // PENTING: Pastikan item.id ada. SampahItemModel harus memiliki ID yang valid dari API.
        _cartItems.add(SampahItemModel( // Tambah item ke keranjang
          id: item.id, // Gunakan ID asli dari item yang ditambahkan
          img: item.img, // Gunakan gambar asli dari item
          title: item.title,
          satuan: item.satuan,
          quantity: 1,
          points: item.points
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.title} ditambahkan ke keranjang.')), // Tampilkan snackbar
      );
    });
  }

  void _viewCart() { // Fungsi untuk melihat keranjang
    showModalBottomSheet( // Tampilkan bottom sheet
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Buat state di dalam bottom sheet
          builder: (BuildContext context, StateSetter modalSetState) {
            double totalHarga = 0.0; // Inisialisasi total harga
            for (var item in _cartItems) { // Hitung total harga semua item di keranjang
              totalHarga += item.points * item.quantity; // Kalikan harga dengan jumlah
            }

            return Container( // Buat kontainer
              padding: const EdgeInsets.all(16), // Set padding
              child: Column(
                mainAxisSize: MainAxisSize.min, // Set ukuran kolom
                crossAxisAlignment: CrossAxisAlignment.start, // Set posisi silang
                children: [
                  const Text(
                    "Keranjang Anda", // Tampilkan judul
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Set gaya teks
                  ),
                  const Divider(), // Garis pembatas
                  if (_cartItems.isEmpty) // Jika keranjang kosong
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text("Keranjang kosong.")), // Tampilkan pesan keranjang kosong
                    )
                  else
                    Flexible( // Jika ada item
                      child: ListView.builder( // Buat daftar item
                        shrinkWrap: true,
                        itemCount: _cartItems.length, // Set jumlah item
                        itemBuilder: (context, index) {
                          final item = _cartItems[index]; // Ambil item
                          return ListTile( // Tampilkan item
                            leading: item.img.isNotEmpty
                                ? Image.asset(item.img, width: 40, errorBuilder: (c,e,s) => const Icon(Icons.broken_image))
                                : const Icon(Icons.image, size: 40), // Gambar item atau placeholder
                            title: Text(item.title), // Judul item
                            subtitle: Text('Point: ${item.points} | Jumlah: ${item.quantity} Kg'), // Detail item
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red), // Ikon hapus
                              onPressed: () {
                                modalSetState(() { // Update state
                                  if (item.quantity > 1) { // Jika jumlah > 1
                                    item.quantity--; // Kurangi jumlah
                                  } else {
                                    _cartItems.removeAt(index); // Hapus item dari keranjang
                                  }
                                  setState(() {}); // Panggil setState global untuk refresh FAB
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const Divider(), // Garis pembatas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Set posisi
                    children: [
                      const Text(
                        "Total Point:", // Tampilkan total poin
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Set gaya teks
                      ),
                      Text(
                        totalHarga.toStringAsFixed(0), // Tampilkan total harga
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary), // Set gaya teks
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Ukuran kotak
                  SizedBox(
                    width: double.infinity, // Lebar penuh
                    child: ElevatedButton(
                      onPressed: _cartItems.isEmpty
                          ? null
                          : () {
                                Navigator.pop(context); // Tutup bottom sheet
                                Navigator.push( // Navigasi ke halaman JualSampahPage
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JualSampahPage(cartItems: _cartItems), // Kirim item keranjang
                                  ),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Set warna background
                        foregroundColor: Colors.white, // Set warna teks
                        padding: const EdgeInsets.symmetric(vertical: 12), // Set padding
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Set bentuk
                      ),
                      child: const Text("Lanjutkan", style: TextStyle(fontSize: 16)), // Teks tombol
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) { // Fungsi build untuk membangun tampilan halaman
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary, // Set warna background
        title: const Text(
          "Daftar Sampah", // Judul halaman
          style: TextStyle(fontWeight: FontWeight.bold), // Set gaya teks
        ),
        foregroundColor: Colors.white, // Set warna teks
        leading: Navigator.canPop(context) // Tombol kembali jika bisa pop
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali
                onPressed: () {
                  Navigator.pop(context, _cartItems); // Kembali ke halaman sebelumnya
                },
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), // Set padding
        child: _isLoading // Jika sedang memuat
            ? const Center(child: CircularProgressIndicator()) // Tampilkan progress indicator
            : _errorMessage.isNotEmpty // Jika ada pesan kesalahan
                ? Center(
                    child: Text(
                      _errorMessage, // Tampilkan pesan kesalahan
                      style: const TextStyle(color: Colors.red, fontSize: 16), // Set gaya teks
                      textAlign: TextAlign.center, // Set posisi teks
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Set posisi silang
                    children: [
                      const Text(
                        "Pilih Jenis Sampah", // Judul
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Set gaya teks
                      ),
                      const SizedBox(height: 16), // Ukuran kotak
                      Expanded(
                        child: ListView.builder( // Buat daftar sampah
                          itemCount: _availableSampah.length, // Set jumlah item
                          itemBuilder: (context, index) {
                            final item = _availableSampah[index]; // Ambil item
                            return _sampahItem(context, item); // Tampilkan item
                          },
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: _cartItems.isNotEmpty // Jika keranjang tidak kosong
          ? FloatingActionButton.extended(
              onPressed: _viewCart, // Tampilkan keranjang
              label: Text('${_cartItems.length} Item', style: const TextStyle(color: Colors.white)), // Jumlah item di keranjang
              icon: const Icon(Icons.shopping_cart, color: Colors.white), // Ikon keranjang
              backgroundColor: AppColors.primary, // Set warna background
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Posisi tombol
    );
  }

  Widget _sampahItem(BuildContext context, SampahItemModel item) { // Widget untuk item sampah
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Set bentuk
      margin: const EdgeInsets.only(bottom: 16), // Set margin
      child: ListTile(
        contentPadding: const EdgeInsets.all(12), // Set padding
        // PENTING: Pastikan item.img valid dan bukan null saat digunakan dengan Image.asset
        leading: item.img.isNotEmpty
            ? Image.asset(item.img, width: 48, errorBuilder: (c,o,s) => const Icon(Icons.broken_image, size: 48, color: Colors.grey))
            : const Icon(Icons.image_not_supported, size: 48, color: Colors.grey), // Placeholder jika img kosong
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)), // Judul item
        subtitle: Text(item.satuan), // Satuan item
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary), // Set gaya tombol
          onPressed: () {
            _addToCart(item); // Tambah item ke keranjang
          },
          child: const Text("Tambah", style: TextStyle(color: Colors.white)), // Teks tombol
        ),
      ),
    );
  }
}


// // lib/pages/daftar_sampah_page.dart

// import 'dart:convert'; // Import untuk konversi JSON

// import 'package:flutter/material.dart'; // Import package material Flutter
// import 'package:flutter_cbt_tpa_app/material.dart'; // Import custom material (AppColors)
// import 'package:flutter_cbt_tpa_app/models/sampah_item.dart'; // Import model SampahItemModel
// import 'package:flutter_cbt_tpa_app/pages/jual_sampah_page.dart'; // Import halaman JualSampahPage
// import 'package:http/http.dart' as http show get; // Import package http untuk request
// import 'package:logger/logger.dart'; // Import package logger

// /// Halaman untuk menampilkan daftar jenis sampah yang tersedia untuk dijual.
// class DaftarSampahPage extends StatefulWidget { // Kelas StatefulWidget DaftarSampahPage
//   final List<SampahItemModel>? initialCartItems; // Daftar awal item di keranjang

//   const DaftarSampahPage({super.key, this.initialCartItems}); // Konstruktor

//   @override
//   State<DaftarSampahPage> createState() => _DaftarSampahPageState(); // Membuat state
// }

// class _DaftarSampahPageState extends State<DaftarSampahPage> { // State untuk DaftarSampahPage
//   final logger = Logger(); // Logger untuk mencetak pesan log
//   List<SampahItemModel> _availableSampah = []; // Daftar sampah yang tersedia
//   List<SampahItemModel> _cartItems = []; // Daftar item di keranjang
//   bool _isLoading = true; // Status pemuatan data
//   String _errorMessage = ''; // Pesan kesalahan

//   final String baseUrl = "http://192.168.123.6:8000"; // URL dasar API

//   @override
//   void initState() { // Inisialisasi state
//     super.initState(); // Panggil initState parent
//     _cartItems = List.from(widget.initialCartItems ?? []); // Salin item keranjang dari widget
//     _fetchAvailableSampah(); // Panggil fungsi untuk memuat sampah yang tersedia
//   }

//   Future<void> _fetchAvailableSampah() async { // Fungsi untuk memuat sampah yang tersedia
//     setState(() { // Update state
//       _isLoading = true; // Set status pemuatan data
//       _errorMessage = ''; // Reset pesan kesalahan
//     });

    

//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/api/wastes'), // Kirim request GET ke API
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8', // Header konten JSON
//           'Accept': 'application/json', // Header penerimaan JSON
//         },
//       );

//       if (response.statusCode == 200) { // Jika status code 200
//         final Map<String, dynamic> responseData = jsonDecode(response.body); // Decode JSON
//         if (responseData['status'] == 'success' && responseData['data'] != null) { // Jika data sukses
//           List<SampahItemModel> fetchedItems = (responseData['data'] as List)
//               .map((itemJson) => SampahItemModel.fromJson(itemJson)) // Konversi JSON ke model
//               .toList();

//           setState(() { // Update state
//             _availableSampah = fetchedItems; // Set daftar sampah yang tersedia
//             _isLoading = false; // Set status pemuatan selesai
//           });
//         } else {
//           setState(() {
//             _errorMessage = responseData['message'] ?? 'gagal memuat data'; // Set pesan kesalahan
//             _isLoading = false; // Set status pemuatan selesai
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'Gagal memuat data sampah. Status: ${response.statusCode}'; // Set pesan kesalahan
//           _isLoading = false; // Set status pemuatan selesai
//         });
//         logger.e('API Error: ${response.statusCode} - ${response.body}'); // Log error
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Terjadi kesalahan jaringan: $e'; // Set pesan kesalahan jaringan
//         _isLoading = false; // Set status pemuatan selesai
//       });
//       logger.e('Network Error: $e'); // Log error jaringan
//     }
//   }

//   void _addToCart(SampahItemModel item) { // Fungsi untuk menambah item ke keranjang
//     setState(() { // Update state
//       final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.title == item.title); // Cek item sudah ada di keranjang

//       if (existingItemIndex != -1) { // Jika sudah ada
//         _cartItems[existingItemIndex].quantity++; // Tambah jumlah item
//       } else {
//         _cartItems.add(SampahItemModel( // Tambah item ke keranjang
//           img: item.img,
//           title: item.title,
//           satuan: item.satuan,
//           quantity: 1, id: '1', points: item.points // Set detail item
//         ));
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('${item.title} ditambahkan ke keranjang.')), // Tampilkan snackbar
//       );
//     });
//   }

//   void _viewCart() { // Fungsi untuk melihat keranjang
//     showModalBottomSheet( // Tampilkan bottom sheet
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder( // Buat state di dalam bottom sheet
//           builder: (BuildContext context, StateSetter modalSetState) {
//             double totalHarga = 0.0; // Inisialisasi total harga
//             for (var item in _cartItems) { // Hitung total harga semua item di keranjang
//               totalHarga += item.points * item.quantity; // Kalikan harga dengan jumlah
//             }

//             return Container( // Buat kontainer
//               padding: const EdgeInsets.all(16), // Set padding
//               child: Column(
//                 mainAxisSize: MainAxisSize.min, // Set ukuran kolom
//                 crossAxisAlignment: CrossAxisAlignment.start, // Set posisi silang
//                 children: [
//                   const Text(
//                     "Keranjang Anda", // Tampilkan judul
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Set gaya teks
//                   ),
//                   const Divider(), // Garis pembatas
//                   if (_cartItems.isEmpty) // Jika keranjang kosong
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 20),
//                       child: Center(child: Text("Keranjang kosong.")), // Tampilkan pesan keranjang kosong
//                     )
//                   else
//                     Flexible( // Jika ada item
//                       child: ListView.builder( // Buat daftar item
//                         shrinkWrap: true,
//                         itemCount: _cartItems.length, // Set jumlah item
//                         itemBuilder: (context, index) {
//                           final item = _cartItems[index]; // Ambil item
//                           return ListTile( // Tampilkan item
//                             leading: Image.asset(item.img, width: 40), // Gambar item
//                             title: Text(item.title), // Judul item
//                             subtitle: Text('Harga: ${item.points} | Jumlah: ${item.quantity}'), // Detail item
//                             trailing: IconButton(
//                               icon: const Icon(Icons.remove_circle, color: Colors.red), // Ikon hapus
//                               onPressed: () {
//                                 modalSetState(() { // Update state
//                                   if (item.quantity > 1) { // Jika jumlah > 1
//                                     item.quantity--; // Kurangi jumlah
//                                   } else {
//                                     _cartItems.removeAt(index); // Hapus item dari keranjang
//                                   }
//                                   setState(() {}); // Set state
//                                 });
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   const Divider(), // Garis pembatas
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween, // Set posisi
//                     children: [
//                       const Text(
//                         "Total Point:", // Tampilkan total poin
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Set gaya teks
//                       ),
//                       Text(
//                         totalHarga.toStringAsFixed(0), // Tampilkan total harga
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary), // Set gaya teks
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10), // Ukuran kotak
//                   SizedBox(
//                     width: double.infinity, // Lebar penuh
//                     child: ElevatedButton(
//                       onPressed: _cartItems.isEmpty
//                           ? null
//                           : () {
//                               Navigator.pop(context); // Tutup bottom sheet
//                               Navigator.push( // Navigasi ke halaman JualSampahPage
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => JualSampahPage(cartItems: _cartItems), // Kirim item keranjang
//                                 ),
//                               );
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary, // Set warna background
//                         foregroundColor: Colors.white, // Set warna teks
//                         padding: const EdgeInsets.symmetric(vertical: 12), // Set padding
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Set bentuk
//                       ),
//                       child: const Text("Lanjutkan", style: TextStyle(fontSize: 16)), // Teks tombol
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) { // Fungsi build untuk membangun tampilan halaman
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary, // Set warna background
//         title: const Text(
//           "Daftar Sampah", // Judul halaman
//           style: TextStyle(fontWeight: FontWeight.bold), // Set gaya teks
//         ),
//         foregroundColor: Colors.white, // Set warna teks
//         leading: Navigator.canPop(context) // Tombol kembali jika bisa pop
//             ? IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali
//                 onPressed: () {
//                   Navigator.pop(context, _cartItems); // Kembali ke halaman sebelumnya
//                 },
//               )
//             : null,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16), // Set padding
//         child: _isLoading // Jika sedang memuat
//             ? const Center(child: CircularProgressIndicator()) // Tampilkan progress indicator
//             : _errorMessage.isNotEmpty // Jika ada pesan kesalahan
//                 ? Center(
//                     child: Text(
//                       _errorMessage, // Tampilkan pesan kesalahan
//                       style: const TextStyle(color: Colors.red, fontSize: 16), // Set gaya teks
//                       textAlign: TextAlign.center, // Set posisi teks
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start, // Set posisi silang
//                     children: [
//                       const Text(
//                         "Pilih Jenis Sampah", // Judul
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Set gaya teks
//                       ),
//                       const SizedBox(height: 16), // Ukuran kotak
//                       Expanded(
//                         child: ListView.builder( // Buat daftar sampah
//                           itemCount: _availableSampah.length, // Set jumlah item
//                           itemBuilder: (context, index) {
//                             final item = _availableSampah[index]; // Ambil item
//                             return _sampahItem(context, item); // Tampilkan item
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//       ),
//       floatingActionButton: _cartItems.isNotEmpty // Jika keranjang tidak kosong
//           ? FloatingActionButton.extended(
//               onPressed: _viewCart, // Tampilkan keranjang
//               label: Text('${_cartItems.length} Item', style: const TextStyle(color: Colors.white)), // Jumlah item di keranjang
//               icon: const Icon(Icons.shopping_cart, color: Colors.white), // Ikon keranjang
//               backgroundColor: AppColors.primary, // Set warna background
//             )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Posisi tombol
//     );
//   }

//   Widget _sampahItem(BuildContext context, SampahItemModel item) { // Widget untuk item sampah
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Set bentuk
//       margin: const EdgeInsets.only(bottom: 16), // Set margin
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(12), // Set padding
//         leading: Image.asset(item.img, width: 48), // Gambar item
//         title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)), // Judul item
//         subtitle: Text(item.satuan), // Satuan item
//         trailing: ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary), // Set gaya tombol
//           onPressed: () {
//             _addToCart(item); // Tambah item ke keranjang
//           },
//           child: const Text("Tambah", style: TextStyle(color: Colors.white)), // Teks tombol
//         ),
//       ),
//     );
//   }
// }
