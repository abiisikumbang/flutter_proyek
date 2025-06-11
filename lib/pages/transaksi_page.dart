import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

// Halaman untuk menampilkan daftar transaksi
class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  TransaksiPageState createState() => TransaksiPageState();
}

// Daftar transaksi dummy
final List<Map<String, String>> dummyTransactions = const [
  {
    'invoice': '#INV-001',
    'tanggal': '8 Mei 2025',
    'jumlah': 'Rp 25.000',
    'status': 'Selesai',
  },
  {
    'invoice': '#INV-002',
    'tanggal': '7 Mei 2025',
    'jumlah': 'Rp 15.000',
    'status': 'Menunggu',
  },
  {
    'invoice': '#INV-003',
    'tanggal': '5 Mei 2025',
    'jumlah': 'Rp 30.000',
    'status': 'Dibatalkan',
  },
];
class TransaksiPageState extends State<TransaksiPage> {
  // State untuk filter yang dipilih
  String _selectedFilter = 'Semua';

  // Daftar transaksi yang akan ditampilkan
  List<Map<String, String>> _filteredTransactions = [];
  // Menyimpan semua transaksi asli
  List<Map<String, String>> _allTransactions = [];

  // Untuk search
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize transactions
    _allTransactions = List<Map<String, String>>.from(dummyTransactions);
    _filteredTransactions = List<Map<String, String>>.from(_allTransactions);
    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengubah filter
  void _onSearchChanged() {
    _filterTransactions();
  }

  // Fungsi untuk filter transaksi berdasarkan search query
  void _filterTransactions() {
    // Mendapatkan query dari search controller
    String query = _searchController.text.toLowerCase();
    // Menggunakan setState untuk mengubah daftar transaksi yang ditampilkan
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        // Mencocokkan query dengan invoice dan status transaksi
        final invoice = transaction['invoice']?.toLowerCase() ?? '';
        final status = transaction['status'] ?? '';
        final matchesQuery = invoice.contains(query);
        final matchesFilter = _selectedFilter == 'Semua' || status == _selectedFilter;
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol filter
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
                _filterTransactions();
              });
            },
            itemBuilder: (context) => [
              // Opsi filter
              const PopupMenuItem(
                value: 'Semua',
                child: Text('Semua'),
              ),
              const PopupMenuItem(
                value: 'Selesai',
                child: Text('Selesai'),
              ),
              const PopupMenuItem(
                value: 'Menunggu',
                child: Text('Menunggu'),
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
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari Invoice Transaksi",
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
            child: ListView.builder(
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _filteredTransactions[index];
                return ListTile(
                  title: Text(transaction['invoice'] ?? ''),
                  subtitle: Text(transaction['tanggal'] ?? ''),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Jumlah transaksi
                      Text(transaction['jumlah'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      // Status transaksi
                      Text(transaction['status'] ?? '', style: TextStyle(
                        color: transaction['status'] == 'Selesai'
                            ? Colors.green
                            : transaction['status'] == 'Menunggu'
                                ? Colors.orange
                                : Colors.red,
                      )),
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

