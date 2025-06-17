import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/product.dart';
import '../models/checkout.dart';
import '../providers/product_provider.dart';
import '../providers/checkout_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final Product product;
  final int quantity;

  const CheckoutScreen({
    Key? key,
    required this.product,
    required this.quantity,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  void _increaseQuantity() {
    if (_quantity < widget.product.stock) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _cancelCheckout() {
    Navigator.pop(context);
  }

  Future<void> _completeCheckout(BuildContext context) async {
    if (widget.product.stock <= 0 || _quantity > widget.product.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stok produk tidak mencukupi.')),
      );
      return;
    }

    final checkoutItem = CheckoutItem(
      productId: widget.product.id,
      productName: widget.product.name,
      productPrice: widget.product.price,
      quantity: _quantity,
      productImage: widget.product.image,
    );

    try {
      // Update stok produk
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).updateStockAndSales(widget.product.id, _quantity);

      // Proses checkout
      await Provider.of<CheckoutProvider>(
        context,
        listen: false,
      ).checkoutSingleItem(
        checkoutItem: checkoutItem,
        onSuccess: () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text("Pembayaran Berhasil"),
                  content: const Text("Terima kasih telah berbelanja!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
          );
        },
        onError: (errorMessage) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat checkout")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final total = product.price * _quantity;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (product.stock <= 0)
                  const Text(
                    "Stok Habis",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    "Stok tersedia: ${product.stock}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(product.price),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Jumlah:", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _decreaseQuantity,
                    ),
                    Text('$_quantity', style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _increaseQuantity,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormat.format(total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _cancelCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            (_quantity > 0 &&
                                    product.stock > 0 &&
                                    _quantity <= product.stock)
                                ? () => _completeCheckout(context)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Beli Sekarang",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
