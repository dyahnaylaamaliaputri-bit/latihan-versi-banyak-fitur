import 'package:flutter/material.dart';

import '../models/food_item.dart';

// StatefulWidget karena _quantity bisa berubah
// saat user tekan tombol + dan -
class DetailPage extends StatefulWidget {
  final FoodItem item; // data makanan yang diklik dari beranda
  final int index; // index makanan di list

  const DetailPage({super.key, required this.item, required this.index});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // STATE: quantity lokal di halaman ini
  late int _quantity;

  @override
  void initState() {
    super.initState();
    // Ambil quantity awal dari item yang dikirim halaman beranda
    _quantity = widget.item.quantity;
  }

  // Hitung total harga berdasarkan quantity lokal
  int get _totalPrice => _quantity * widget.item.price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C00),
        title: Text(
          widget.item.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Tombol back — kirim quantity kembali ke HomePage
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, _quantity),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar makanan
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  widget.item.imageUrl,
                  width: double.infinity,
                  height: 170,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 170,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.fastfood,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card detail makanan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama makanan
                        Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Harga per porsi
                        Text(
                          'Rp ${widget.item.formattedPrice} / porsi',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF5FA86B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Deskripsi
                        Text(
                          widget.item.description,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ===== KONTROL JUMLAH PORSI =====
                        Container(
                          width: double.infinity,
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFF9A7445),
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.format_list_numbered,
                                size: 17,
                                color: Colors.grey,
                              ),

                              const SizedBox(width: 7),

                              const Text(
                                'Jumlah (porsi)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),

                              const Spacer(),

                              // Tombol kurang (-)
                              GestureDetector(
                                onTap: _quantity > 0
                                    ? () {
                                        setState(() {
                                          _quantity--;
                                        });
                                      }
                                    : null,
                                child: const Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Tampilkan jumlah porsi
                              Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Tombol tambah (+)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Total harga
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),

                            Text(
                              _quantity > 0
                                  ? 'Rp ${formatPrice(_totalPrice)}'
                                  : 'Rp 0',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _quantity > 0
                                    ? const Color(0xFF5FA86B)
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tombol Simpan, kembali ke beranda + kirim quantity baru
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton.icon(
                      // Navigator.pop(context, _quantity) → kirim data balik
                      // ke HomePage
                      onPressed: () => Navigator.pop(context, _quantity),
                      icon: const Icon(Icons.shopping_cart, size: 14),
                      label: const Text(
                        'Simpan Pesanan',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
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
}
