import 'package:catatan_keuangan/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/category_provider.dart';
import '../screens/add_note_screen.dart';
import '../screens/detail_note_screen.dart';
import '../screens/all_category_screen.dart';
import '../widgets/note_tile.dart';
import '../widgets/note_chart.dart'; // alias NoteSummary

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("asset/Logo.png", width: 30, height: 30),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: Text(
                'Profil',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Kelola Kategori'),
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(12.0), child: NoteSummary()),
            const Divider(),
            Expanded(
              child:
                  noteProvider.notes.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_note,
                              color: Color(0x7030A141),
                              size: 120,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Belum ada catatan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
