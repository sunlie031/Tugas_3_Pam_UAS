import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> loadCategories() async {
    _categories = await DBHelper.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    final id = await DBHelper.insertCategory(category);
    _categories.add(category.copyWith(id: id));
    notifyListeners();
  }

  void deleteCategory(int i) {}
}
