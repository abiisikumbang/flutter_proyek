import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/models/redeem_transaction_model.dart';
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart';
import 'package:flutter_cbt_tpa_app/pages/history_redeem_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRedeemPage extends StatefulWidget {
  const HistoryRedeemPage({super.key});

  @override
  State<HistoryRedeemPage> createState() => _HistoryRedeemPageState();
}

class _HistoryRedeemPageState extends State<HistoryRedeemPage> {
  List<RedeemTransactionModel> _allTransactions = [];
  List<RedeemTransactionModel> _filteredTransactions = [];

  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchRedeemTransactions();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchRedeemTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final token = await _getToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Autentikasi gagal. Silakan login ulang.';
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/rewards/history'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listJson = data['data'];

        setState(() {
          _allTransactions =
              listJson
                  .map((json) => RedeemTransactionModel.fromJson(json))
                  .toList();
          _filterTransactions();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Gagal memuat riwayat: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  void _onSearchChanged() => _filterTransactions();

  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions =
          _allTransactions.where((t) {
            final invoiceId =
                'RD-${t.id.toString().padLeft(3, '0')}'.toLowerCase();
            final status = t.status.toLowerCase();
            return invoiceId.contains(query) || status.contains(query);
          }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari ID Penukaran",
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
          // Daftar transaksi
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
                            onPressed: _fetchRedeemTransactions,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                    : _filteredTransactions.isEmpty
                    ? const Center(
                      child: Text(
                        'Tidak ada riwayat penukaran ditemukan.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: _fetchRedeemTransactions,
                      child: ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final t = _filteredTransactions[index];
                          final formattedDate =
                              t.createdAt.toLocal().toString().split(' ')[0];

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HistoryRedeemDetailPage(
                                    redeemId: t.id,
                                  ),
                                ),
                              );
                            },
                            title: Text(
                              'RD-${t.id.toString().padLeft(3, '0')}',
                            ),
                            subtitle: Text(formattedDate),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '- ${t.getTotalPoints()} poin',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  t.status,
                                  style: TextStyle(
                                    color: ColorStatus.getColor(t.status),
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
