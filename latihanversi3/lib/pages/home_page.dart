// Library utama Flutter untuk membuat tampilan
import 'package:flutter/material.dart';

// Model data makanan
import '../models/food_item.dart';
// Halaman detail makanan
import 'detail_page.dart';

// StatefulWidget karena quantity makanan bisa berubah
// saat user balik dari halaman detail
class HomePage extends StatefulWidget {
  final String nama; //untuk memanggil nama di hompepage
  const HomePage({
    super.key,
    required this.nama,
  }); //tanmabahan untuk memanggil nama;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // STATE: list makanan: quantity-nya bisa berubah
  final List<FoodItem> _menuItems = FoodItem.sampleData;

  // Controller untuk kolom pencarian (mengambil dan mengosongkan teks yang diketik)
  final TextEditingController _searchController = TextEditingController();
  // Kata kunci pencarian yang sedang diketik user
  String _searchQuery = '';
  // Kategori yang sedang dipilih. 'Semua' artinya semua menu ditampilkan
  String _selectedCategory = 'Semua';

  // dispose: dijalankan saat halaman ditutup, untuk membersihkan controller
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Getter: daftar kategori untuk chip filter.
  // 'Semua' di depan, lalu kategori dari data menu (toSet: supaya tidak ada yang dobel)
  List<String> get _categories => [
    'Semua',
    ..._menuItems.map((item) => item.category).toSet(),
  ];

  // Getter: daftar menu setelah disaring oleh kategori DAN kata kunci pencarian
  List<FoodItem> get _filteredItems {
    return _menuItems.where((item) {
      // Cocok kategori: kalau 'Semua' lolos semua, kalau tidak harus sama kategorinya
      final cocokKategori =
          _selectedCategory == 'Semua' || item.category == _selectedCategory;
      // Cocok pencarian: nama menu mengandung kata kunci (huruf besar/kecil diabaikan)
      final cocokCari = item.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return cocokKategori && cocokCari;
    }).toList();
  }

  // Getter: hitung total semua pesanan
  int get _grandTotal =>
      _menuItems.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    // Simpan hasil saringan supaya tidak dihitung berulang kali di bawah
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text(
          '🍽️ Menu Resto',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Banner total pesanan
          Container(
            width: double.infinity,
            color: const Color(0xFFFF9800),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            // Text hanya boleh berisi satu tulisan, jadi dua tulisan
            // (sapaan + total) dibungkus Column supaya tersusun atas-bawah
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Halo, ${widget.nama} 👋',
                  style: const TextStyle(
                    color:
                        Colors.white, // putih, karena latar banner sudah oranye
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Total Pesanan: Rp ${formatPrice(_grandTotal)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // ── Kolom pencarian menu
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              // onChanged: dijalankan setiap kali user mengetik atau menghapus huruf
              onChanged: (value) {
                // setState: simpan kata kunci baru, lalu daftar menu disaring ulang
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: const Icon(Icons.search),
                // Tombol silang untuk mengosongkan pencarian.
                // Hanya muncul kalau kolom pencarian ada isinya
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                // Garis pinggir dibuat lonjong dan tanpa garis
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── Filter kategori (chip yang bisa digeser ke samping)
          SizedBox(
            height: 48,
            child: ListView(
              // scrollDirection horizontal: daftar chip digeser ke kiri-kanan
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: _categories.map((kategori) {
                final dipilih = kategori == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(kategori),
                    selected: dipilih,
                    // Hilangkan tanda centang bawaan supaya tampilan lebih bersih
                    showCheckmark: false,
                    backgroundColor: Colors.white,
                    // Warna chip yang sedang dipilih: oranye
                    selectedColor: const Color(0xFFFF9800),
                    labelStyle: TextStyle(
                      color: dipilih ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    // Saat chip ditekan, simpan kategori baru lalu saring ulang daftar menu
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = kategori;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ListView.builder: tampilkan daftar makanan
          Expanded(
            // Kalau hasil saringan kosong, tampilkan pesan. Kalau ada, tampilkan daftar
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 56,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Menu tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    // key berubah saat kategori berganti, supaya daftar dibuat ulang
                    // dan animasi muncul kartu diputar lagi
                    key: ValueKey(_selectedCategory),
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // ANIMASI: kartu muncul pelan-pelan (memudar) sambil naik dari bawah.
                      // TweenAnimationBuilder mengubah value dari 0 ke 1 selama durasi tertentu.
                      // Durasi dibuat bertambah per kartu supaya munculnya berurutan
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(
                          milliseconds: 300 + (index.clamp(0, 8) as int) * 80,
                        ),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            // opacity: 0 = transparan, 1 = terlihat jelas
                            opacity: value,
                            child: Transform.translate(
                              // Mulai dari 24 piksel di bawah, lalu naik ke posisi asli
                              offset: Offset(0, 24 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: _buildFoodCard(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(FoodItem item) {
    return GestureDetector(
      // Navigasi ke DetailPage saat kartu diklik
      onTap: () async {
        // await: tunggu sampai user selesai di halaman detail
        // result: nilai quantity yang dikirim balik dari detail
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            // indexOf: posisi asli menu di daftar lengkap
            // (bukan posisi di daftar hasil saringan)
            builder: (context) =>
                DetailPage(item: item, index: _menuItems.indexOf(item)),
          ),
        );

        // Kalau ada data balik (quantity baru), update state
        if (result != null && result is int) {
          setState(() {
            // item adalah objek yang sama dengan di daftar lengkap,
            // jadi cukup diubah langsung di sini
            item.quantity = result;
          });
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Gambar makanan
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                item.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),

            // ── Info makanan ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama makanan
                    // Nama makanan + tombol favorit
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item.isFavorite =
                                  !item.isFavorite; // balik true/false
                            });
                          },
                          // ANIMASI: ikon hati mengecil-membesar saat berganti
                          // antara hati penuh dan hati kosong.
                          // key dipakai supaya AnimatedSwitcher tahu ikonnya sudah berganti
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: Icon(
                              item.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey(item.isFavorite),
                              color: Colors.red,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Deskripsi
                    Text(
                      item.description,
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Jumlah porsi yang dipilih user
                    // Otomatis berubah saat balik dari detail
                    Text(
                      'Jumlah porsi: ${item.quantity} porsi',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ── Baris bawah: harga/porsi kiri + total harga kanan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Harga per porsi — kecil, warna abu-abu
                        Text(
                          'Rp ${item.formattedPrice}/porsi',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),

                        // Jika quantity = 0 tampilan "Rp 0"
                        Text(
                          'Rp ${item.quantity > 0 ? item.formattedTotal : '0'}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
