import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart';
import 'package:flutter_cbt_tpa_app/models/sell_transaction_model.dart';
import 'package:flutter_cbt_tpa_app/pages/history_sell_detail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class HistorySellPage extends StatefulWidget {
  const HistorySellPage({super.key});

  @override
  HistorySellPageState createState() => HistorySellPageState();
}

class HistorySellPageState extends State<HistorySellPage>
    with WidgetsBindingObserver {
  List<SellTransactionModel> _allTransactions = [];
  List<SellTransactionModel> _filteredTransactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
    _fetchTransactions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchTransactions();
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

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
        Uri.parse('$baseUrl/api/sell/history'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> transactionListJson =
            json.decode(response.body)['data'];
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
          _errorMessage = 'Gagal memuat transaksi: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan jaringan: $e';
      });
    }
  }

  void _onSearchChanged() {
    _filterTransactions();
  }

  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions =
          _allTransactions.where((transaction) {
            final invoiceId =
                'ID-${transaction.id.toString().padLeft(3, '0')}'.toLowerCase();
            final status = transaction.status.toLowerCase();
            return invoiceId.contains(query) || status.contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
                        'Tidak ada transaksi ditemukan.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: _fetchTransactions,
                      // Buat ListView.builder untuk menampilkan daftar transaksi
                      child: ListView.builder(
                        // Jumlah item dalam daftar adalah jumlah transaksi yang sudah difilter
                        itemCount: _filteredTransactions.length,
                        // Fungsi untuk membangun setiap item dalam daftar
                        itemBuilder: (context, index) {
                          // Ambil transaksi berdasarkan indeks
                          final transaction = _filteredTransactions[index];
                          // Format tanggal transaksi
                          final formattedDate = DateFormat('dd MMMM yyyy').format(transaction.createdAt);

                          // Kembalikan widget ListTile untuk setiap transaksi
                          return ListTile(
                            // Saat item ditekan, navigasi ke halaman detail transaksi
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HistorySellDetailPage(
                                    transactionId: transaction.id,
                                  ),
                                ),
                              );
                            },
                            // Tampilkan ID transaksi sebagai judul
                            title: Text('ID-${transaction.id.toString().padLeft(3, '0')}'),
                            // Tampilkan tanggal transaksi sebagai subjudul
                            subtitle: Text(formattedDate),
                            // Tampilkan poin dan status transaksi di sebelah kanan
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Tampilkan total poin yang diperoleh dari transaksi
                                Text(
                                  '+ ${transaction.getTotalPoints().toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                // Tampilkan status transaksi dengan warna sesuai status
                                Text(
                                  transaction.status,
                                  style: TextStyle(
                                    color: ColorStatus.getColor(transaction.status),
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
