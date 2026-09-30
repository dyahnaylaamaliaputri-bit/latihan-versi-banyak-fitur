// Library utama Flutter untuk membuat tampilan
import 'package:flutter/material.dart';

// Halaman Beranda (daftar menu)
import 'pages/home_page.dart';
// Halaman Profil
import 'pages/profile_page.dart';
// Halaman Login
import 'login.dart';
import 'pages/favorite_page.dart'; // <- tambah di bagian import

// Kerangka utama aplikasi setelah login: berisi halaman-halaman dan menu navigasi di bawah.
// Stateful karena halaman yang tampil berubah tergantung menu yang dipilih
class Root extends StatefulWidget {
  // Nama user yang dikirim dari halaman login
  //tambahan buat menu login
  final String nama;

  // Username yang sedang login, untuk ditampilkan di halaman Profil
  final String username;

  // required = nama dan username wajib diisi saat Root dibuat
  const Root({super.key, required this.nama, required this.username});
  // Membuat State untuk menyimpan menu mana yang sedang aktif
  @override
  State<Root> createState() => _RootState();
}

//Membuat tombol navigator
class _RootState extends State<Root> {
  // Nomor menu yang sedang dipilih: 0 = Beranda, 1 = Favorit, 2 = Profil
  // Awalnya 0, jadi Beranda yang tampil lebih dulu
  int _selectedIndex = 0;

  // build: fungsi yang menggambar tampilan halaman
  @override
  Widget build(BuildContext context) {
    // Daftar halaman. Urutannya harus sama dengan urutan menu di navigasi bawah
    final List<Widget> pages = [
      // Index 0: Beranda (nama user ikut dikirim supaya bisa ditampilkan di sana)
      HomePage(nama: widget.nama),
      FavoritePage(), // <- tambahkan halaman favorit
      ProfilePage(
        username: widget.username,
      ), //untuk meneruskan username ke halaman profile
    ];
    // Scaffold: kerangka dasar halaman
    return Scaffold(
      // Menampilkan halaman sesuai menu yang sedang dipilih
      body: pages[_selectedIndex],
      // Menu navigasi di bagian bawah layar (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        // Menandai menu mana yang sedang aktif
        currentIndex: _selectedIndex,
        // Latar menu berwarna putih
        backgroundColor: Colors.white,
        // Warna menu yang sedang dipilih (oranye) dan yang tidak dipilih (abu-abu)
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: Colors.grey[600],
        // Dijalankan saat user menekan salah satu menu. index = nomor menu yang ditekan
        onTap: (index) {
          // Simpan nomor menu baru, lalu setState supaya halaman berganti
          setState(() {
            _selectedIndex = index;
          });
        },
        // Daftar tombol menu
        items: const [
          // Menu 1: Beranda (index 0)
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Beranda',
          ),
          // Menu 2: Favorit (index 1)
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ), // <- tambahan
          // Menu 3: Profil (index 2)
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
