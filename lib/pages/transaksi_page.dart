import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
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
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari Invoice Transaksi",
                filled: true,
                fillColor: Theme.of(context).primaryColorLight,
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
                dummyTransactions.isEmpty
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/no_transaction.png',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Tidak ada transaksi ditemukan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Saat ini tidak ada transaksi. Mulai transaksi sekarang.",
                        ),
                      ],
                    )
                    : ListView.builder(
                      itemCount: dummyTransactions.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final tx = dummyTransactions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              tx['invoice']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(tx['tanggal']!),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  tx['jumlah']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tx['status']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        tx['status'] == 'Selesai'
                                            ? Colors.green
                                            : tx['status'] == 'Menunggu'
                                            ? Colors.orange
                                            : Colors.red,
                                  ),
                                ),
                              ],
                            ),
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
