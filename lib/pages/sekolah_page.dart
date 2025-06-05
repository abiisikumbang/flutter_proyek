import 'package:flutter/material.dart';
import 'package:flutter_cbt_tpa_app/material.dart';

class SekolahPage extends StatefulWidget {
  const SekolahPage({super.key});

  @override
  State<SekolahPage> createState() => _SekolahPageState();
}

class _SekolahPageState extends State<SekolahPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _daftarSekolah = [
    {'nama': 'SDN 1 Binjai Kota', 'alamat': 'Jl. Jenderal Sudirman No. 1'},
    {'nama': 'SMPN 2 Binjai Utara', 'alamat': 'Jl. Medan - Binjai KM. 12'},
    {'nama': 'SMAN 1 Binjai', 'alamat': 'Jl. Sultan Hasanuddin No. 14'},
    // Tambahkan data sekolah lainnya di sini
  ];

  List<Map<String, String>> _filteredSekolah = [];

  @override
  void initState() {
    super.initState();
    _filteredSekolah = List.from(_daftarSekolah); // Inisialisasi dengan semua sekolah
  }

  void _filterSekolah(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSekolah = List.from(_daftarSekolah);
      } else {
        _filteredSekolah = _daftarSekolah
            .where((sekolah) => sekolah['nama']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Sekolah Bebas Sampah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'lib/images/sekolah_bebas_sampah.png', // Ganti dengan path gambar sekolah bebas sampah Anda
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implementasi navigasi ke form pendaftaran sekolah
                      print("Tombol Daftarkan Sekolahmu ditekan");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Daftarkan Sekolahmu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSekolah,
                decoration: InputDecoration(
                  hintText: "Cari Nama Sekolah",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Daftar Sekolah:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredSekolah.length,
              itemBuilder: (context, index) {
                final sekolah = _filteredSekolah[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15.0),
                    leading: const Icon(
                      Icons.school,
                      color: AppColors.primary,
                      size: 30,
                    ),
                    title: Text(
                      sekolah['nama']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      sekolah['alamat']!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    // Anda bisa menambahkan trailing icon atau onTap action jika diperlukan
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}