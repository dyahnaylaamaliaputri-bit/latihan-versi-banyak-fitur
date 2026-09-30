// Model (cetakan data) untuk satu menu makanan/minuman
class FoodItem {
  // Nama menu. final = nilainya tidak bisa diubah setelah dibuat
  final String name;
  // Deskripsi singkat menu
  final String description;
  // Link (URL) gambar menu dari internet
  final String imageUrl;
  // Jumlah porsi yang dipesan. Tidak final karena nilainya bisa berubah
  int quantity;
  // Harga per porsi (dalam rupiah)
  final int price;
  bool isFavorite; // <- tambahan untuk menu favorite item
  // Kategori menu (contoh: 'Makanan' atau 'Minuman'), dipakai untuk filter di Beranda
  final String category;

  // Constructor: cara membuat objek FoodItem. Yang pakai required wajib diisi
  FoodItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    this.isFavorite = false, // <- tambahan, default belum favorit
    // Kalau tidak diisi, otomatis dianggap 'Makanan'
    this.category = 'Makanan',
  });

  // Getter: menghitung total harga = jumlah porsi x harga per porsi
  int get totalPrice => quantity * price;
  // Harga per porsi dengan titik pemisah ribuan (contoh: 15.000)
  String get formattedPrice => formatPrice(price);
  // Total harga dengan titik pemisah ribuan
  String get formattedTotal => formatPrice(totalPrice);

  // Data contoh menu.
  // static = bisa dipakai langsung lewat FoodItem.sampleData tanpa membuat objek baru.
  // Daftar ini dipakai bersama oleh halaman Beranda dan Favorit, jadi perubahan (favorit / jumlah porsi) selalu sama di kedua halaman
  static final List<FoodItem> sampleData = [
    // Setiap FoodItem(...) di bawah ini mewakili satu menu
    FoodItem(
      name: 'Nasi Goreng',
      description: 'Nasi goreng spesial dengan telur, ayam, dan kerupuk.',
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80&auto=format&fit=crop',
      // Awalnya belum ada porsi yang dipesan
      quantity: 0,
      price: 15000,
    ),
    FoodItem(
      name: 'Mie Goreng',
      description: 'Mie goreng jawa dengan bumbu khas dan sayuran segar.',
      imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=800&q=80&auto=format&fit=crop',
      quantity: 0,
      price: 12000,
    ),
    FoodItem(
      name: 'Ayam Bakar',
      description:
          'Ayam bakar bumbu kecap disajikan dengan sambal dan lalapan.',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80&auto=format&fit=crop',
      quantity: 0,
      price: 25000,
    ),
    FoodItem(
      name: 'Es Teh',
      description: 'Teh manis dingin yang menyegarkan.',
      imageUrl: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80&auto=format&fit=crop',
      quantity: 0,
      price: 5000,
      category: 'Minuman',
    ),
    FoodItem(
      name: 'Es Jeruk',
      description: 'Jeruk peras asli dingin dengan es batu.',
      imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=800&q=80&auto=format&fit=crop',
      quantity: 0,
      price: 6000,
      category: 'Minuman',
    ),
  ];
}

// Fungsi untuk mengubah angka menjadi format ribuan dengan titik.
// Contoh: 15000 menjadi 15.000
String formatPrice(int value) {
  // Angka diubah jadi teks, lalu titik disisipkan setiap 3 digit dari belakang
  return value.toString().replaceAllMapped(
    // Pola pencarian: angka yang setelahnya diikuti kelipatan 3 digit sampai akhir
    RegExp(r'(\d)(?=(\d{3})+$)'),
    // Angka yang cocok ditambah titik di belakangnya
    (m) => '${m[1]}.',
  );
}
