import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/category_provider.dart';

class NoteSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    // Hitung jumlah catatan per kategori
    Map<int, int> noteCountPerCategory = {};
    for (var note in noteProvider.notes) {
      noteCountPerCategory[note.categoryId] =
          (noteCountPerCategory[note.categoryId] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Statistik Catatan",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        ...categoryProvider.categories.map((category) {
          final count = noteCountPerCategory[category.id] ?? 0;
          return Card(
            child: ListTile(
              title: Text(category.name),
              trailing: Text("$count catatan"),
            ),
          );
        }).toList(),
      ],
    );
  }
}
