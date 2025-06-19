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
                      leading: Image.network(
                        product.image,
                        width: 40,
                        height: 40,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                displayedImage,
                height: 270,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            if (images.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children:
                      images.asMap().entries.map((entry) {
                        final index = entry.key;
                        final imageUrl = entry.value;
                        return Expanded(
                          child: GestureDetector(
                            onTap:
                                () =>
                                    setState(() => _currentImageIndex = index),
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
                                  imageUrl,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            const SizedBox(height: 8),
            Text(product.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              currencyFormatter.format(product.price),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
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
                const Icon(Icons.star, color: Colors.amber),
                Text(
                  "(${product.rating.toString()})",
                  style: const TextStyle(fontSize: 14),
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
                  icon: const Icon(Icons.indeterminate_check_box_outlined),
                ),
                Text('$quantity', style: const TextStyle(fontSize: 14)),
                IconButton(
                  onPressed:
                      product.stock > 0 && quantity < product.stock
                          ? () => setState(() => quantity++)
                          : null,
                  icon: const Icon(Icons.add_box_outlined),
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
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
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
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
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
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
