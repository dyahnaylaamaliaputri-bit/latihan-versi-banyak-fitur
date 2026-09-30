// Library utama Flutter untuk membuat tampilan
import 'package:flutter/material.dart';

// Dipakai untuk kembali ke halaman login saat logout
import '../login.dart';

// StatefulWidget karena warna avatar dan tombol logout bisa berubah
// saat user menekan salah satu tombol warna
class ProfilePage extends StatefulWidget {
  // Username yang sedang login, dikirim dari halaman login lewat Root
  final String username;

  // required = username wajib diisi saat halaman ini dibuat
  const ProfilePage({super.key, required this.username});

  // Membuat State untuk menyimpan warna yang sedang dipilih
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Warna yang sedang dipakai untuk avatar dan tombol logout.
  // Awalnya hijau (warna default), berubah kalau user menekan tombol warna
  Color _warnaPilihan = Colors.green;

  // build: fungsi yang menggambar tampilan halaman
  @override
  Widget build(BuildContext context) {
    // Huruf pertama username (huruf besar) untuk ditampilkan di dalam avatar.
    // Kalau username kosong, tampilkan tanda tanya supaya aplikasi tidak error
    final String hurufAwal = widget.username.isNotEmpty
        ? widget.username[0].toUpperCase()
        : '?';

    // Scaffold: kerangka dasar halaman
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      // Center: isi halaman diletakkan di tengah layar
      body: Center(
        // SingleChildScrollView: supaya bisa di-scroll kalau layar kecil
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          // Column: menyusun widget dari atas ke bawah
          child: Column(
            // mainAxisSize.min: tinggi Column secukupnya, sesuai isinya
            mainAxisSize: MainAxisSize.min,
            children: [
              // Foto profil: CircleAvatar (lingkaran) dengan warna latar dari _warnaPilihan.
              // Di dalamnya ada huruf pertama username
              CircleAvatar(
                radius: 40,
                backgroundColor: _warnaPilihan,
                child: Text(
                  hurufAwal,
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),

              // SizedBox: memberi jarak kosong setinggi 12
              const SizedBox(height: 12),

              // Menampilkan username yang sedang login
              Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Teks pernyataan yang wajib ditampilkan
              const Text(
                'Saya bersumpah mengerjakan soal kuis ini dengan jujur dan tidak melakukan kecurangan apapun itu',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 20),

              // Tiga tombol pilihan warna berbentuk lingkaran: Biru, Merah, Ungu
              Row(
                // Diletakkan di tengah secara horizontal
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tombolWarna('Biru', Colors.blue),
                  const SizedBox(width: 10),
                  _tombolWarna('Merah', Colors.red),
                  const SizedBox(width: 10),
                  _tombolWarna('Ungu', Colors.purple),
                ],
              ),

              const SizedBox(height: 24),

              // Tombol Logout: warnanya ikut berubah sesuai warna yang dipilih
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _warnaPilihan,
                  foregroundColor: Colors.white,
                  // StadiumBorder: bentuk tombol lonjong dengan ujung membulat penuh
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                ),
                onPressed: () {
                  // Pindah ke halaman login sekaligus menghapus halaman-halaman sebelumnya,
                  // supaya user tidak bisa kembali ke halaman utama dengan tombol back
                  Navigator.pushAndRemoveUntil(
                    context,
                    // Halaman tujuan: LoginPage
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false, // hapus semua route sebelumnya
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi pembantu untuk membuat satu tombol pilihan warna berbentuk lingkaran.
  // Dipakai 3 kali (Biru, Merah, Ungu) supaya kode tidak ditulis berulang
  Widget _tombolWarna(String label, Color warna) {
    // Tooltip: menampilkan nama warna kalau tombol ditahan lama
    return Tooltip(
      message: label,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: warna,
          // CircleBorder: bentuk tombol menjadi lingkaran
          shape: const CircleBorder(),
          // Ukuran tombol 32 x 32, tanpa jarak dalam
          fixedSize: const Size(32, 32),
          minimumSize: const Size(32, 32),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          // setState: simpan warna yang dipilih, lalu tampilan digambar ulang
          // sehingga avatar dan tombol logout langsung berganti warna
          setState(() {
            _warnaPilihan = warna;
          });
        },
        child: const SizedBox.shrink(),
      ),
    );
  }
}
