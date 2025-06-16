
import 'package:http/http.dart' as http; // Import package http untuk request
import 'dart:convert'; // Import package convert untuk JSON parsing
import 'package:flutter/material.dart'; // Import package material Flutter
import 'package:flutter_cbt_tpa_app/material.dart'; // Import custom material (AppColors)
import 'package:intl/intl.dart'; // Import package untuk formatting tanggal
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart'; // Import model SampahItemModel
import 'package:flutter_cbt_tpa_app/pages/daftar_sampah_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import halaman DaftarSampahPage
import 'package:logger/logger.dart';

final Logger logger = Logger();

/// Halaman untuk proses penjualan sampah (pengisian form).
class JualSampahPage extends StatefulWidget { // Widget stateful untuk halaman jual sampah
  final List<SampahItemModel>? cartItems; // Properti untuk menyimpan item keranjang
  const JualSampahPage({super.key, this.cartItems}); // Konstruktor dengan parameter opsional cartItems

  @override
  State<JualSampahPage> createState() => _JualSampahPageState(); // Membuat state
}

class _JualSampahPageState extends State<JualSampahPage> { // State dari JualSampahPage
  // Controllers untuk TextField
  final TextEditingController addressController = TextEditingController(); // Controller alamat penjemputan
  // ignore: non_constant_identifier_names
  final TextEditingController phone_numberController = TextEditingController(); // 
  final TextEditingController pickupDateController = TextEditingController(); // 

  double _totalPointKeranjang = 0.0; // Variabel untuk total point keranjang
  List<SampahItemModel> _currentCartItems = []; // Mengelola item keranjang di sini

  final String baseUrl = "http://192.168.123.6:8000";

  @override
  void initState() { // Inisialisasi state
    super.initState(); // Panggil initState parent
    _currentCartItems = List.from(widget.cartItems ?? []); // Salin item keranjang dari widget
    _calculateTotalPoint(); // Hitung total harga awal

  } 

  void _calculateTotalPoint() { // Fungsi untuk menghitung total point keranjang
    double total = 0.0; // Inisialisasi total
    for (var item in _currentCartItems) { // Loop setiap item di keranjang
      total += item.points * item.quantity; // Tambahkan point item ke total
    }
    setState(() { // Update state
      _totalPointKeranjang = total; // Set total point keranjang
    });
  }

  // Metode untuk menambah kuantitas item
  void _incrementQuantity(SampahItemModel item) { // Fungsi tambah kuantitas item
    setState(() { // Update state
      item.quantity++; // Tambah quantity 1
      _calculateTotalPoint(); // Hitung ulang total point
    });
  }

  // Metode untuk mengurangi kuantitas item
  void _decrementQuantity(SampahItemModel item) { // Fungsi kurang kuantitas item
    setState(() { // Update state
      if (item.quantity > 1) { // Jika quantity > 1
        item.quantity--; // Kurangi quantity
      } else { // Jika quantity 1
        // Hapus item dari keranjang jika kuantitasnya menjadi 0
        _currentCartItems.removeWhere((element) => element.title == item.title); // Hapus item dari list
      _calculateTotalPoint(); // Hitung ulang total point
      }
    });
  }

  // Metode untuk menghapus item sepenuhnya
  void _removeItem(SampahItemModel item) { // Fungsi hapus item dari keranjang
    setState(() { // Update state
      _currentCartItems.removeWhere((element) => element.title == item.title); // Hapus item dari list
      _calculateTotalPoint(); // Hitung ulang total point
      ScaffoldMessenger.of(context).showSnackBar( // Tampilkan snackbar notifikasi
        SnackBar(content: Text('${item.title} dihapus dari keranjang.')), // Pesan notifikasi
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async { // Fungsi untuk memilih tanggal penjemputan
    DateTime? picked = await showDatePicker( // Tampilkan date picker
      context: context, // Context
      initialDate: DateTime.now(), // Tanggal awal
      firstDate: DateTime.now(), // Tanggal awal minimum
      lastDate: DateTime(2030), // Tanggal akhir maksimum
    );
    if (picked != null) { // Jika tanggal dipilih
      setState(() { // Update state
        pickupDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  //fungsi untuk mengirim data ke API
  Future<void> _submitTransaction()  async {
    // buat validasi
    if (addressController.text.isEmpty || phone_numberController.text.isEmpty || pickupDateController.text.isEmpty || _currentCartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')), // Pesan error jika ada field kosong
      );
      return; // Keluar dari fungsi jika ada field kosong
    }


    // var data = {
    //   "alamat_penjemputan": _alamatPenjemputanController.text,
    //   "nomor_telepon": _nomorTeleponController.text,
    //   "tanggal_penjemputan": _tanggalPenjemputanController.text,
    //   "items": _currentCartItems.map((item) => {

    List<Map<String, dynamic>> wastesData = _currentCartItems.map((item) {
      return {
        'waste_id': item.id, // Pastikan SampahItemModel memiliki 'id'
        'quantity': item.quantity,
      };
    }).toList();

    // Tampilkan indikator loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Siapkan request body
    final Map<String, dynamic> requestBody = {
      "address": addressController.text,
      "phone_number": phone_numberController.text,
      "pickup_date": pickupDateController.text,
      "wastes": wastesData,
    };

    try {
      // Ambil token dari SharedPreferences setelah login
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token autentikasi tidak ditemukan. Silakan login ulang.')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/sell'), // Endpoint /api/sell
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Jika API Anda membutuhkan token autentikasi, tambahkan di sini:
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody), // Encode body menjadi JSON string
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // Tutup dialog loading

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil dikirim!')),
        );
        Navigator.pop(context, true);
      } else {
        // Jika gagal, tampilkan pesan error dari body respons
        debugPrint('Error API Response (Status: ${response.statusCode}): ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim transaksi: ${response.body}')),
        );
      }
    } catch (e) {
      // Sembunyikan indikator loading jika terjadi error jaringan
      Navigator.of(context).pop();
      // Jika ada error jaringan atau parsing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan jaringan: $e')),
      );
      
      logger.e('Network Error: $e');
    }
  }

  @override
  void dispose() { // Fungsi dispose controller
    addressController.dispose(); // Dispose controller address
    phone_numberController.dispose(); // Dispose controller telepon
    pickupDateController.dispose(); // Dispose controller tanggal
    super.dispose(); // Panggil dispose parent
  }

  @override
  Widget build(BuildContext context) { // Fungsi build widget
    return Scaffold( // Scaffold utama
      appBar: AppBar( // AppBar halaman
        backgroundColor: AppColors.primary, // Warna background AppBar
        title: const Text(
          "Jual Sampah", // Judul AppBar
          style: TextStyle(fontWeight: FontWeight.bold), // Style judul
        ),
        foregroundColor: Colors.white, // Warna ikon AppBar
        leading: IconButton( // Tombol kembali
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali
          onPressed: () {
            Navigator.pop(context); // Cukup pop, tidak perlu mengembalikan data ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView( // Scrollable body
        padding: const EdgeInsets.all(16.0), // Padding body
        child: Column( // Kolom utama
          crossAxisAlignment: CrossAxisAlignment.start, // Posisi kiri
          children: [

            // Keranjang (Bagian ini dirombak total)
            _buildSectionHeader("Keranjang"), // Header keranjang
            const SizedBox(height: 8), // Spasi
            if (_currentCartItems.isEmpty) // Jika keranjang kosong
              Container(
                padding: const EdgeInsets.all(16), // Padding
                decoration: BoxDecoration(
                  color: Colors.white, // Warna background
                  borderRadius: BorderRadius.circular(12), // Border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(10), // Warna shadow
                      spreadRadius: 1, // Spread shadow
                      blurRadius: 5, // Blur shadow
                      offset: const Offset(0, 3), // Offset shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Posisi kiri
                  children: [
                    const Text(
                      "Keranjang kosong. Tekan 'Tambah' untuk menambahkan sampah.", // Pesan keranjang kosong
                      style: TextStyle(fontStyle: FontStyle.italic), // Style italic
                    ),
                    const SizedBox(height: 10), // Spasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Posisi kanan
                      children: [
                        ElevatedButton( // Tombol tambah sampah
                          onPressed: () async {
                            final updatedCart = await Navigator.push<List<SampahItemModel>>( // Navigasi ke DaftarSampahPage
                              context,
                              MaterialPageRoute(
                                builder: (context) => DaftarSampahPage(initialCartItems: _currentCartItems), // Kirim item keranjang
                              ),
                            );
                            if (updatedCart != null) { // Jika ada perubahan keranjang
                              setState(() {
                                _currentCartItems = List.from(updatedCart); // Update keranjang
                                _calculateTotalPoint(); // Hitung ulang total point
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary, // Warna tombol
                            foregroundColor: Colors.white, // Warna teks tombol
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Border radius
                          ),
                          child: const Text("Tambah"), // Teks tombol
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              // ListView.builder untuk menampilkan item keranjang dengan kontrol
              ListView.builder(
                shrinkWrap: true, // Penting agar ListView tidak mengambil ruang tak terbatas
                physics: const NeverScrollableScrollPhysics(), // Non-scrollable agar SingleChildScrollView bekerja
                itemCount: _currentCartItems.length, // Jumlah item keranjang
                itemBuilder: (context, index) {
                  final item = _currentCartItems[index]; // Ambil item
                  return _buildCartItem(item); // Panggil helper untuk item keranjang
                },
              ),
            const SizedBox(height: 20), // Spasi

            _buildSectionHeader("Alamat Penjemputan"), // Header alamat penjemputan
            const SizedBox(height: 8), // Spasi
            Container( // Container input alamat
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding
              decoration: BoxDecoration( // Dekorasi container
                color: Colors.white, // Warna background
                borderRadius: BorderRadius.circular(12), // Border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(10), // Warna shadow
                    spreadRadius: 1, // Spread shadow
                    blurRadius: 5, // Blur shadow
                    offset: const Offset(0, 3), // Offset shadow
                  ),
                ],
              ),
              child: Row( // Row input alamat
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.grey), // Ikon lokasi
                  const SizedBox(width: 10), // Spasi
                  Expanded(
                  child: TextField( // TextField alamat penjemputan
                    controller: addressController, // Controller alamat
                    decoration: const InputDecoration(
                    hintText: "Masukkan Alamat Penjemputan", // Hint
                    border: InputBorder.none, // Tanpa border
                    ),
                    readOnly: false, // Bisa diedit
                  ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spasi



            _buildLabeledTextField(
              label: "Tanggal Penjemputan", // Label tanggal penjemputan
              hint: "Pilih Tanggal Penjemputan", // Hint tanggal penjemputan
              controller: pickupDateController, // Controller tanggal
              readOnly: true, // Hanya bisa dipilih
              onTap: () => _selectDate(context), // Fungsi pilih tanggal
              suffixIcon: Icons.calendar_today, // Ikon kalender
            ),
            const SizedBox(height: 20), // Spasi


            _buildLabeledTextField(
              label: "Nomor Telepon", // Label nomor telepon
              hint: "Nomor Telepon", // Hint nomor telepon
              controller: phone_numberController, // Controller telepon
              keyboardType: TextInputType.phone, // Tipe input telepon
              suffixIcon: Icons.copy, // Ikon copy
            ),
            const SizedBox(height: 20), // Spasi



            _buildSectionHeader("Detail Harga Sampah"), // Header detail harga
            const SizedBox(height: 8), // Spasi
            Container(
              padding: const EdgeInsets.all(16), // Padding
              decoration: BoxDecoration(
                color: Colors.white, // Warna background
                borderRadius: BorderRadius.circular(12), // Border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(10), // Warna shadow
                    spreadRadius: 1, // Spread shadow
                    blurRadius: 5, // Blur shadow
                    offset: const Offset(0, 3), // Offset shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Posisi kiri-kanan
                children: [
                  const Text(
                    "Total Point", // Label jumlah total
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Style label
                  ),
                  Text(
                    _totalPointKeranjang.toStringAsFixed(0), // Tampilkan total point
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary), // Style harga
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spasi

            SizedBox(
              width: double.infinity, // Lebar penuh
              child: ElevatedButton(
                onPressed: () {
                  _submitTransaction(); // Proses transaksi saat tombol ditekan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  padding: const EdgeInsets.symmetric(vertical: 15), // Padding tombol
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Border radius
                ),
                child: const Text(
                  "Selanjutnya", // Teks tombol
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Style teks
                ),
              ),
            ),
            const SizedBox(height: 20), // Spasi
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  // Helper untuk membuat tampilan setiap item di keranjang
  Widget _buildCartItem(SampahItemModel item) { // Widget item keranjang
    return Card(
      margin: const EdgeInsets.only(bottom: 16), // Margin bawah
      elevation: 2, // Elevasi card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Border radius
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Padding card
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Posisi atas
          children: [
            // Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Border radius gambar
              child: Image.asset(
                item.img, // Path gambar
                width: 70, // Lebar gambar
                height: 70, // Tinggi gambar
                fit: BoxFit.cover, // Fit gambar
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70, height: 70, // Ukuran container error
                  color: Colors.grey[200], // Warna background error
                  child: const Icon(Icons.broken_image, color: Colors.grey), // Ikon error
                ),
              ),
            ),
            const SizedBox(width: 12), // Spasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Posisi kiri
                children: [
                  // Nama produk dan tombol hapus (X)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Posisi kiri-kanan
                    children: [
                      Expanded(
                        child: Text(
                          item.title, // Nama produk
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Style nama
                          maxLines: 1, // Maksimal 1 baris
                          overflow: TextOverflow.ellipsis, // Overflow elipsis
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removeItem(item), // Fungsi hapus item
                        child: const Icon(Icons.cancel, color: Colors.grey, size: 20), // Tombol 'X'
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), // Spasi
                  Text(
                    item.points.toString(), // Point item (string)
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15), // Style harga
                  ),
                  const SizedBox(height: 4), // Spasi
                  const Text(
                    "📌 Plastik", // Ini bisa menjadi properti di SampahItemModel jika bervariasi
                    style: TextStyle(color: Colors.grey, fontSize: 13), // Style kategori
                  ),
                  const SizedBox(height: 8), // Spasi
                  // Kontrol kuantitas
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!), // Border kontrol
                      borderRadius: BorderRadius.circular(8), // Border radius
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Ukuran minimum
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20), // Ikon minus
                          onPressed: () => _decrementQuantity(item), // Fungsi kurang quantity
                          splashRadius: 20, // Radius splash
                        ),
                        Text(
                          '${item.quantity}', // Tampilkan quantity
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Style quantity
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20), // Ikon tambah
                          onPressed: () => _incrementQuantity(item), // Fungsi tambah quantity
                          splashRadius: 20, // Radius splash
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat header bagian
  Widget _buildSectionHeader(String title) { // Widget header section
    return Text(
      title, // Judul section
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87), // Style judul
    );
  }

  // Helper untuk membuat TextField berlabel
  Widget _buildLabeledTextField({
    required String label, // Label field
    required String hint, // Hint field
    required TextEditingController controller, // Controller field
    TextInputType keyboardType = TextInputType.text, // Tipe input
    bool readOnly = false, // Apakah hanya baca
    VoidCallback? onTap, // Fungsi onTap
    IconData? suffixIcon, // Ikon suffix
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Posisi kiri
      children: [
        _buildSectionHeader(label), // Header label
        const SizedBox(height: 8), // Spasi
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16), // Padding
          decoration: BoxDecoration(
            color: Colors.white, // Warna background
            borderRadius: BorderRadius.circular(12), // Border radius
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(10), // Warna shadow
                spreadRadius: 1, // Spread shadow
                blurRadius: 5, // Blur shadow
                offset: const Offset(0, 3), // Offset shadow
              ),
            ],
          ),
          child: TextField(
            controller: controller, // Controller field
            keyboardType: keyboardType, // Tipe input
            readOnly: readOnly, // Apakah hanya baca
            onTap: onTap, // Fungsi onTap
            decoration: InputDecoration(
              hintText: hint, // Hint field
              border: InputBorder.none, // Tanpa border
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null, // Ikon suffix
              suffixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20), // Ukuran ikon
            ),
          ),
        ),
      ],
    );
  }


}