import 'package:flutter_cbt_tpa_app/models/redeem_transaction_item_model.dart';

class RedeemTransactionModel {
  final int id;
  final int userId;
  final String status;
  final DateTime createdAt;
  final List<RedeemTransactionItemModel> items;

  RedeemTransactionModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory RedeemTransactionModel.fromJson(Map<String, dynamic> json) {
    return RedeemTransactionModel(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items:
          (json['redeem_items'] as List<dynamic>)
              .map((e) => RedeemTransactionItemModel.fromJson(e))
              .toList(),
    );
  }

  int getTotalPoints() {
    return items.fold(0, (sum, item) => sum + item.subtotalPoint);
  }
}
