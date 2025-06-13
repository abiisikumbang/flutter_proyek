// lib/models/sampah_item.dart

class SampahItemModel {
  final String id;
  final String title;
  final String img; // Asumsi ini masih diperlukan untuk tampilan, tapi sumbernya mungkin dari luar tabel wastes
  final String satuan;
  int quantity; // Quantity bisa diubah, jadi tidak perlu final
  final int points; // point_value di database adalah int

  SampahItemModel({
    required this.id,
    required this.img, // Tetap required jika memang selalu ada gambar
    required this.title,
    required this.satuan,
    this.quantity = 1, // Default value saat membuat instance
    required this.points,
  });

  factory SampahItemModel.fromJson(Map<String, dynamic> json) {
    // Pastikan 'id' di-konversi ke String karena di database adalah bigint
    // Jika respons API mengembalikan int, maka .toString() diperlukan
    final String idString = json['id'] != null ? json['id'].toString() : '';

    // Pastikan 'name' adalah String
    final String titleString = json['name'] as String? ?? 'Nama Sampah Tidak Diketahui';

    // Perhatikan kolom 'img' - ini tidak ada di tabel wastes.
    // Anda mungkin mendapatkan ini dari relasi lain, atau harus di-hardcode/default.
    // Untuk saat ini, saya akan biarkan seperti ini, dengan fallback.
    final String imgUrl = json['image_url'] as String? ?? 'assets/images/default_waste.png';

    // Pastikan 'satuan' adalah String
    final String satuanString = json['satuan'] as String? ?? 'unit'; // Sesuaikan dengan nama kolom 'satuan' di DB

    // Pastikan 'point_value' di-konversi ke int
    // Jika respons API mengembalikan double/string yang perlu di-parse, sesuaikan di sini.
    final int pointsInt = json['point_value'] as int? ?? 0;


    return SampahItemModel(
      id: idString,
      title: titleString,
      img: imgUrl,
      satuan: satuanString,
      points: pointsInt,
      quantity: 1, // Default quantity saat item dimuat dari API
    );
  }

  // Jika Anda perlu mengonversi model ke JSON untuk dikirim kembali ke API,
  // tambahkan metode toJson.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title, // Menggunakan 'name' agar sesuai dengan database
      'image_url': img, // Asumsi nama kolom di API untuk gambar
      'satuan': satuan,
      'point_value': points, // Menggunakan 'point_value' agar sesuai dengan database
      'quantity': quantity,
    };
  }
}