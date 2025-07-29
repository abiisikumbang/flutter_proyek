import 'dart:convert'; // Import package untuk encoding dan decoding JSON
// import 'package:controller/controller.dart' as response show body;
import 'package:flutter/material.dart'; // Import package material untuk Flutter
import 'package:flutter_cbt_tpa_app/controller/reward_item_controller.dart'; // Import controller untuk item reward
import 'package:flutter_cbt_tpa_app/material.dart'; // Import custom material
import 'package:flutter_cbt_tpa_app/models/reward_item.dart'; // Import model RewardItem
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart'; // Import model SampahItem
import 'package:shared_preferences/shared_preferences.dart'; // Import untuk penyimpanan lokal
import 'package:http/http.dart' as http; // Import package untuk HTTP request
import 'package:collection/collection.dart'; // Import collection utilities

// Halaman untuk menukar poin dengan hadiah
class RedeemPage extends StatefulWidget {
  const RedeemPage({super.key}); // Konstruktor

  @override
  State<RedeemPage> createState() => _RedeemPageState(); // Membuat state
}

// State dari RedeemPage
class _RedeemPageState extends State<RedeemPage> {
  final List<RewardItem> _cartRewards = []; // Daftar hadiah dalam keranjang
  late Future<List<RewardItem>> _futureRewards; // Daftar hadiah tersedia

  @override
  void initState() {
    super.initState();
    _loadRewards(); // Memuat hadiah saat inisialisasi
  }

  // Memuat daftar hadiah dari server
  Future<void> _loadRewards() async {
    final prefs = await SharedPreferences.getInstance(); // Dapatkan prefs
    final token = prefs.getString('token') ?? ''; // Ambil token
    setState(() {
      _futureRewards = fetchRewardItems(token); // Fetch hadiah
    });
  }

  // Fungsi untuk menukar poin dengan hadiah
  Future<void> _onRedeem() async {
    if (_cartRewards.isEmpty) {
      // Jika keranjang kosong
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keranjang hadiah kosong')));
      return;
    }
    if (_cartRewards.any((r) => r.quantity <= 0)) {
      // Jika ada hadiah dengan jumlah <= 0
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah hadiah harus lebih dari 0')),
      );
      return;
    }

    final requestBody = {
      "items":
          _cartRewards
              .map((r) => {"stock_id": r.id, "quantity": r.quantity})
              .toList(), // Buat request body
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: CircularProgressIndicator(),
          ), // Tampilkan loading
    );

    try {
      final prefs = await SharedPreferences.getInstance(); // Dapatkan prefs
      final String? token = prefs.getString('token'); // Ambil token
      if (token == null || token.isEmpty) {
        if (mounted) {
          Navigator.of(context).pop(); // Kembali dari loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token tidak ditemukan, silakan login ulang'),
            ),
          );
        }
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/rewards/redeem'), // URL endpoint
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody), // Kirim request
      );
      if (mounted) {
        Navigator.of(context).pop(); // Kembali dari loading
      }
      if (response.statusCode == 200) {
        // Jika berhasil
        if (mounted) {
          setState(() {
            _cartRewards.clear(); // Kosongkan keranjang
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Tukar poin berhasil!')));
        }
      } else {
        // Gagal → Ambil pesan error dari body
        final Map<String, dynamic> errorBody = jsonDecode(
          response.body.toString(),
        );
        final String errorMessage = errorBody['error'] ?? 'Tukar poin gagal.';

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Kembali dari loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        ); // Tampilkan error
      }
    }
  }

  // Tampilkan keranjang
  void _viewCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            int totalPointValue = _cartRewards.fold(
              0,
              (sum, r) =>
                  sum + (r.pointValue * r.quantity), // Hitung total poin
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Keranjang Hadiah',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  _cartRewards.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.remove_shopping_cart,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Keranjang kosong',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _cartRewards.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final reward = _cartRewards[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              reward.image.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      reward.image,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => const Icon(
                                            Icons.broken_image,
                                            size: 32,
                                          ),
                                    ),
                                  )
                                  : const Icon(Icons.card_giftcard, size: 48),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reward.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Poin: ${reward.pointValue}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (reward.quantity > 1) {
                                          _cartRewards[index] = reward.copyWith(
                                            quantity: reward.quantity - 1,
                                          ); // Kurangi jumlah
                                        } else {
                                          _cartRewards.removeAt(
                                            index,
                                          ); // Hapus dari keranjang
                                        }
                                      });
                                      setModalState(() {});
                                    },
                                  ),
                                  Text(
                                    '${reward.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _cartRewards[index] = reward.copyWith(
                                          quantity: reward.quantity + 1,
                                        ); // Tambah jumlah
                                      });
                                      setModalState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Poin:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$totalPointValue',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _cartRewards.isEmpty
                              ? null
                              : () async {
                                Navigator.pop(context);
                                await _onRedeem(); // Proses redeem
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Tukar Poin',
                        style: TextStyle(fontSize: 16),
                      ),
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

  // Mendapatkan jumlah item tertentu dalam keranjang
  int _getQuantityFor(int id) {
    return _cartRewards
            .firstWhereOrNull((reward) => reward.id == id)
            ?.quantity ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Tukar Poin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _viewCart, // Tampilkan keranjang
          ),
        ],
      ),
      body: FutureBuilder<List<RewardItem>>(
        future: _futureRewards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // Loading
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Tampilkan error
            );
          }
          final rewards = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: rewards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 250,
              ),
              itemBuilder: (context, index) {
                final reward = rewards[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                reward.image.isNotEmpty
                                    ? Image.network(
                                      reward.image,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => const Icon(
                                            Icons.broken_image,
                                            size: 80,
                                          ),
                                      loadingBuilder:
                                          (context, child, loadingProgress) =>
                                              loadingProgress == null
                                                  ? child
                                                  : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                    )
                                    : const Icon(Icons.card_giftcard, size: 80),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          reward.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Butuh ${reward.pointValue} poin",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  final existingIndex = _cartRewards.indexWhere(
                                    (r) => r.id == reward.id,
                                  );
                                  if (existingIndex != -1) {
                                    final current = _cartRewards[existingIndex];
                                    if (current.quantity > 1) {
                                      _cartRewards[existingIndex] = current
                                          .copyWith(
                                            quantity: current.quantity - 1,
                                          ); // Kurangi jumlah
                                    } else {
                                      _cartRewards.removeAt(
                                        existingIndex,
                                      ); // Hapus dari keranjang
                                    }
                                  }
                                });
                              },
                            ),
                            Text(
                              '${_getQuantityFor(reward.id)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                setState(() {
                                  final existingIndex = _cartRewards.indexWhere(
                                    (r) => r.id == reward.id,
                                  );
                                  if (existingIndex != -1) {
                                    final updated = _cartRewards[existingIndex]
                                        .copyWith(
                                          quantity:
                                              _cartRewards[existingIndex]
                                                  .quantity +
                                              1,
                                        ); // Tambah jumlah
                                    _cartRewards[existingIndex] = updated;
                                  } else {
                                    _cartRewards.add(
                                      reward.copyWith(
                                        quantity: 1,
                                      ), // Tambah ke keranjang
                                    );
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton:
          _cartRewards.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: _viewCart, // Tampilkan keranjang
                backgroundColor: AppColors.primary,
                icon: const Icon(Icons.shopping_cart_checkout),
                label: Text(
                  'Keranjang(${_cartRewards.length})', // Tampilkan jumlah item di keranjang
                ),
              )
              : null,
    );
  }
}
