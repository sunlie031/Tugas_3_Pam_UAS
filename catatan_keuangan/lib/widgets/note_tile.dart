import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final String? subtitle;
  final VoidCallback onTap;

  const NoteTile({required this.note, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(subtitle ?? note.content),
      onTap: onTap,
    );
  }
}
