import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  String _name = 'Nama Belum Disetel';
  String _email = 'Email Belum Disetel';
  bool _isLoading = true;

  String get name => _name;
  String get email => _email;
  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? 'Nama Belum Disetel';
    _email = prefs.getString('user_email') ?? 'Email Belum Disetel';
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    _name = name;
    _email = email;
    notifyListeners();
  }
}
