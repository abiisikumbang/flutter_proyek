// lib/pages/jual_sampah_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cbt_tpa_app/models/sampah_item.dart'; // Import SampahItemModel
import 'package:flutter_cbt_tpa_app/pages/daftar_sampah_page.dart'; // Import DaftarSampahPage

/// Halaman untuk proses penjualan sampah (pengisian form).
class JualSampahPage extends StatefulWidget {
  final List<SampahItemModel>? cartItems;

  const JualSampahPage({super.key, this.cartItems});

  @override
  State<JualSampahPage> createState() => _JualSampahPageState();
}

class _JualSampahPageState extends State<JualSampahPage> {
  // Controllers untuk TextField
  final TextEditingController _alamatPenjemputanController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _namaPemilikRekeningController = TextEditingController();
  final TextEditingController _nomorRekeningController = TextEditingController();
  final TextEditingController _tanggalPenjemputanController = TextEditingController();
  final TextEditingController _waktuPenjemputanController = TextEditingController();

  // Variabel untuk DropdownButton
  String? _selectedKota;
  String? _selectedProgramSampah;
  String? _selectedRekeningTujuan;

  // Daftar pilihan untuk dropdown
  final List<String> _kotaOptions = ['Binjai', 'Medan', 'Stabat', 'Tanjung Pura'];
  final List<String> _programSampahOptions = ['Jual Sampah', 'Donasi Sampah'];
  final List<String> _rekeningTujuanOptions = ['Bank ABC', 'Bank DEF', 'E-Wallet XYZ'];

  double _totalHargaKeranjang = 0.0;
  List<SampahItemModel> _currentCartItems = []; // Mengelola item keranjang di sini

  @override
  void initState() {
    super.initState();
    _currentCartItems = List.from(widget.cartItems ?? []);
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    double total = 0.0;
    for (var item in _currentCartItems) {
      total += item.pricePerKg * item.quantity;
    }
    setState(() {
      _totalHargaKeranjang = total;
    });
  }

  // Metode untuk menambah kuantitas item
  void _incrementQuantity(SampahItemModel item) {
    setState(() {
      item.quantity++;
      _calculateTotalPrice();
    });
  }

  // Metode untuk mengurangi kuantitas item
  void _decrementQuantity(SampahItemModel item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        // Hapus item dari keranjang jika kuantitasnya menjadi 0
        _currentCartItems.removeWhere((element) => element.title == item.title);
      }
      _calculateTotalPrice();
    });
  }

  // Metode untuk menghapus item sepenuhnya
  void _removeItem(SampahItemModel item) {
    setState(() {
      _currentCartItems.removeWhere((element) => element.title == item.title);
      _calculateTotalPrice();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.title} dihapus dari keranjang.')),
      );
    });
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _tanggalPenjemputanController.text = DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _waktuPenjemputanController.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    _alamatPenjemputanController.dispose();
    _catatanController.dispose();
    _nomorTeleponController.dispose();
    _namaPemilikRekeningController.dispose();
    _nomorRekeningController.dispose();
    _tanggalPenjemputanController.dispose();
    _waktuPenjemputanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Jual Sampah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Cukup pop, tidak perlu mengembalikan data ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Alamat Penjemputan"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _alamatPenjemputanController,
                      decoration: const InputDecoration(
                        hintText: "Pilih Alamat Penjemputan",
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logika pilih alamat belum diimplementasikan.')),
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logika tombol plus belum diimplementasikan.')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Keranjang (Bagian ini dirombak total)
            _buildSectionHeader("Keranjang"),
            const SizedBox(height: 8),
            if (_currentCartItems.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Keranjang kosong. Tekan 'Tambah' untuk menambahkan sampah.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final updatedCart = await Navigator.push<List<SampahItemModel>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DaftarSampahPage(initialCartItems: _currentCartItems),
                              ),
                            );
                            if (updatedCart != null) {
                              setState(() {
                                _currentCartItems = List.from(updatedCart);
                                _calculateTotalPrice();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Tambah"),
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
                itemCount: _currentCartItems.length,
                itemBuilder: (context, index) {
                  final item = _currentCartItems[index];
                  return _buildCartItem(item); // Panggil helper untuk item keranjang
                },
              ),
            const SizedBox(height: 20),


            // Bagian-bagian form lainnya tetap sama
            _buildLabeledDropdown(
              label: "Kota Penjemputan",
              hint: "Pilih Kota Penjemputan",
              value: _selectedKota,
              items: _kotaOptions,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedKota = newValue;
                });
              },
              infoIcon: true,
            ),
            const SizedBox(height: 20),

            _buildLabeledTextField(
              label: "Tanggal Penjemputan",
              hint: "Pilih Tanggal Penjemputan",
              controller: _tanggalPenjemputanController,
              readOnly: true,
              onTap: () => _selectDate(context),
              suffixIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 20),

            _buildLabeledTextField(
              label: "Waktu Penjemputan",
              hint: "Pilih Waktu Penjemputan",
              controller: _waktuPenjemputanController,
              readOnly: true,
              onTap: () => _selectTime(context),
              suffixIcon: Icons.watch_later_outlined,
            ),
            const SizedBox(height: 20),

            _buildLabeledTextField(
              label: "Catatan",
              hint: "Catatan",
              controller: _catatanController,
              suffixIcon: Icons.edit_note,
            ),
            const SizedBox(height: 20),

            _buildLabeledTextField(
              label: "Nomor Telepon",
              hint: "Nomor Telepon",
              controller: _nomorTeleponController,
              keyboardType: TextInputType.phone,
              suffixIcon: Icons.copy,
            ),
            const SizedBox(height: 20),

            _buildLabeledDropdown(
              label: "Program Sampah",
              hint: "Pilih Program Sampah",
              value: _selectedProgramSampah,
              items: _programSampahOptions,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProgramSampah = newValue;
                });
              },
              suffixIcon: Icons.settings_outlined,
            ),
            const SizedBox(height: 20),

            _buildLabeledDropdown(
              label: "Rekening Tujuan",
              hint: "Pilih Rekening Tujuan",
              value: _selectedRekeningTujuan,
              items: _rekeningTujuanOptions,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRekeningTujuan = newValue;
                });
              },
              infoIcon: true,
            ),
            const SizedBox(height: 20),

            _buildLabeledTextField(
              label: "Nama Pemilik Rekening",
              hint: "Nama Pemilik Rekening",
              controller: _namaPemilikRekeningController,
              suffixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            _buildLabeledTextField(
              label: "Nomor Rekening",
              hint: "Nomor Rekening",
              controller: _nomorRekeningController,
              keyboardType: TextInputType.number,
              suffixIcon: Icons.pin,
            ),
            const SizedBox(height: 20),

            _buildSectionHeader("Foto Sampah"),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logika pilih foto belum diimplementasikan.')),
                  );
                },
                icon: Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                label: Text(
                  "Pilih Foto",
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader("Detail Harga Sampah"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Jumlah Total",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rp${_totalHargaKeranjang.toStringAsFixed(0)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form siap diproses dengan item di keranjang!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Selanjutnya",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  // Helper untuk membuat tampilan setiap item di keranjang
  Widget _buildCartItem(SampahItemModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                item.img,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70, height: 70,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama produk dan tombol hapus (X)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removeItem(item),
                        child: const Icon(Icons.cancel, color: Colors.grey, size: 20), // Tombol 'X'
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.price,
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "📌 Plastik", // Ini bisa menjadi properti di SampahItemModel jika bervariasi
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  // Kontrol kuantitas
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: () => _decrementQuantity(item),
                          splashRadius: 20,
                        ),
                        Text(
                          '${item.quantity}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () => _incrementQuantity(item),
                          splashRadius: 20,
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
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  // Helper untuk membuat TextField berlabel
  Widget _buildLabeledTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            ),
          ),
        ),
      ],
    );
  }

  // Helper untuk membuat DropdownField berlabel
  Widget _buildLabeledDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool infoIcon = false,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildSectionHeader(label),
            if (infoIcon) ...[
              const SizedBox(width: 8),
              const Icon(Icons.info_outline, size: 18, color: Colors.grey),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(hint),
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            ),
            isExpanded: true,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}