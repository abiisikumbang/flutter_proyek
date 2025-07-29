class RewardItem {
  final int id;
  final String name;
  final int pointValue;
  final int stock;
  final String image;
  int quantity = 1; // Tambahkan properti quantity

  RewardItem({
    required this.id,
    required this.name,
    required this.pointValue,
    required this.stock,
    required this.image,
    this.quantity = 1,
  });

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id'] ?? 0, // fallback ke 0 jika null
      name: json['name'] ?? '',
      pointValue: json['point_cost'] ?? 0,
      stock: json['stock'] ?? 0,
      image: json['image'] ?? '',
      quantity:1, // fallback ke 1 jika null
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'point_cost': pointValue,
      'stock': stock,
      'image': image,

    };
  }
  RewardItem copyWith({
    int? id,
    String? name,
    int? pointValue,
    int? stock,
    String? image,
    int? quantity,
  }) {
    return RewardItem(
      id: id ?? this.id,
      name: name ?? this.name,
      pointValue: pointValue ?? this.pointValue,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }
  static RewardItem empty() {
    return RewardItem(
      id: 0,
      name: '',
      pointValue: 0,
      stock: 0,
      image: '',
      quantity: 0,
    );
  }
}
