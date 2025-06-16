// lib/models/sell_transaction_model.dart
import 'package:flutter_cbt_tpa_app/models/sell_transaction_item_model.dart'; // Import item model

class SellTransactionModel {
  final int id;
  final int userId;
  final String address;
  final String phoneNumber;
  final DateTime pickupDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SellTransactionItemModel> items; // Ini yang kita gunakan

  SellTransactionModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.phoneNumber,
    required this.pickupDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory SellTransactionModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List<dynamic>?; // Gunakan List<dynamic>? untuk null safety
    List<SellTransactionItemModel> parsedItems = [];

    if (itemsList != null) {
      parsedItems = itemsList
          .map((i) => SellTransactionItemModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return SellTransactionModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      address: json['address'] as String,
      phoneNumber: json['phone_number'] as String,
      pickupDate: DateTime.parse(json['pickup_date'] as String), // YYYY-MM-DD
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String), // ISO 8601
      updatedAt: DateTime.parse(json['updated_at'] as String), // ISO 8601
      items: parsedItems,
    );
  }

  // Helper untuk menghitung total poin dari semua item dalam transaksi
  int getTotalPoints() {
    return items.fold(0, (sum, item) => sum + item.subtotalPoint);
  }
}