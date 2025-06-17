import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/checkout.dart';

class CheckoutProvider with ChangeNotifier {
  final List<Checkout> _history = [];

  List<Checkout> get history => List.unmodifiable(_history);

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('checkout_history');

    if (data != null) {
      final List decoded = json.decode(data);
      final List<Checkout> loadedHistory =
          decoded.map((item) => Checkout.fromJson(item)).toList();

      if (_isHistoryChanged(loadedHistory)) {
        _history
          ..clear()
          ..addAll(loadedHistory);
        notifyListeners();
      }
    }
  }

  bool _isHistoryChanged(List<Checkout> newHistory) {
    if (_history.length != newHistory.length) return true;

    for (int i = 0; i < _history.length; i++) {
      final a = _history[i];
      final b = newHistory[i];
      if (a.timestamp != b.timestamp || a.items.length != b.items.length) {
        return true;
      }
    }

    return false;
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_history.map((e) => e.toJson()).toList());
    await prefs.setString('checkout_history', data);
  }

  bool _isDuplicateCheckout(Checkout newCheckout) {
    for (final checkout in _history) {
      final isCloseTime =
          checkout.timestamp.difference(newCheckout.timestamp).inSeconds.abs() <
          2;
      final sameItems =
          checkout.items.length == newCheckout.items.length &&
          checkout.items.every(
            (item) => newCheckout.items.any(
              (i) =>
                  i.productId == item.productId &&
                  i.quantity == item.quantity &&
                  i.productPrice == item.productPrice,
            ),
          );

      if (isCloseTime && sameItems) {
        return true;
      }
    }
    return false;
  }

  Future<void> checkoutSingleItem({
    required CheckoutItem checkoutItem,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final newCheckout = Checkout(
        items: [checkoutItem],
        timestamp: DateTime.now(),
      );

      if (!_isDuplicateCheckout(newCheckout)) {
        _history.add(newCheckout);
        await _saveHistory();
        notifyListeners();
        print("Checkout berhasil disimpan");
      } else {
        print("Checkout dibatalkan: terdeteksi duplikat");
      }

      await Future.delayed(const Duration(milliseconds: 500));
      onSuccess();
    } catch (e) {
      onError('Gagal melakukan checkout: $e');
    }
  }
}
