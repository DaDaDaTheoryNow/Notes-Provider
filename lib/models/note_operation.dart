import 'dart:convert';

import 'package:notes_provider/models/note.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesOperations extends ChangeNotifier {
  final List<Note> _notes = <Note>[];

  List<Note> get notes => _notes;

  void addNote(String title, String description) {
    Note note = Note(title, description);

    _notes.add(note);
    saveNotes();

    notifyListeners();
  }

  void deleteNote(index) {
    _notes.removeAt(index);

    saveNotes();

    notifyListeners();
  }

  void resetNotes() {
    _notes.clear();
    saveNotes();

    notifyListeners();
  }

  // load notes
  // ---
  // Add to List<_notes> with indexes
  void loadNotes() async {
    final prefs = await SharedPreferences.getInstance();

    final List<dynamic> jsonNotes = loadNotesFromJson(prefs);

    // Method 'finding the number of indexes'
    List<int> indexes = [];
    for (int i = 0; i < jsonNotes.length; i++) {
      indexes.add(i);
      addNote(
        jsonNotes[i]["title"],
        jsonNotes[i]["description"],
      );
    }

    notifyListeners();
  }

  // save notes
  void saveNotes() {
    return saveNotesToJson();
  }

  // Converting Notes from json to List
  List<dynamic> loadNotesFromJson(SharedPreferences prefs) {
    final getJsonNotes = prefs.getString("Notes");
    List<dynamic> jsonNotes = jsonDecode(getJsonNotes!);

    return jsonNotes;
  }

  // save Notes to json then to SharedPreferences
  void saveNotesToJson() async {
    final prefs = await SharedPreferences.getInstance();

    String setJsonNotes = jsonEncode(_notes);
    prefs.setString("Notes", setJsonNotes);
  }
}
