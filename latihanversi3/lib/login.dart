// Library utama Flutter untuk membuat tampilan
import 'package:flutter/material.dart';

// Mengambil data user (user1) yang dipakai untuk mencocokkan login
import 'models/data.dart';
// Mengambil halaman Root, yaitu halaman tujuan setelah login berhasil
import 'root.dart';

// Halaman login.
// Stateful karena tampilannya bisa berubah (misalnya garis kolom jadi merah saat login gagal)
class LoginPage extends StatefulWidget {
  // Constructor halaman ini
  const LoginPage({super.key});

  // Membuat State, yaitu tempat menyimpan data dan logika halaman ini
  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Isi dari halaman login. Tanda _ di depan nama artinya private (hanya bisa dipakai di file ini)
class _LoginPageState extends State<LoginPage> {
  // Controller = alat untuk mengambil teks yang diketik user di kolom input
  // Satu untuk kolom username, satu lagi untuk kolom password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Penanda apakah user sudah berhasil login (awalnya belum)
  bool isLoggedin = false;
  // Penanda apakah login gagal. Kalau true, garis kolom input berubah jadi merah
  bool isLoginFailed = false;

  // Fungsi yang dijalankan saat tombol Login ditekan
  void _login() {
    //logic dari UI kemarin
    String username = _usernameController.text; //iniiasi, variabel username ngambil nilai dari controller teksnya, dari input (.text)
    String password = _passwordController.text; //ini juga sama
    // Cek apakah username DAN password yang diketik sama dengan data user1
    // && artinya keduanya harus benar
    if (username == user1.username && password == user1.password) {
      // setState: memberi tahu Flutter bahwa ada data yang berubah, jadi tampilan digambar ulang
      // Login berhasil: isLoggedin jadi true, dan tanda gagal dimatikan
      setState(() {
        isLoggedin = true;
        isLoginFailed = false;
      });

      // Pindah ke halaman Root dan MENGGANTI halaman login.
      // Jadi user tidak bisa balik ke halaman login dengan tombol back
      Navigator.pushReplacement(
        context,
        // Nama user dan username yang sedang login dikirim ke Root
        // (nama untuk sapaan di Beranda, username untuk halaman Profil)
        MaterialPageRoute(
          builder: (context) => Root(nama: user1.nama, username: username),
        ),
      );
      // Kalau username atau password salah, jalankan bagian ini
    } else {
      // Login gagal: isLoginFailed jadi true supaya garis kolom input berubah merah
      setState(() {
        isLoggedin = false;
        isLoginFailed = true;
      });
      // Menampilkan pesan singkat (SnackBar) di bagian bawah layar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          // Pesan yang muncul saat login gagal
          content: Text('Login gagal!'),
          // Warna latar SnackBar dibuat merah supaya jelas kalau ini pesan error
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // build: fungsi yang menggambar tampilan halaman
  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka dasar halaman (ada bagian appBar di atas dan body sebagai isi)
    return Scaffold(
      // Bar judul di bagian atas halaman
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // Warna latar bar: oranye
        backgroundColor: const Color(0xFFFF9800),
      ),
      // Isi halaman, diletakkan di tengah layar
      body: Center(
        child: Padding(
          // Memberi jarak 16 di semua sisi supaya isi tidak menempel ke tepi layar
          padding: EdgeInsets.all(16.0),
          // Column: menyusun widget dari atas ke bawah
          child: Column(
            // Susunan widget diletakkan di tengah secara vertikal
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kalau BELUM login, tampilkan form login.
              // Tanda ... dipakai untuk memasukkan beberapa widget sekaligus ke dalam Column
              if (!isLoggedin) ...[
                Text(
                  'This is Login Page',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // Jarak kosong antara tulisan dan logo
                SizedBox(height: 16),
                // Logo: gambar yang disimpan di dalam project (folder assets/images)
                Image.asset(
                  '../assets/image/logo.png',
                  // Tinggi logo 100, lebarnya menyesuaikan otomatis supaya tidak gepeng
                  height: 100,
                  // Tampilan cadangan kalau logo gagal dimuat (misalnya file logo.png belum ada di folder assets/images)
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
                // SizedBox: memberi jarak kosong setinggi 20
                SizedBox(height: 20),
                // Kolom input untuk username
                _usernameField(_usernameController, isLoginFailed),
                // Kolom input untuk password
                _passwordField(_passwordController, isLoginFailed),
                SizedBox(height: 20),
                // Tombol Login
                ElevatedButton(
                  // Saat ditekan, jalankan fungsi _login di atas
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    // Warna latar tombol: oranye
                    backgroundColor: const Color(0xFFFF9800),
                    // Warna tulisan tombol: putih
                    foregroundColor: Colors.white,
                    // Ukuran minimal tombol (lebar 200, tinggi 45)
                    minimumSize: Size(200, 45),
                  ),
                  child: Text('Login'),
                ),
                // Kalau SUDAH login, tampilkan bagian ini
              ] else ...[
                //kalo login bener akan merujuk kesini
                Text('Halo, ${user1.nama}!'),
                SizedBox(height: 20),
                Text('Pasti username kamu: ${user1.username}'),
                Text('Pasti password kamu: ${user1.password}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Fungsi pembantu untuk membuat kolom username.
// Dibuat terpisah supaya kode tidak berulang dan lebih rapi
Widget _usernameField(TextEditingController controller, bool isLoginFailed) {
  return _inputField(
    controller: controller,
    hint: 'Username',
    isLoginFailed: isLoginFailed,
  );
}

// Fungsi pembantu untuk membuat kolom password
Widget _passwordField(TextEditingController controller, bool isLoginFailed) {
  return _inputField(
    controller: controller,
    hint: 'Password',
    isLoginFailed: isLoginFailed,
    // obscure true = teks yang diketik disamarkan (jadi titik-titik) supaya password tidak terlihat
    obscure: true,
  );
}

// Fungsi dasar pembuat kolom input, dipakai oleh _usernameField dan _passwordField
Widget _inputField({
  required TextEditingController controller,
  required String hint,
  required bool isLoginFailed,
  // Nilai bawaan false, artinya teks terlihat biasa kecuali diubah jadi true
  bool obscure = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: TextField(
      controller: controller,
      // Mengatur apakah teks disamarkan atau tidak
      obscureText: obscure,
      // Kolom bisa diketik
      enabled: true,
      decoration: InputDecoration(
        // Teks petunjuk yang muncul samar di dalam kolom sebelum user mengetik
        hintText: hint,
        // Jarak antara tulisan dan garis pinggir kolom
        contentPadding: EdgeInsets.all(8.0),
        // Bentuk garis pinggir kolom input (kotak dengan sudut membulat)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: const Color(0xFFFF9800)),
        ),
        // Garis pinggir saat kolom dalam keadaan biasa (tidak sedang diketik)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            // Kalau login gagal garisnya merah, kalau tidak garisnya oranye
            color: isLoginFailed ? Colors.red : const Color(0xFFFF9800),
            width: 2.0,
          ),
        ),
      ),
    ),
  );
}
