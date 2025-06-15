import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';

class DetailNoteScreen extends StatelessWidget {
  final Note note;

  DetailNoteScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    void _deleteNote() {
      Provider.of<NoteProvider>(context, listen: false).deleteNote(note.id!);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [IconButton(icon: Icon(Icons.delete), onPressed: _deleteNote)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            Text(note.content),
            SizedBox(height: 20),
            Text('Tanggal: ${DateFormat('dd MMM yyyy').format(note.date)}'),
          ],
        ),
      ),
    );
  }
}
