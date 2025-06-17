import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../helpers/db.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    saveCartToPrefs();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    saveCartToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    saveCartToPrefs();
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity = newQuantity;
      saveCartToPrefs();
      notifyListeners();
    }
  }

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  void saveCartToPrefs() {
    CartDB.saveCartItems(_items);
  }

  Future<void> loadCartFromPrefs() async {
    _items = await CartDB.loadCartItems();
    notifyListeners();
  }
}
