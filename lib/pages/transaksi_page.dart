import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/pages/history_redeem.dart';
import 'package:flutter_cbt_tpa_app/pages/history_sell.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Riwayat Transaksi",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('Jual')),
              Tab(child: Text('Redeem')),
            ],
            labelColor: Color.fromARGB(255, 0, 0, 0),
            unselectedLabelColor: Color.fromARGB(255, 255, 255, 255),
            indicatorColor: Color.fromARGB(255, 255, 255, 255),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.0,
          ),
        ),
        body: const TabBarView(
          children: [HistorySellPage(), HistoryRedeemPage()],
        ),
      ),
    );
  }
}
