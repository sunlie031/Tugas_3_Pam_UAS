import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../helpers/db.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;
  bool _isLoaded = false;

  List<CartItem> get items => _items;

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  Future<void> loadCartFromPrefs() async {
    if (_isLoaded || _isLoading) return;

    _isLoading = true;
    try {
      _items = await CartDB.loadCartItems();
      _isLoaded = true;
      debugPrint(
        'Data keranjang berhasil dimuat dari penyimpanan: ${_items.length} item',
      );
    } catch (e) {
      debugPrint('Gagal memuat data keranjang: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _ensureCartLoaded() async {
    if (!_isLoaded) {
      await loadCartFromPrefs();
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    await _ensureCartLoaded();

    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final newQty = _items[index].quantity + quantity;
      if (newQty > product.stock) {
        debugPrint(
          'Jumlah melebihi stok (${product.stock}) untuk produk ${product.name}',
        );
        return;
      }
      _items[index].quantity = newQty;
      debugPrint(
        'Jumlah produk "${product.name}" diperbarui menjadi ${_items[index].quantity}',
      );
    } else {
      if (quantity > product.stock) {
        debugPrint(
          'Jumlah awal melebihi stok (${product.stock}) untuk produk ${product.name}',
        );
        return;
      }
      _items.add(CartItem(product: product, quantity: quantity));
      debugPrint('Produk "${product.name}" ditambahkan ke keranjang');
    }

    await _saveCartToPrefs();
  }

  Future<void> removeFromCart(String productId) async {
    await _ensureCartLoaded();
    _items.removeWhere((item) => item.product.id == productId);
    debugPrint('Produk dengan ID $productId dihapus dari keranjang');
    await _saveCartToPrefs();
  }

  Future<void> clearCart() async {
    await _ensureCartLoaded();
    _items.clear();
    debugPrint('Keranjang dikosongkan');
    await _saveCartToPrefs();
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    await _ensureCartLoaded();

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final stock = _items[index].product.stock;
      if (newQuantity > stock) {
        debugPrint(
          'Jumlah melebihi stok (${stock}) untuk produk ${_items[index].product.name}',
        );
        return;
      }

      _items[index].quantity = newQuantity;
      debugPrint(
        'Jumlah produk "${_items[index].product.name}" diubah menjadi $newQuantity',
      );
      await _saveCartToPrefs();
    }
  }

  Future<void> _saveCartToPrefs() async {
    await CartDB.saveCartItems(_items);
    debugPrint('Data keranjang disimpan: ${_items.length} item');
    notifyListeners();
  }

  Future<bool> checkout(
    Function(String productId, int quantity) updateStockAndSales, {
    required Function(String errorMessage) onError,
  }) async {
    await _ensureCartLoaded();

    for (final item in _items) {
      final stock = item.product.stock;
      if (item.quantity > stock) {
        onError(
          'Jumlah produk "${item.product.name}" melebihi stok tersedia ($stock)',
        );
        return false;
      }
    }

    for (final item in _items) {
      updateStockAndSales(item.product.id, item.quantity);
    }

    await clearCart();
    debugPrint('Checkout berhasil. Stok diperbarui dan keranjang dikosongkan.');
    return true;
  }
}
