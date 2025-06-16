import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Rp ${product.price.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              "Stok: ${product.stock}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(product.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
