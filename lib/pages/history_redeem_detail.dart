import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:flutter_cbt_tpa_app/models/redeem_transaction_item_model.dart'
    show RedeemTransactionItemModel;
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HistoryRedeemDetailPage extends StatefulWidget {
  final int redeemId;
  const HistoryRedeemDetailPage({super.key, required this.redeemId});

  @override
  State<HistoryRedeemDetailPage> createState() =>
      _HistoryRedeemDetailPageState();
}

class _HistoryRedeemDetailPageState extends State<HistoryRedeemDetailPage> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? transactionData;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _fetchRedeemDetail();
  }

  Future<void> _fetchRedeemDetail() async {
    final token = await _getToken();
    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Autentikasi gagal. Silakan login ulang.';
      });
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/rewards/history/${widget.redeemId}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          transactionData = data; // Ambil data['data'] langsung
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Gagal memuat detail: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(body: Center(child: Text(_errorMessage!)));
    }

    // Ambil data dari response API
    final data = transactionData!['data'];
    final itemsJson = data['redeem_items'] as List<dynamic>;
    final int totalPoint = data['total_points_spent'] ?? 0;
    final String tanggal = data['created_at'] ?? '-';
    final int idTransaksi = data['id'] ?? 0;

    // Parsing item ke model
    final items =
        itemsJson.map((e) => RedeemTransactionItemModel.fromJson(e)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Penukaran",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID Redeem
            Text(
              "ID Redeem: RD-${idTransaksi.toString().padLeft(3, '0')}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Tanggal
            Text(
              "Tanggal: ${DateFormat('y-M-d').format(DateTime.parse(tanggal))}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text(
              "Daftar Penukaran:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Tabel data penukaran
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: WidgetStateProperty.all(
                  AppColors.primary.withValues(
                    red: 0.1,
                    green: 0.1,
                    blue: 0.1,
                    alpha: 0.1,
                  ),
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Nama',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Point',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Qty',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Subtotal',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows:
                    items.map((item) {
                      final name = item.reward.name;
                      final point = item.pointSpentPerItem;
                      final qty = item.quantity;
                      final subtotal = point * qty;

                      return DataRow(
                        cells: [
                          DataCell(Text(name)),
                          DataCell(Text(point.toString())),
                          DataCell(Text(qty.toString())),
                          DataCell(Text(subtotal.toString())),
                        ],
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            const Divider(),

            // Total Poin
            Text(
              "Total Poin: $totalPoint",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
