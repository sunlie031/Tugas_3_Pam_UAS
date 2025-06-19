import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../screens/product_detail.dart';

class FeaturedProducts extends StatelessWidget {
  final List<Product> products;
  FeaturedProducts({super.key, required this.products});

  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Center(
            child: Text(
              "Produk Unggulan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;

              if (constraints.maxWidth > 600) {
                crossAxisCount = 3;
              }
              if (constraints.maxWidth > 900) {
                crossAxisCount = 4;
              }

              return SizedBox(
                height: 240,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];

                    final imagePath =
                        product.image.startsWith('assets/')
                            ? product.image
                            : 'assets/${product.image}';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetail(product: product),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.asset(
                                imagePath,
                                height: 90,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const SizedBox(
                                          height: 90,
                                          child: Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4,
                              ),
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                formatCurrency.format(product.price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    "(${product.rating}) ${product.sales}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
