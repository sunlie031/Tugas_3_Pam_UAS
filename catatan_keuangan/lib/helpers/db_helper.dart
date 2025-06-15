import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';
import '../models/category.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'notes.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT,
            categoryId INTEGER,
            FOREIGN KEY (categoryId) REFERENCES categories(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
        await db.insert("users", {
          "email": "admin@gmail.com",
          "password": "admin123",
        });
      },
      version: 1,
    );
  }

  // Note CRUD
  static Future<int> insertNote(Note note) async {
    final db = await database();
    return db.insert('notes', note.toMap());
  }

  static Future<List<Note>> getNotes() async {
    final db = await database();
    final data = await db.query('notes');
    return data.map((e) => Note.fromMap(e)).toList();
  }

  static Future<int> updateNote(Note note) async {
    final db = await database();
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<void> deleteNote(int id) async {
    final db = await database();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // Category CRUD
  static Future<int> insertCategory(Category category) async {
    final db = await database();
    return db.insert('categories', category.toMap());
  }

  static Future<List<Category>> getCategories() async {
    final db = await database();
    final data = await db.query('categories');
    return data.map((e) => Category.fromMap(e)).toList();
  }

  static Future<void> deleteCategory(int id) async {
    final db = await database();
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> insertUser(String email, String password) async {
    final db = await database();
    return db.insert("users", {"email": email, "password": password});
  }

  static Future<bool> checkUser(String email, String password) async {
    final db = await database();
    final result = await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
}
