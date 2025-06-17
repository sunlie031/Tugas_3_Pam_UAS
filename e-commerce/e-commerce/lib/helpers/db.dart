import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartDB {
  static const String cartKey = 'cart_items';

  static Future<void> saveCartItems(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = items.map((item) => jsonEncode(item.toMap())).toList();

    await prefs.setStringList(cartKey, encodedItems);

    print('Cart disimpan: ${encodedItems.length} item');
  }

  static Future<List<CartItem>> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = prefs.getStringList(cartKey);

    if (encodedItems == null || encodedItems.isEmpty) {
      print('Tidak ada data cart ditemukan di storage.');
      return [];
    }

    final items =
        encodedItems.map((e) => CartItem.fromMap(jsonDecode(e))).toList();
    print('Cart dimuat dari storage: ${items.length} item');

    return items;
  }
}
