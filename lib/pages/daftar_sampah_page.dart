import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart';
import 'package:flutter_cbt_tpa_app/pages/jual_sampah_page.dart';
import 'package:http/http.dart' as http show get;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Halaman untuk menampilkan daftar jenis sampah yang tersedia untuk dijual.
class DaftarSampahPage extends StatefulWidget {
  // Kelas StatefulWidget DaftarSampahPage
  final List<SampahItemModel>?
  initialCartItems; // Daftar awal item di keranjang
  const DaftarSampahPage({super.key, this.initialCartItems}); // Konstruktor

  @override
  State<DaftarSampahPage> createState() => _DaftarSampahPageState(); // Membuat state
}

class _DaftarSampahPageState extends State<DaftarSampahPage> {
  // State untuk DaftarSampahPage
  final logger = Logger(); // Logger untuk mencetak pesan log
  List<SampahItemModel> _availableSampah = []; // Daftar sampah yang tersedia
  List<SampahItemModel> _cartItems = []; // Daftar item di keranjang
  bool _isLoading = true; // Status pemuatan data
  String _errorMessage = ''; // Pesan kesalahan

  // Pastikan baseUrl ini sesuai dengan IP Laravel Anda, terutama jika menggunakan Flutter Web

  @override
  void initState() {
    // Inisialisasi state
    super.initState(); // Panggil initState parent
    _cartItems = List.from(
      widget.initialCartItems ?? [],
    ); // Salin item keranjang dari widget
    _fetchAvailableSampah(); // Panggil fungsi untuk memuat sampah yang tersedia
  }

  Future<void> _fetchAvailableSampah() async {
    // Fungsi untuk memuat sampah yang tersedia
    setState(() {
      // Update state
      _isLoading = true; // Set status pemuatan data
      _errorMessage = ''; // Reset pesan kesalahan
    });
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Autentikasi diperlukan. Silakan login kembali.';
      });
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/wastes'), // Kirim request GET ke API
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', // Header konten JSON
          'Accept': 'application/json', // Header penerimaan JSON
          'Authorization': 'Bearer $token', // Menambahkan header Authorization
        },
      );

      if (response.statusCode == 200) {
        // Jika status code 200
        final Map<String, dynamic> responseData = jsonDecode(
          response.body,
        ); // Decode JSON
        if (responseData['data'] != null) {
          List<SampahItemModel> fetchedItems =
              (responseData['data'] as List)
                  .map(
                    (itemJson) => SampahItemModel.fromJson(itemJson),
                  ) // Konversi JSON ke model
                  .toList();

          setState(() {
            // Update state
            _availableSampah = fetchedItems; // Set daftar sampah yang tersedia
            _isLoading = false; // Set status pemuatan selesai
          });
        } else {
          // Tangani kasus di mana 'data' null atau struktur tidak sesuai
          setState(() {
            _errorMessage =
                'Gagal memuat data sampah. Struktur respons tidak sesuai.';
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
          _errorMessage =
              'Gagal memuat data sampah. Status: ${response.statusCode}'; // Set pesan kesalahan
          _isLoading = false; // Set status pemuatan selesai
        });
        logger.e(
          'API Error: ${response.statusCode} - ${response.body}',
        ); // Log error
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Terjadi kesalahan jaringan: $e'; // Set pesan kesalahan jaringan
        _isLoading = false; // Set status pemuatan selesai
      });
      logger.e('Network Error: $e'); // Log error jaringan
    }
  }

  void _addToCart(SampahItemModel item) {
    // Fungsi untuk menambah item ke keranjang
    setState(() {
      // Update state
      final existingItemIndex = _cartItems.indexWhere(
        (cartItem) => cartItem.name == item.name,
      ); // Cek item sudah ada di keranjang

      if (existingItemIndex != -1) {
        // Jika sudah ada
        _cartItems[existingItemIndex].quantity++; // Tambah jumlah item
      } else {
        // Tambahkan item ke keranjang menggunakan copyWith
        _cartItems.add(item.copyWith(quantity: 1));
      }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('${item.name} ditambahkan ke keranjang.'),
      //   ), // Tampilkan snackbar
      // );
    });
  }

  void _viewCart() {
    // Fungsi untuk melihat keranjang
    showModalBottomSheet(
      // Tampilkan bottom sheet
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Buat state di dalam bottom sheet
          builder: (BuildContext context, StateSetter modalSetState) {
            double totalHarga = 0.0; // Inisialisasi total harga
            for (var item in _cartItems) {
              // Hitung total harga semua item di keranjang
              totalHarga +=
                  item.points * item.quantity; // Kalikan harga dengan jumlah
            }

            return Container(
              // Buat kontainer
              padding: const EdgeInsets.all(16), // Set padding
              child: Column(
                mainAxisSize: MainAxisSize.min, // Set ukuran kolom
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Set posisi silang
                children: [
                  const Text(
                    "Keranjang Anda", // Tampilkan judul
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ), // Set gaya teks
                  ),
                  const Divider(), // Garis pembatas
                  if (_cartItems.isEmpty) // Jika keranjang kosong
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text("Keranjang kosong."),
                      ), // Tampilkan pesan keranjang kosong
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      // Jika ada item
                      child: ListView.builder(
                        // Buat daftar item
                        shrinkWrap: true,
                        itemCount: _cartItems.length, // Set jumlah item
                        itemBuilder: (context, index) {
                          final item = _cartItems[index]; // Ambil item
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  item.imageUrl.isNotEmpty
                                      ? Image.network(
                                        item.imageUrl,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 32,
                                            color: Colors.grey,
                                          );
                                        },
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                      : const Icon(
                                        Icons.image,
                                        size: 32,
                                        color: Colors.grey,
                                      ),
                              // Gambar item sampah
                            ),
                            title: Text(item.name),
                            subtitle: Text(
                              'Point: ${item.points} | Jumlah: ${item.quantity} ${item.satuan}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tombol kurang untuk mengurangi jumlah item
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    // Kurangi jumlah item jika lebih dari 1
                                    // Jika tidak, maka hapus item dari cart
                                    modalSetState(() {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                      } else {
                                        _cartItems.removeAt(index);
                                      }
                                      setState(() {});
                                    });
                                  },
                                ),
                                // Tampilkan jumlah item
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Tombol tambah untuk menambah jumlah item
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    // Tambah jumlah item
                                    modalSetState(() {
                                      item.quantity++;
                                      setState(() {});
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const Divider(), // Garis pembatas
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Set posisi
                    children: [
                      const Text(
                        "Total Point:", // Tampilkan total poin
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ), // Set gaya teks
                      ),
                      Text(
                        totalHarga.toStringAsFixed(0), // Tampilkan total harga
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ), // Set gaya teks
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Ukuran kotak
                  SizedBox(
                    width: double.infinity, // Lebar penuh
                    child: ElevatedButton(
                      onPressed:
                          _cartItems.isEmpty
                              ? null
                              : () {
                                Navigator.pop(context); // Tutup bottom sheet
                                Navigator.push(
                                  // Navigasi ke halaman JualSampahPage
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => JualSampahPage(
                                          cartItems: _cartItems,
                                        ), // Kirim item keranjang
                                  ),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary, // Set warna background
                        foregroundColor: Colors.white, // Set warna teks
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ), // Set padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ), // Set bentuk
                      ),
                      child: const Text(
                        "Lanjutkan",
                        style: TextStyle(fontSize: 16),
                      ), // Teks tombol
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary, // Set warna background
        foregroundColor: Colors.white, // Set warna teks
        title: const Text(
          "Daftar Sampah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.shopping_cart),
        //     onPressed: _viewCart,
        //   ),
        // ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: _availableSampah.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75, // Rasio aspek untuk item grid
                    mainAxisExtent: 250, // Tinggi tetap untuk setiap item
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = _availableSampah[index];
                    final inCart = _cartItems.firstWhere(
                      (cartItem) => cartItem.id == item.id,
                      orElse: () => SampahItemModel.empty(),
                    );
                    final quantity = inCart.quantity;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    item.imageUrl.isNotEmpty
                                        ? Image.network(
                                          item.imageUrl,
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            logger.e(
                                              'Image load error: $error',
                                            );
                                            return const Icon(
                                              Icons.broken_image,
                                              size: 80,
                                            );
                                          },
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        )
                                        : const Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Point: ${item.points}/${item.satuan}",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 10),
                            // Membuat row yang berisi 3 buah icon button
                            // yaitu tombol kurang, jumlah, dan tombol tambah
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Tombol untuk mengurangi jumlah item
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      quantity > 0
                                          ? () {
                                            // Membuat state untuk mengurangi jumlah item
                                            setState(() {
                                              final index = _cartItems
                                                  .indexWhere(
                                                    (c) => c.id == item.id,
                                                  );
                                              if (index != -1) {
                                                if (_cartItems[index].quantity >
                                                    1) {
                                                  // Mengurangi jumlah item
                                                  _cartItems[index].quantity--;
                                                } else {
                                                  // Menghapus item dari list
                                                  _cartItems.removeAt(index);
                                                }
                                              }
                                            });
                                          }
                                          : null,
                                ),
                                // Membuat text untuk menampilkan jumlah item
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Tombol untuk menambah jumlah item
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => _addToCart(item),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton:
          _cartItems.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: _viewCart,
                icon: const Icon(Icons.shopping_cart_checkout),
                label: Text('Keranjang (${_cartItems.length})'),
                backgroundColor: AppColors.primary,
              )
              : null,
    );
  }
}
