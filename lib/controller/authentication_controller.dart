import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  var isLoading = false.obs;
  var name = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;

  // Ganti dengan alamat server
  final String baseUrl = 'http://192.168.18.41:8000';

  @override
  void onInit() {
    super.onInit();
    // Panggil getUser() saat controller diinisialisasi
    // Ini akan memuat data pengguna jika ada sesi login yang tersimpan
    getUser();
  }

  // Fungsi untuk mendapatkan token dari SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  //Fungsi untuk mengambil user dari API
  Future<void> getUser() async {
    final token = await getToken();
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/api/user'),
          headers: {'Authorization': 'Bearer $token'},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          name.value = data['name'] ?? ''; // Pastikan ada null check
          email.value = data['email'] ?? '';
          phoneNumber.value = data['phone'] ?? '';
          // Jika ingin menyimpan data pengguna ke SharedPreferences
        } else {
          //jika token tidak valid atau sesi kadaluarsa, maka perlu logout otomatis
          if (response.statusCode == 401) {
            logout();
            Get.snackbar("Session Expired", "Silakan login kembali");
          } else {
            Get.snackbar(
              "Error",
              "Gagal mengambil data pengguna ; ${response.statusCode}");
          }
        }
      } catch (e) {
        Get.snackbar("Error", "Tidak bisa konek ke server: $e");
        name.value = '';
        email.value = '';
        phoneNumber.value = '';
      }
    } else {
      name.value = '';
      email.value = '';
      phoneNumber.value = '';
    }
  }

  //login
  Future<bool> login({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        final user = data['user'];

        // Simpan token ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user_email', user['email']);
        await prefs.setInt('user_id', user['id']);

        //set variabel rx dengan data dari respons login
        name.value = user['name']??'';
        this.email.value = user['email']??'';
        phoneNumber.value = user['phone']??'';

        // Navigasi ke halaman utama)
        Get.offAllNamed('/main');
        Get.snackbar("Login Berhasil", "Selamat datang ${user['name']}");
        return true;
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          final error = jsonDecode(response.body);
          Get.snackbar("Login Gagal", error['message'] ?? 'Email atau password salah');
          return false;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak bisa konek ke server: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
    // Ensure a bool is always returnedclr
    return false;
  }

  //register
  Future<void> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    // Set loading state to true
    isLoading.value = true;

    try {
      // Prepare and send the POST request to the server
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phoneNumber,
          'password': password,
          'password_confirmation': password,
        }),
      );

      // Check if the response status is 200 or 201 (success)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        final user = data['user'];

        // Save token and user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user_email', user['email']);
        await prefs.setInt('user_id', user['id']);

  // SET VARIABEL RX DENGAN DATA DARI RESPONS REGISTER
        this.name.value = user['name']??'';
        this.email.value = user['email']??'';
        this.phoneNumber.value = user['phone']??'';

        Get.offAllNamed('/login');
        Get.snackbar(
          "Registrasi Berhasil",
          "Silakan login menggunakan akun Anda",
        );
      } else {
        // Decode the response body to get error messages
        final data = jsonDecode(response.body);
        // Show error message to the user
        Get.snackbar(
          "Gagal Registrasi",
          data['message'] ?? data['error'] ?? "Terjadi kesalahan",
        );
      }
    } on Exception catch (e) {
      Get.snackbar("Error", "Tidak dapat terhubung ke server: $e");
    } finally {
      // Reset loading state to false
      isLoading.value = false;
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    isLoading.value = true;
    try{
      final token = await getToken();
      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/api/logout'),
          headers: {'Authorization': 'Bearer $token'},
        );
      }
    } catch (e){
      Get.log("Error during logout API call: $e"); // Log error, tapi tetap lanjutkan logout lokal
    } finally {
    // Menghapus token dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    //kosongkan semua variable rx
    name.value = '';
    email.value = '';
    phoneNumber.value = '';

    // Navigasi ke halaman login
    Get.offAllNamed('/login');
    Get.snackbar('Logout Berhasil', "Anda telah berhasil logout");
    isLoading.value = false;
    }
  }
}

// class AuthenticationController {
/// Mendaftarkan pengguna baru ke dalam database.

// Future<void> register({
//   required String name,
//   required String email,
//   required String phoneNumber,
//   required String password,
// }) async {
//   /// Membuka database yang akan digunakan untuk menyimpan data pengguna.
//   final db = await openDatabase('cbt-tpa-fic10', version: 1);

//   /// Menambahkan data pengguna yang baru didaftarkan ke dalam tabel `users`.
//   await db.insert('users', {
//     'name': name,
//     'email': email,
//     'phoneNumber': phoneNumber,
//     'password': password,
//   });

//   /// Mencetak pesan ke console bahwa pengguna telah berhasil didaftarkan.
//   // Use GetX logging for better practice
//   Get.log('User registered: $name, $email, $phoneNumber');
// }
