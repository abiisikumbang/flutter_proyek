import 'dart:convert';
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cbt_tpa_app/models/reward_item.dart';

Future<List<RewardItem>> fetchRewardItems(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/rewards'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final List<dynamic> data =
        responseData['data']; // ambil data dari key 'data'
    return data.map((item) => RewardItem.fromJson(item)).toList();
  } else {
    throw Exception('Gagal mengambil data reward');
  }
}
