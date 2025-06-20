import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];
  final List<Product> _cart = [];

  List<Product> get products => [..._products];
  List<Product> get cart => [..._cart];

  Product getById(String id) =>
      _products.firstWhere((product) => product.id == id);

  Future<void> addProduct(Product product) async {
    _products.add(product);
    notifyListeners();
    await _saveProductsToPrefs();
  }

  Future<void> removeProduct(String id) async {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
    await _saveProductsToPrefs();
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productData = prefs.getString('products');

    _products.clear();

    if (productData != null) {
      try {
        final List decoded = json.decode(productData);
        _products.addAll(decoded.map((e) => Product.fromMap(e)).toList());
      } catch (e) {
        debugPrint("Gagal data: $e");
      }
    }

    if (_products.isEmpty) {
      _products.addAll(dummyProducts);
      await _saveProductsToPrefs();
    }

    notifyListeners();
  }

  Future<void> _saveProductsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final productData = json.encode(_products.map((e) => e.toMap()).toList());
    await prefs.setString('products', productData);
  }

  Future<void> addDummyProducts(List<Product> products) async {
    for (var product in products) {
      final exists = _products.any((p) => p.id == product.id);
      if (!exists) {
        _products.add(product);
      }
    }
    await _saveProductsToPrefs();
    notifyListeners();
  }

  List<Product> get featuredProducts {
    List<Product> sorted = List.from(_products);

    sorted.sort((a, b) {
      if (b.rating.compareTo(a.rating) != 0) {
        return b.rating.compareTo(a.rating);
      } else {
        return b.sales.compareTo(a.sales);
      }
    });

    return sorted.take(3).toList();
  }

  Future<void> updateStockAndSales(String productId, int quantity) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index].stock -= quantity;
      _products[index].sales += quantity;
      notifyListeners();
      await _saveProductsToPrefs();
    }
  }
}
