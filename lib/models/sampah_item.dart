// lib/models/sampah_item.dart

class SampahItemModel {
  final String img;
  final String title;
  final String price;
  int quantity;

  SampahItemModel({
    required this.img,
    required this.title,
    required this.price,
    this.quantity = 0,
  });

  double get pricePerKg {
    final numericString = price.replaceAll(RegExp(r'[^0-9,]'), '');
    final cleanedString = numericString.replaceAll(',', '.');
    return double.tryParse(cleanedString) ?? 0.0;
  }
}