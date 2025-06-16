import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_time.dart';

class CartDB {
  static const String cartKey = 'cart_items';

  static Future<void> saveCartItems(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = items.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(cartKey, encodedItems);
  }

  static Future<List<CartItem>> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = prefs.getStringList(cartKey) ?? [];

    return encodedItems.map((e) => CartItem.fromMap(jsonDecode(e))).toList();
  }
}
