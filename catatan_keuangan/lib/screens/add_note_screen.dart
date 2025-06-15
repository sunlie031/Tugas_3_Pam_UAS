import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../providers/category_provider.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).loadCategories();
  }

  void _saveNote() {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Semua bidang wajib diisi')));
      return;
    }

    final newNote = Note(
      title: _titleController.text,
      content: _contentController.text,
      date: DateTime.now(),
      categoryId: selectedCategoryId!,
    );

    Provider.of<NoteProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tambah Catatan')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Isi'),
              maxLines: 5,
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Kategori'),
              value: selectedCategoryId,
              items:
                  categoryProvider.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name),
                    );
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategoryId = val;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveNote, child: Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
