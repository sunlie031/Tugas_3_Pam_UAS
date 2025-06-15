import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await DBHelper.getNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    final id = await DBHelper.insertNote(note);
    _notes.add(note.copyWith(id: id));
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await DBHelper.deleteNote(id);
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
