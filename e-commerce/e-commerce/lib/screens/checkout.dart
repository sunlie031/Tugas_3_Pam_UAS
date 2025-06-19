import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/product.dart';
import '../models/checkout.dart';
import '../providers/product_provider.dart';
import '../providers/checkout_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final Product? product;
  final int quantity;
  final List<CheckoutItem>? checkoutItems;
  final bool isReview;

  const CheckoutScreen({
    Key? key,
    required this.product,
    required this.quantity,
  }) : checkoutItems = null,
       isReview = false,
       super(key: key);

  const CheckoutScreen.review({Key? key, required this.checkoutItems})
    : product = null,
      quantity = 0,
      isReview = true,
      super(key: key);

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
    if (_quantity < widget.product!.stock) {
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
    final product = widget.product!;
    if (product.stock <= 0 || _quantity > product.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stok produk tidak mencukupi.')),
      );
      return;
    }

    final checkoutItem = CheckoutItem(
      productId: product.id,
      productName: product.name,
      productPrice: product.price,
      quantity: _quantity,
      productImage: product.image,
    );

    try {
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).updateStockAndSales(product.id, _quantity);

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
        const SnackBar(content: Text("Terjadi kesalahan saat checkout.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (widget.isReview && widget.checkoutItems != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pembelian')),
        body: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.checkoutItems!.length,
            itemBuilder: (context, index) {
              final item = widget.checkoutItems![index];
              final total = item.quantity * item.productPrice;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                leading: Image.asset(
                  item.productImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                ),
                title: Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('Jumlah: ${item.quantity}'),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(currencyFormat.format(item.productPrice)),
                    Text(
                      "Total: ${currencyFormat.format(total)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

    final product = widget.product!;
    final total = product.price * _quantity;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontSize: 18)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.image,
                  height: screenWidth * 0.6,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: screenWidth * 0.6,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 60),
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.stock <= 0
                    ? "Stok Habis"
                    : "Stok tersedia: ${product.stock}",
                style: TextStyle(
                  color: product.stock <= 0 ? Colors.red : Colors.grey,
                  fontWeight:
                      product.stock <= 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(product.price),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        side: const BorderSide(color: Colors.black),
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
        ),
      ),
    );
  }
}
