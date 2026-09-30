import 'package:flutter/material.dart';

import '../models/food_item.dart';
import 'detail_page.dart';

// StatefulWidget karena daftar favorit bisa berubah
// saat user menghapus favorit dari halaman ini
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // Getter: ambil hanya makanan yang ditandai favorit
  List<FoodItem> get _favorites =>
      FoodItem.sampleData.where((item) => item.isFavorite).toList();

  @override
  Widget build(BuildContext context) {
    final favorites = _favorites;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text(
          'Favorit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Belum ada menu favorit.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    //ditambahin kalo mau menu favorite bisa dilihat detailnya
                    // Navigasi ke DetailPage saat kartu diklik
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            item: item,
                            index: FoodItem.sampleData.indexOf(item),
                          ),
                        ),
                      );

                      // Kalau ada data balik (quantity baru), update state
                      if (result != null && result is int) {
                        setState(() {
                          item.quantity = result;
                        });
                      }
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[200],
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Rp ${item.formattedPrice}/porsi'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          item.isFavorite = false; // hapus dari favorit
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
