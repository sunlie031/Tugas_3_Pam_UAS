import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/checkout_provider.dart';
import '../screens/product_detail.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  OverlayEntry? _searchOverlay;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  final Set<String> selectedProductIds = {};

  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
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
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                    ),
                    title: Text(product.name, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      _hideSearchOverlay();
                      _searchController.clear();
                      setState(() => _isSearching = false);
                      Navigator.push(
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
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    double total = cartItems
        .where((item) => selectedProductIds.contains(item.product.id))
        .fold(0, (sum, item) => sum + (item.product.price * item.quantity));

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
                : const Text("Keranjang", style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
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
        ],
      ),
      body: SafeArea(
        child:
            cartItems.isEmpty
                ? const Center(
                  child: Text(
                    'Keranjang kosong',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: cartItems.length,
                        separatorBuilder:
                            (context, index) => const Divider(
                              thickness: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final selected = selectedProductIds.contains(
                            item.product.id,
                          );
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: selected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedProductIds.add(item.product.id);
                                      } else {
                                        selectedProductIds.remove(
                                          item.product.id,
                                        );
                                      }
                                    });
                                  },
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.product.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.broken_image_rounded,
                                              ),
                                            ),
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatCurrency.format(
                                          item.product.price,
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          cartProvider.updateQuantity(
                                            item.product.id,
                                            item.quantity - 1,
                                          );
                                        }
                                      },
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      onPressed: () {
                                        cartProvider.updateQuantity(
                                          item.product.id,
                                          item.quantity + 1,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      color: Colors.red,
                                      onPressed: () {
                                        cartProvider.removeFromCart(
                                          item.product.id,
                                        );
                                        selectedProductIds.remove(
                                          item.product.id,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: const Border(
                          top: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatCurrency.format(total),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              final selectedItems =
                                  cartItems
                                      .where(
                                        (item) => selectedProductIds.contains(
                                          item.product.id,
                                        ),
                                      )
                                      .toList();

                              if (selectedItems.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pilih minimal satu produk'),
                                  ),
                                );
                                return;
                              }

                              final checkoutProvider =
                                  Provider.of<CheckoutProvider>(
                                    context,
                                    listen: false,
                                  );
                              final productProvider =
                                  Provider.of<ProductProvider>(
                                    context,
                                    listen: false,
                                  );

                              try {
                                await checkoutProvider.checkoutFromCart(
                                  selectedItems,
                                  productProvider,
                                );

                                for (var item in selectedItems) {
                                  await productProvider.updateStockAndSales(
                                    item.product.id,
                                    item.quantity,
                                  );
                                  await cartProvider.removeFromCart(
                                    item.product.id,
                                  );
                                }

                                selectedProductIds.clear();

                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: const Text(
                                          'Pembayaran Berhasil',
                                        ),
                                        content: const Text(
                                          'Terima kasih telah berbelanja!',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.popUntil(
                                                context,
                                                (route) => route.isFirst,
                                              );
                                            },
                                            child: const Text('Tutup'),
                                          ),
                                        ],
                                      ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Terjadi kesalahan: $e'),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Checkout Sekarang',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
