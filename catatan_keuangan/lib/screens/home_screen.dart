import 'package:catatan_keuangan/screens/all_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/category_provider.dart';
import '../screens/add_note_screen.dart';
import '../screens/detail_note_screen.dart';
import '../widgets/note_tile.dart';
import '../widgets/note_chart.dart'; // Diganti namanya menjadi NoteSummary

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Catatan Harian')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu', style: TextStyle(fontSize: 24))),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Kelola Kategori'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AllCategoriesScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: NoteSummary()),
          Divider(),
          Expanded(
            child:
                noteProvider.notes.isEmpty
                    ? Center(child: Text('Belum ada catatan'))
                    : ListView.builder(
                      itemCount: noteProvider.notes.length,
                      itemBuilder: (context, index) {
                        final note = noteProvider.notes[index];
                        return NoteTile(
                          note: note,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailNoteScreen(note: note),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
