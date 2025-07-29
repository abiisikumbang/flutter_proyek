// lib/models/sampah_item.dart

final String baseUrl =
    'http://10.221.156.6:8000';

class SampahItemModel {
  final int id;
  final String name;
  final String imageUrl;
  final int points;
  final String satuan;
  int quantity;

  SampahItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.points,
    required this.satuan,
    this.quantity = 1,
  });

  factory SampahItemModel.fromJson(Map<String, dynamic> json) {

     final imageUrl = json['image'];
  final fullImageUrl = imageUrl.startsWith('http')
      ? imageUrl
      : '$baseUrl/storage/$imageUrl';


    return SampahItemModel(
      id: json['id'],
      name: json['name'],
      imageUrl: fullImageUrl,
      satuan: json['satuan'],
      points: json['point_value'],
      quantity: 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'satuan': satuan,
      'point_value': points,
    };
  }

  SampahItemModel copyWith({
    int? id,
    String? name,
    String? imageUrl,
    int? points,
    String? satuan,
    int? quantity,
  }) {
    return SampahItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      points: points ?? this.points,
      satuan: satuan ?? this.satuan,
      quantity: quantity ?? this.quantity,
    );
  }

  static SampahItemModel empty() {
    return SampahItemModel(
      id: 0,
      imageUrl: '',
      name: '',
      satuan: '',
      quantity: 0,
      points: 0,
    );
  }
}

