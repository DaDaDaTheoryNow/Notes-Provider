import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_provider/models/note_model.dart';
import 'package:notes_provider/utils/check_internet.dart';
import 'package:notes_provider/utils/loading_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesOperations extends ChangeNotifier {
  List<Note> _notes = [];

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

  // <load logic bloc>
  //
  // <main logic for load notes>
  //
  loadNotes(BuildContext context) async {
    Future<bool> internet = Internet().checkInternet();

    if (await internet) {
      debugPrint("load from internet");

      User? currentUser = FirebaseAuth.instance.currentUser;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final prefs = await SharedPreferences.getInstance();
      final getJsonNotes = prefs.getString('Notes');

      // user is login and has json save = combaine firestore + json without duplicates
      if (currentUser != null && getJsonNotes != null) {
        LoadingUtils(context).startLoading();

        final String uid = currentUser.uid;
        final DocumentReference accountCollection =
            firestore.collection('users').doc(uid);

        DocumentSnapshot snapshot = await accountCollection.get();

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          List<Note> tempNoteFireStore = [];
          List<Note> tempNoteJson = [];

          // Parse data from firestore
          for (int i = 0; i < data["Notes"].length; i++) {
            final note = Note(
              data["Notes"][i]['title'],
              data["Notes"][i]['description'],
            );
            tempNoteFireStore.add(note);
          }

          // Parse data from json
          final List<dynamic> jsonNotes = jsonDecode(getJsonNotes);

          for (int i = 0; i < jsonNotes.length; i++) {
            final note = Note(
              jsonNotes[i]["title"],
              jsonNotes[i]["description"],
            );
            tempNoteJson.add(note);
          }

          // Combine the three lists
          List<Note> allNotes = [
            ..._notes,
            ...tempNoteJson,
            ...tempNoteFireStore
          ];

          // Remove duplicates by title
          List<Note> uniqueNotes =
              allNotes.fold<List<Note>>([], (prev, current) {
            if (!prev.any((note) => note.title == current.title)) {
              prev.add(current);
            }
            return prev;
          });

          // Update _notes with the unique notes
          _notes = uniqueNotes;
        }
        LoadingUtils(context).stopLoading();
      } else if (currentUser == null && getJsonNotes != null) {
        // user does not have account
        // load from json

        // Parse data from json
        List<Note> tempNoteJson = [];

        final List<dynamic> jsonNotes = jsonDecode(getJsonNotes);

        for (int i = 0; i < jsonNotes.length; i++) {
          final note = Note(
            jsonNotes[i]["title"],
            jsonNotes[i]["description"],
          );
          tempNoteJson.add(note);
        }

        // Remove duplicates by title
        List<Note> uniqueNotes =
            tempNoteJson.fold<List<Note>>([], (prev, current) {
          if (!prev.any((note) => note.title == current.title)) {
            prev.add(current);
          }
          return prev;
        });

        // Update _notes with the unique notes
        _notes = uniqueNotes;
      }
    } else {
      // user does not have internet
      // load from json
      loadNotesJson();
    }

    saveNotes();
    notifyListeners();
  }
  //
  // <main logic for load notes/>

  // <load json notes>
  loadNotesJson() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final getJsonNotes = prefs.getString('Notes');

      final List<dynamic> jsonNotes = jsonDecode(getJsonNotes!);

      for (int i = 0; i < jsonNotes.length; i++) {
        final note = Note(
          jsonNotes[i]["title"],
          jsonNotes[i]["description"],
        );
        _notes.add(note);
      }
    } catch (error) {
      debugPrint('Error loading notes: $error');
    }
  }
  // <load json notes/>
  //
  // <load logic bloc/>

  // <save logic block>
  //
  // <main logic for save notes>
  //
  saveNotes() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (currentUser != null) {
      final String uid = currentUser.uid;

      // get User Document
      final DocumentReference accountCollection =
          firestore.collection('users').doc(uid);

      DocumentSnapshot snapshot = await accountCollection.get();

      // map note from Note
      List<dynamic> noteMap = _notes.map((note) => note.toMap()).toList();

      // create or update info & notes on firestore
      if (snapshot.exists) {
        accountCollection.set({
          'Info': FieldValue.arrayUnion([
            currentUser.displayName,
          ]),
          'Notes': noteMap,
        }, SetOptions(merge: true));
      } else if (!snapshot.exists) {
        accountCollection.set({
          'Info': [
            currentUser.displayName,
            currentUser.email,
            'user',
          ],
          'Notes': noteMap,
        });
      }
    }

    saveNotesJson();
  }
  // <main logic for save notes/>

  // <save json notes>
  saveNotesJson() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final setJsonNotes = jsonEncode(_notes);
      await prefs.setString('Notes', setJsonNotes);

      debugPrint('Notes json saved successfully.');
    } catch (error) {
      debugPrint('Error saving notes: $error');
    }
  }
  // <save json notes/>
  //
  // <save logic bloc/>
}
