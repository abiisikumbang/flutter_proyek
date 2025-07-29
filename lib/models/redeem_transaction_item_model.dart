import 'package:flutter_cbt_tpa_app/models/reward_item.dart';

class RedeemTransactionItemModel {
  final int id;
  final int redeemId;
  final int rewardId;
  final int quantity;
  final int pointSpentPerItem;
  final RewardItem reward;

  RedeemTransactionItemModel({
    required this.id,
    required this.redeemId,
    required this.rewardId,
    required this.quantity,
    required this.pointSpentPerItem,
    required this.reward,
  });

  factory RedeemTransactionItemModel.fromJson(Map<String, dynamic> json) {
    return RedeemTransactionItemModel(
      id: json['id'],
      redeemId: json['reward_redeem_id'],
      rewardId: json['stock_id'],
      quantity: json['quantity'],
      pointSpentPerItem: json['point_spent_per_item'],
      reward: RewardItem.fromJson(json['stock']),
    );
  }

  int get subtotalPoint => quantity * pointSpentPerItem;
}
