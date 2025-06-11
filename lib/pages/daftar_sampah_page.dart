// lib/pages/daftar_sampah_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart'; // Import SampahItemModel
import 'package:flutter_cbt_tpa_app/pages/jual_sampah_page.dart'; // Import JualSampahPage

/// Halaman untuk menampilkan daftar jenis sampah yang tersedia untuk dijual.
class DaftarSampahPage extends StatefulWidget {
  final List<SampahItemModel>? initialCartItems;

  const DaftarSampahPage({super.key, this.initialCartItems});

  @override
  State<DaftarSampahPage> createState() => _DaftarSampahPageState();
}

class _DaftarSampahPageState extends State<DaftarSampahPage> {
  final List<SampahItemModel> _availableSampah = [
    SampahItemModel(img: 'images/plastik.png', title: 'Plastik', price: 'Rp 1.500/kg'),
    SampahItemModel(img: 'images/kertas.png', title: 'Kertas', price: 'Rp 1.000/kg'),
    SampahItemModel(img: 'images/logam.png', title: 'Logam', price: 'Rp 3.500/kg'),
  ];

  List<SampahItemModel> _cartItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCartItems != null) {
      _cartItems = List.from(widget.initialCartItems!);
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
          price: item.price,
          quantity: 1,
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            double totalHarga = 0.0;
            for (var item in _cartItems) {
              totalHarga += item.pricePerKg * item.quantity;
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
                            subtitle: Text('Harga: ${item.price} | Jumlah: ${item.quantity}'),
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
                        "Total Harga:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rp${totalHarga.toStringAsFixed(0)}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
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
                              Navigator.pop(context, _cartItems);
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
        child: Column(
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
        subtitle: Text(item.price),
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