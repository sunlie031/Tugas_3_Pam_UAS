import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../screens/checkout.dart';
import 'cart.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late int _currentImageIndex;
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  OverlayEntry? _searchOverlay;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _currentImageIndex = 0;
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    quantity = widget.product.stock > 0 ? 1 : 0;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _searchOverlay?.remove();
    super.dispose();
  }

  void _showSearchOverlay(String keyword) {
    _hideSearchOverlay();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final results =
        provider.products
            .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();

    if (results.isEmpty || keyword.isEmpty) return;

    _searchOverlay = OverlayEntry(
      builder:
          (context) => Positioned(
            width: MediaQuery.of(context).size.width - 32,
            top: kToolbarHeight + 12,
            left: 16,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final product = results[index];
                    return ListTile(
                      leading: Image.asset(
                        product.image,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.name),
                      onTap: () {
                        _hideSearchOverlay();
                        _searchController.clear();
                        setState(() => _isSearching = false);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetail(product: product),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_searchOverlay!);
  }

  void _hideSearchOverlay() {
    _searchOverlay?.remove();
    _searchOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images =
        product.subImage.isNotEmpty ? product.subImage : [product.image];
    final displayedImage = images[_currentImageIndex];
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? CompositedTransformTarget(
                  link: _layerLink,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Cari produk...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                      ),
                      onChanged: _showSearchOverlay,
                    ),
                  ),
                )
                : const Text("Detail", style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
              if (_isSearching) {
                FocusScope.of(context).requestFocus(_focusNode);
              } else {
                _hideSearchOverlay();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              height: screenWidth * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  displayedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 64);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (images.length > 1)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() => _currentImageIndex = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                _currentImageIndex == index
                                    ? Colors.deepPurple
                                    : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            images[index],
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormatter.format(product.price),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.stock == 0 ? "Stok Habis" : "Stok: ${product.stock}",
              style: TextStyle(
                fontSize: 14,
                color: product.stock == 0 ? Colors.red : Colors.black,
                fontWeight:
                    product.stock == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Jumlah:", style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                IconButton(
                  onPressed:
                      () =>
                          setState(() => quantity > 1 ? quantity-- : quantity),
                  icon: const Icon(Icons.remove),
                ),
                Text('$quantity', style: const TextStyle(fontSize: 16)),
                IconButton(
                  onPressed:
                      product.stock > 0 && quantity < product.stock
                          ? () => setState(() => quantity++)
                          : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
                label: const Text(
                  "+ Keranjang",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed:
                    product.stock == 0
                        ? null
                        : () {
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).addToCart(widget.product, quantity: quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Produk ditambahkan ke keranjang"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    product.stock == 0
                        ? null
                        : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => CheckoutScreen(
                                    product: widget.product,
                                    quantity: quantity,
                                  ),
                            ),
                          );
                        },
                child: const Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
