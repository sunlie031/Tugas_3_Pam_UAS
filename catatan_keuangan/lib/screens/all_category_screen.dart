import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';

class AllCategoriesScreen extends StatelessWidget {
  final _controller = TextEditingController();

  void _addCategory(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Tambah Kategori'),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Nama kategori'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = _controller.text.trim();
                  if (name.isNotEmpty) {
                    final newCat = Category(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: name,
                    );
                    Provider.of<CategoryProvider>(
                      context,
                      listen: false,
                    ).addCategory(newCat);
                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Semua Kategori')),
      body: ListView.builder(
        itemCount: categoryProvider.categories.length,
        itemBuilder: (_, index) {
          final cat = categoryProvider.categories[index];
          return ListTile(
            title: Text(cat.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if (cat.id != null) {
                  categoryProvider.deleteCategory(cat.id!);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addCategory(context),
      ),
    );
  }
}
