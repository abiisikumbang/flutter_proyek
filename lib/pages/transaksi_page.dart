import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart'; // Untuk AppColors
import 'package:http/http.dart' as http; // Untuk HTTP request
import 'dart:convert'; // Untuk JSON decoding
import 'package:shared_preferences/shared_preferences.dart'; // Untuk token
import 'package:intl/intl.dart'; // Untuk formatting tanggal
// Import model yang baru dibuat
import 'package:flutter_cbt_tpa_app/models/sell_transaction_model.dart';
import 'package:flutter_cbt_tpa_app/pages/transaksi_detail_page.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  TransaksiPageState createState() => TransaksiPageState();
}

class TransaksiPageState extends State<TransaksiPage>
    with WidgetsBindingObserver {
  List<SellTransactionModel> _allTransactions = [];
  List<SellTransactionModel> _filteredTransactions = [];

  // Flag untuk mengetahui apakah sedang dalam proses loading transaksi
  bool _isLoading = true;

  // Pesan error yang akan ditampilkan jika terjadi kesalahan
  String? _errorMessage;

  // Filter yang sedang dipilih user
  String _selectedFilter = 'Semua';

  // Text controller untuk input pencarian
  final TextEditingController _searchController = TextEditingController();

  // Base URL API
  final String baseUrl = "http://192.168.145.6:8000";

  // Lifecycle method untuk mengetahui kapan aplikasi berpindah
  // dari foreground ke background dan sebaliknya
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
    _fetchTransactions();
  }

  // Lifecycle method untuk menghapus observer dan text controller
  // ketika page ini dihapus
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Lifecycle method untuk mengetahui kapan aplikasi berpindah
  // dari foreground ke background dan sebaliknya
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchTransactions();
    }
  }

  // Fungsi untuk mengambil token dari SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fungsi untuk mengambil daftar transaksi dari API
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
      // Melakukan request GET ke API untuk mengambil daftar transaksi
      final response = await http.get(
        Uri.parse('$baseUrl/api/sell/history'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        // Meng-decode JSON response menjadi List<SellTransactionModel>
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> transactionListJson = responseData['data'];

        setState(() {
          _allTransactions =
              transactionListJson
                  .map(
                    (json) => SellTransactionModel.fromJson(
                      json as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          _filterTransactions();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Gagal memuat transaksi: ${response.statusCode} - ${response.body}';
        });
        // Use logging framework instead of print
        // ignore: avoid_print
        debugPrint(
          'Failed to load transactions: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      setState(() {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan jaringan: $e';
      });
      // Use logging framework instead of print
      debugPrint('Network error fetching transactions: $e');
    }
  }

  // Fungsi untuk meng-update filter transaksi ketika user mengetik
  // di text field pencarian
  void _onSearchChanged() {
    _filterTransactions();
  }

  // Fungsi untuk meng-update filter transaksi berdasarkan input user
  void _filterTransactions() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions =
          _allTransactions.where((transaction) {
            final invoiceId =
                'ID-${transaction.id.toString().padLeft(3, '0')}'.toLowerCase();
            final status = transaction.status.toLowerCase();

            final matchesQuery =
                invoiceId.contains(query) || status.contains(query);
            final matchesFilter =
                _selectedFilter == 'Semua' ||
                status == _selectedFilter.toLowerCase().replaceAll(' ', '');

            return matchesQuery && matchesFilter;
          }).toList();
    });
  }

  // Fungsi untuk meng-return warna berdasarkan status transaksi
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu konfirmasi':
        return Colors.orange;
      case 'dijemput':
        return Colors.blue;
      case 'diproses':
        return Colors.purple;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Build method untuk membuat UI
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
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'Semua', child: Text('Semua')),
                  const PopupMenuItem(value: 'Selesai', child: Text('Selesai')),
                  const PopupMenuItem(
                    value: 'Menunggu Konfirmasi',
                    child: Text('Menunggu Konfirmasi'),
                  ),
                  const PopupMenuItem(
                    value: 'Dijemput',
                    child: Text('Dijemput'),
                  ),
                  const PopupMenuItem(
                    value: 'Diproses',
                    child: Text('Diproses'),
                  ),
                  const PopupMenuItem(
                    value: 'Dibatalkan',
                    child: Text('Dibatalkan'),
                  ),
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
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
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
                    : RefreshIndicator(
                      onRefresh: _fetchTransactions,
                      child: ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _filteredTransactions[index];
                          final formattedDate = DateFormat(
                            'dd MMMM yyyy',
                          ).format(transaction.createdAt);

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => TransaksiDetailPage(
                                        transactionId: transaction.id,
                                      ),
                                ),
                              );
                            },
                            title: Text(
                              'ID-${transaction.id.toString().padLeft(3, '0')}',
                            ),
                            subtitle: Text(formattedDate),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '+ ${transaction.getTotalPoints().toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  transaction.status,
                                  style: TextStyle(
                                    color: _getStatusColor(transaction.status),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
