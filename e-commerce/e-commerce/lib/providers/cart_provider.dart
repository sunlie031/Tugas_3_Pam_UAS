import 'package:flutter/foundation.dart';
import '../models/cart_time.dart';
import '../models/product.dart';
import '../helpers/db.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    saveCartToPrefs();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    saveCartToPrefs();
    notifyListeners();
  }

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  Future<void> loadCartFromPrefs() async {
    _items = await CartDB.loadCartItems();
    notifyListeners();
  }

  void saveCartToPrefs() {
    CartDB.saveCartItems(_items);
  }
}
