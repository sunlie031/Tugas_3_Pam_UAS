import 'package:catatan_keuangan/screens/product_detail.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      product.image.startsWith("http")
                          ? Image.network(
                            product.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            product.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              style: TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Rp ${product.price.toStringAsFixed(0)}",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
