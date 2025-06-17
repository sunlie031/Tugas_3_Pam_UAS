import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/checkout.dart';

class CheckoutProvider with ChangeNotifier {
  final List<Checkout> _history = [];

  List<Checkout> get history => List.unmodifiable(_history);

  /// Load history saat app dimulai
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('checkout_history');
    if (data != null) {
      final List decoded = json.decode(data);
      _history.clear();
      _history.addAll(decoded.map((e) => Checkout.fromJson(e)).toList());
      notifyListeners();
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_history.map((e) => e.toJson()).toList());
    await prefs.setString('checkout_history', data);
  }

  Future<void> checkoutSingleItem({
    required CheckoutItem checkoutItem,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final checkout = Checkout(
        items: [checkoutItem],
        timestamp: DateTime.now(),
      );

      _history.add(checkout);
      await _saveHistory();
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      onSuccess();
    } catch (e) {
      onError('Gagal melakukan checkout: $e');
    }
  }
}
