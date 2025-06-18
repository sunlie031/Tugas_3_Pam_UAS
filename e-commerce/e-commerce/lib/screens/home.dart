import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/featured_product.dart';
import 'cart.dart';
import 'history.dart';
import 'product_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _adsController;
  int _currentAdIndex = 0;
  Timer? _adsTimer;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _searchOverlay;
  bool _isSearching = false;
  final LayerLink _layerLink = LayerLink();
  final List<String> adsImages = [
    "asset/ads_1.png",
    "asset/ads_2.png",
    "asset/ads_3.png",
  ];

  int _currentIndex = 0;

  final List<Widget> _pages = [const Placeholder(), const HistoryScreen()];

  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _adsController = PageController();
    _startAdsAutoScroll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  void _startAdsAutoScroll() {
    _adsTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_adsController.hasClients) {
        _currentAdIndex = (_currentAdIndex + 1) % adsImages.length;
        _adsController.animateToPage(
          _currentAdIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _adsController.dispose();
    _adsTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
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
                      focusNode: _focusNode,
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari produk...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                      ),
                      onChanged: _showSearchOverlay,
                    ),
                  ),
                )
                : Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://t4.ftcdn.net/jpg/02/66/71/71/360_F_266717164_J8Fqw4OcXRkKtNwFyHD02zIEsxPI7qHH.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("TOKU", style: TextStyle(fontSize: 18)),
                  ],
                ),
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
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body:
          _currentIndex == 0
              ? Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
                  final allProducts = productProvider.products;
                  final featured = productProvider.featuredProducts;

                  return ListView(
                    children: [
                      SizedBox(
                        height: 180,
                        child: PageView.builder(
                          controller: _adsController,
                          itemCount: adsImages.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              adsImages[index],
                              fit: BoxFit.contain,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      FeaturedProducts(products: featured),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Center(
                          child: Text(
                            "Semua Produk",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      GridView.builder(
                        padding: const EdgeInsets.all(12),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.65,
                            ),
                        itemCount: allProducts.length,
                        itemBuilder: (context, index) {
                          final product = allProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ProductDetail(product: product),
                                ),
                              );
                            },
                            child: ProductCard(product: product),
                          );
                        },
                      ),
                    ],
                  );
                },
              )
              : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 20),
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}
