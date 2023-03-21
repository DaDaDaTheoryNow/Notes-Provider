import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes_provider/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesOperations extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(String title, String description) {
    final note = Note(title, description);

    _notes.add(note);
    saveNotes();

    notifyListeners();
  }

  void updateNote(int index, String title, String description) {
    final note = Note(title, description);

    _notes[index] = note;
    saveNotes();

    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    saveNotes();

    notifyListeners();
  }

  void resetNotes() {
    _notes.clear();
    saveNotes();

    notifyListeners();
  }

  Future<void> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final getJsonNotes = prefs.getString('Notes');

      final List<dynamic> jsonNotes = jsonDecode(getJsonNotes!);
      _notes.clear();
      for (int i = 0; i < jsonNotes.length; i++) {
        final note = Note(
          jsonNotes[i]['title'],
          jsonNotes[i]['description'],
        );
        _notes.add(note);
      }

      notifyListeners();
    } catch (error) {
      debugPrint('Error loading notes: $error');
    }
  }

  Future<void> saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final setJsonNotes = jsonEncode(_notes);
      await prefs.setString('Notes', setJsonNotes);

      debugPrint('Notes saved successfully.');
    } catch (error) {
      debugPrint('Error saving notes: $error');
    }
  }
}
