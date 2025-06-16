// lib/models/sell_transaction_item_model.dart
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart'; // Import model SampahItemModel

class SellTransactionItemModel {
  final int id;
  final int transactionId;
  final int wasteId;
  final int quantity;
  final int subtotalPoint;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SampahItemModel waste; // Relasi ke detail sampah

  SellTransactionItemModel({
    required this.id,
    required this.transactionId,
    required this.wasteId,
    required this.quantity,
    required this.subtotalPoint,
    required this.createdAt,
    required this.updatedAt,
    required this.waste,
  });

  factory SellTransactionItemModel.fromJson(Map<String, dynamic> json) {
    return SellTransactionItemModel(
      id: json['id'] as int,
      transactionId: json['transaction_id'] as int,
      wasteId: json['waste_id'] as int,
      quantity: json['quantity'] as int,
      subtotalPoint: json['subtotal_point'] as int, // Sesuaikan jika ini double di DB Anda
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      waste: SampahItemModel.fromJson(json['waste']), // Parsing nested 'waste' object
    );
  }
}