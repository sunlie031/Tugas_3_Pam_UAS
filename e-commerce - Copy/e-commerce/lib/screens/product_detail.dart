import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _currentImageIndex = 0;
    _searchController = TextEditingController();
    _focusNode = FocusNode();
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
      builder: (context) {
        return Positioned(
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
        );
      },
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
    final List<String> images =
        product.subImage.isNotEmpty ? product.subImage : [product.image];
    final displayedImage = images[_currentImageIndex];

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
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: _showSearchOverlay,
                    ),
                  ),
                )
                : const Text("Detail", style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
              if (_isSearching) {
                FocusScope.of(context).requestFocus(_focusNode);
              } else {
                _hideSearchOverlay();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
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
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
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
                            onTap: () {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
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
            const SizedBox(height: 24),
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
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, height: 1.4),
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
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("+ Keranjang"),
                onPressed: () {
                  Provider.of<CartProvider>(
                    context,
                    listen: false,
                  ).addToCart(widget.product);
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
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.payment),
                label: const Text("Checkout"),
                onPressed: () {
                  Provider.of<CartProvider>(
                    context,
                    listen: false,
                  ).addToCart(widget.product);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
