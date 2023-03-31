import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_provider/providers/bottom_bar_provider.dart';
import 'package:notes_provider/providers/notes_provider.dart';
import 'package:notes_provider/utils/loading_utils.dart';
import 'package:notes_provider/utils/way_opening.dart';
import 'package:notes_provider/view/pages/notes_page.dart';
import 'package:provider/provider.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _loading = false;

  User? get user => _user;
  bool? get loading => _loading;

  updatePageState(BuildContext context) {
    // change List<Widget> pages and updating state of settings page
    Provider.of<BottomBarProvider>(context, listen: false).pages = [
      const NotePage(),
      WayOpening(),
    ];
  }

  Future<void> signInWithGoogle(context) async {
    // notify ui about loading
    _loading = true;
    LoadingUtils(context).startLoading();
    notifyListeners();

    // <login logic>
    if (kIsWeb) {
      final GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);
        _user = userCredential.user;
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          _user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing in. Try again. Error: $e'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing in. Try again. Error: $e'),
            ),
          );
        } finally {
          LoadingUtils(context).stopLoading();
        }
      } else {
        // if user == null
        LoadingUtils(context).stopLoading();
      }
    }
    // <login logic/>

    // go to updated settings page
    updatePageState(context);

    // notify ui about loading
    _loading = false;
    Provider.of<NotesOperations>(context, listen: false).loadNotes();

    notifyListeners();
  }

  void signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        googleSignIn.signOut().then((value) => updatePageState(context));
      }
      await FirebaseAuth.instance
          .signOut()
          .then((value) => updatePageState(context));
      _user = null;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out. Try again. Error: $error'),
        ),
      );
    }

    notifyListeners();
  }

  getAllUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    List<dynamic> usersCollections =
        await users.get().then((QuerySnapshot querySnapshot) {
      List<dynamic> collection = [];
      for (var doc in querySnapshot.docs) {
        collection.add(doc.data());
      }
      return collection;
    });

    return usersCollections;
  }
}
