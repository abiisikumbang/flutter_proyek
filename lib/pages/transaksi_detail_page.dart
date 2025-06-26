import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
// import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Halaman detail transaksi
class TransaksiDetailPage extends StatefulWidget {
  // Menerima id transaksi dari parent
  final int transactionId;
  const TransaksiDetailPage({super.key, required this.transactionId});
  @override
  State<TransaksiDetailPage> createState() => _TransaksiDetailPageState();
}

class _TransaksiDetailPageState extends State<TransaksiDetailPage> {
  // Data transaksi yang diambil dari API
  Map<String, dynamic>? transactionData;
  // Status loading
  bool _isLoading = true;
  // Pesan error jika terjadi kesalahan
  String? _errorMessage;
  // URL base API
  final String baseUrl = "http://192.168.145.6:8000";

  // Fungsi untuk mengambil token dari SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fungsi untuk mengambil detail transaksi dari API
  Future<void> fetchTransactionDetail() async {
    // Membaca token dari SharedPreferences
    final token = await _getToken();
    // Jika token tidak ada, maka munculkan pesan error
    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Autentikasi gagal. Silakan login ulang.";
      });
      return;
    }
    try {
      // Mengirim request GET ke API untuk mengambil detail transaksi
      final response = await http.get(
        Uri.parse('$baseUrl/api/sell/history/${widget.transactionId}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      // Jika status code 200, maka data transaksi berhasil diambil
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          transactionData = data;
          _isLoading = false;
        });
      } else {
        // Jika status code bukan 200, maka munculkan pesan error
        setState(() {
          _errorMessage = "Gagal memuat data: ${response.body}";
          _isLoading = false;
        });
      }
    } catch (e) {
      // Jika terjadi kesalahan, maka munculkan pesan error
      setState(() {
        _errorMessage = "Terjadi kesalahan: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil detail transaksi
    fetchTransactionDetail();
  }

  @override
  Widget build(BuildContext context) {
    // Jika status loading, maka tampilkan CircularProgressIndicator
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Jika terjadi kesalahan, maka tampilkan pesan error
    if (_errorMessage != null) {
      return Scaffold(body: Center(child: Text(_errorMessage!)));
    }

    // Ambil data transaksi
    final items = transactionData!['items'] as List<dynamic>;
    final totalPoint = transactionData!['total_point'];
    final tanggal = transactionData!['date'];
    final idTransaksi = transactionData!['id'];

    // Tampilkan halaman detail transaksi

    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Detail Transaksi",
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
        // Tampilkan ID transaksi
        Text(
          "ID Transaksi: ID-${idTransaksi.toString().padLeft(3, '0')}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Tampilkan tanggal transaksi
        Text("Tanggal: $tanggal", style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        // Tampilkan judul daftar sampah
        const Text(
          "Daftar Sampah:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Tampilkan daftar sampah dalam bentuk tabel
        Container(
          decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
          ),
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: WidgetStateProperty.all(
              AppColors.primary.withValues(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1),
            ),
          columns: const [
            DataColumn(label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Point', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: items.map((item) {
            final name = item['name']?.toString() ?? '-';
            final point = item['point_value'] ?? 0;
            final qty = item['quantity'] ?? 0;
            final subtotal = (point is int && qty is int) ? point * qty : 0;
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
            // Tampilkan total poin
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

