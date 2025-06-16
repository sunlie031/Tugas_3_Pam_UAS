import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => [..._products];

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
}
