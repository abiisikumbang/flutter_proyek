// lib/pages/daftar_sampah_page.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart';
import 'package:flutter_cbt_tpa_app/pages/jual_sampah_page.dart';
import 'package:http/http.dart' as http show get;
import 'package:logger/logger.dart';

/// Halaman untuk menampilkan daftar jenis sampah yang tersedia untuk dijual.
class DaftarSampahPage extends StatefulWidget {
  final List<SampahItemModel>? initialCartItems;

  const DaftarSampahPage({super.key, this.initialCartItems});

  @override
  State<DaftarSampahPage> createState() => _DaftarSampahPageState();
}
class _DaftarSampahPageState extends State<DaftarSampahPage> {
  final logger = Logger();
  List<SampahItemModel> _availableSampah = [];
  List<SampahItemModel> _cartItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final String baseUrl = "http://192.168.123.6:8000";

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.initialCartItems ?? []);
    _fetchAvailableSampah();
  }
  Future<void> _fetchAvailableSampah() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
  
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/wastes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          List<SampahItemModel> fetchedItems = (responseData['data'] as List)
              .map((itemJson) => SampahItemModel.fromJson(itemJson))
              .toList();

          setState(() {
            _availableSampah = fetchedItems;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = responseData['message'] ?? 'gagal memuat data';
            _isLoading = false;
          });
        }
      } else {
         setState(() {
          _errorMessage = 'Gagal memuat data sampah. Status: ${response.statusCode}';
          _isLoading = false;
        });
        logger.e('API Error: ${response.statusCode} - ${response.body}');
      }
    }  catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan jaringan: $e';
        _isLoading = false;
      });
      logger.e('Network Error: $e');
    }
  }
  void _addToCart(SampahItemModel item) {
    setState(() {
      final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.title == item.title);

      if (existingItemIndex != -1) {
        _cartItems[existingItemIndex].quantity++;
      } else {
        _cartItems.add(SampahItemModel(
          img: item.img,
          title: item.title,
          satuan: item.satuan,
          quantity: 1, id: '1', points: item.points
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.title} ditambahkan ke keranjang.')),
      );
    });
  }

  void _viewCart() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Membuat state yang dapat diubah dalam bottom sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            double totalHarga = 0.0;
            // Menghitung total harga dari semua item di keranjang
            for (var item in _cartItems) {
              totalHarga += item.points * item.quantity;
            }

            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Keranjang Anda",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  if (_cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text("Keranjang kosong.")),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return ListTile(
                            leading: Image.asset(item.img, width: 40),
                            title: Text(item.title),
                            subtitle: Text('Harga: ${item.points} | Jumlah: ${item.quantity}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
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
                          );
                        },
                      ),
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Point:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        totalHarga.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _cartItems.isEmpty
                        ? null
                        : () {
                          Navigator.pop(context);
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JualSampahPage(cartItems: _cartItems),
                          ),
                          );
                        },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Lanjutkan", style: TextStyle(fontSize: 16)),
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
        backgroundColor: AppColors.primary,
        title: const Text(
          "Daftar Sampah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, _cartItems);
          },
        ) : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pilih Jenis Sampah",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _availableSampah.length,
                          itemBuilder: (context, index) {
                            final item = _availableSampah[index];
                            return _sampahItem(context, item);
                          },
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: _cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _viewCart,
              label: Text('${_cartItems.length} Item', style: const TextStyle(color: Colors.white)),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              backgroundColor: AppColors.primary,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _sampahItem(BuildContext context, SampahItemModel item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Image.asset(item.img, width: 48),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.satuan),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            _addToCart(item);
          },
          child: const Text("Tambah", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}