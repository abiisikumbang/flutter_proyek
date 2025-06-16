import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart'; // Untuk AppColors
import 'package:http/http.dart' as http; // Untuk HTTP request
import 'dart:convert'; // Untuk JSON decoding
import 'package:shared_preferences/shared_preferences.dart'; // Untuk token
import 'package:intl/intl.dart'; // Untuk formatting tanggal

// Import model yang baru dibuat
import 'package:flutter_cbt_tpa_app/models/sell_transaction_model.dart';
//import 'package:flutter_cbt_tpa_app/models/sell_transaction_item_model.dart'; // Jika dibutuhkan secara langsung

// Halaman untuk menampilkan daftar transaksi
class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  TransaksiPageState createState() => TransaksiPageState();
}

class TransaksiPageState extends State<TransaksiPage> with WidgetsBindingObserver {
  List<SellTransactionModel> _allTransactions = []; // Menyimpan semua data dari API
  List<SellTransactionModel> _filteredTransactions = []; // Data yang ditampilkan setelah filter/search
  
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  final String baseUrl = "http://192.168.123.6:8000";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Tambahkan observer untuk memantau siklus hidup widget
    _searchController.addListener(_onSearchChanged);
    _fetchTransactions(); // Panggil saat halaman pertama kali dimuat
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hapus observer
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Digunakan untuk BottomNavigationBar agar data refresh saat tab diaktifkan
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Aplikasi kembali dari background atau tab Transaksi diaktifkan
      _fetchTransactions();
    }
  }

  // Fungsi untuk mendapatkan token dari SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fungsi untuk mengambil data transaksi dari API
  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String? token = await _getToken();

    if (token == null || token.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Autentikasi diperlukan. Silakan login kembali.';
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/sell/history'), // Endpoint /api/sell
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Respon API Anda tidak memiliki key 'data' di level atas,
        // jadi kita asumsikan responsnya langsung array transaksi
        // Jika API Anda membungkus dalam 'data': final List<dynamic> transactionListJson = responseData['data'];
        final List<dynamic> transactionListJson = responseData['data']; // Sesuaikan jika API Anda tidak punya 'data'

        setState(() {
          _allTransactions = transactionListJson
              .map((json) => SellTransactionModel.fromJson(json as Map<String, dynamic>))
              .toList();
          _filterTransactions(); // Terapkan filter dan search setelah data dimuat
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat transaksi: ${response.statusCode} - ${response.body}';
        });
        print('Failed to load transactions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan jaringan: $e';
      });
      print('Network error fetching transactions: $e');
    }
  }

  // Fungsi untuk filter transaksi berdasarkan search query dan selected filter
  void _onSearchChanged() {
    _filterTransactions();
  }

  void _filterTransactions() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        final invoiceId = 'ID-${transaction.id.toString().padLeft(3, '0')}'.toLowerCase();
        final status = transaction.status.toLowerCase();

        final matchesQuery = invoiceId.contains(query) || status.contains(query);
        final matchesFilter = _selectedFilter == 'Semua' || status == _selectedFilter.toLowerCase().replaceAll(' ', ''); // Sesuaikan 'menunggu konfirmasi'

        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  // Helper untuk mendapatkan warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu konfirmasi': // Atau 'menunggu' jika itu yang Anda kirim
        return Colors.orange;
      case 'dijemput':
        return Colors.blue;
      case 'diproses':
        return Colors.purple;
      case 'selesai':
        return Colors.green;
      // case 'dibatalkan':
      //   return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
                _filterTransactions();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Semua', child: Text('Semua')),
              const PopupMenuItem(value: 'Selesai', child: Text('Selesai')),
              const PopupMenuItem(value: 'Menunggu Konfirmasi', child: Text('Menunggu Konfirmasi')), // Sesuaikan string status
              const PopupMenuItem(value: 'Dijemput', child: Text('Dijemput')),
              const PopupMenuItem(value: 'Diproses', child: Text('Diproses')),
              const PopupMenuItem(value: 'Dibatalkan', child: Text('Dibatalkan')),
            ],
          ),
        ],
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari ID Transaksi",
                filled: true,
                fillColor: AppColors.primary.withAlpha(50),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _fetchTransactions,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : _filteredTransactions.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada transaksi yang ditemukan.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction = _filteredTransactions[index];
                              // Format tanggal
                              final formattedDate = DateFormat('dd MMMM yyyy').format(transaction.createdAt);

                              return ListTile(
                                title: Text('ID-${transaction.id.toString().padLeft(3, '0')}'),
                                subtitle: Text(formattedDate),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '+ ${transaction.getTotalPoints().toStringAsFixed(0)}', // Gunakan total poin
                                      style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16, // Perbesar ukuran font
                                      ),
                                    ),
                                    Text(
                                      transaction.status,
                                      style: TextStyle(color: _getStatusColor(transaction.status)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}