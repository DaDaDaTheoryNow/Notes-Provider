import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_provider/providers/avatar_service.dart';
import 'package:notes_provider/providers/bottom_bar_provider.dart';
import 'package:notes_provider/providers/notes_provider.dart';
import 'package:notes_provider/utils/loading_utils.dart';
import 'package:notes_provider/utils/way_opening.dart';
import 'package:notes_provider/view/pages/notes_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  bool _loading = false;

  bool? get loading => _loading;

  updateBottomBarPages(BuildContext context) {
    // change List<Widget> pages and updating state of settings page
    Provider.of<BottomBarProvider>(context, listen: false).pages = [
      const NotePage(),
      WayOpening(),
    ];
  }

// Authenticate with Google.
  Future<void> signInWithGoogle(BuildContext context) async {
    // Start loading indicator
    _loading = true;
    LoadingUtils(context).startLoading();
    notifyListeners();

    try {
      // check if the app is running on the web platform
      if (kIsWeb) {
        // if so, use GoogleAuthProvider to authenticate the user with a popup window
        final GoogleAuthProvider authProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(authProvider);
      } else {
        // if not, use GoogleSignIn to prompt the user to select their Google account
        GoogleSignIn googleSignIn = GoogleSignIn();
        GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

        // check if the user has selected an account
        if (googleSignInAccount != null) {
          // if so, get the authentication details from the selected account
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;

          // create an AuthCredential using the authentication details
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          // authenticate the user using the AuthCredential
          await _auth.signInWithCredential(credential);
        }
      }

      // Reload notes and save avatar URL.
      await Provider.of<NotesOperations>(context, listen: false).loadNotes();
      await Provider.of<AvatarService>(context, listen: false)
          .saveAvatarUrl(context);

      // Navigate to the updated settings page.
      updateBottomBarPages(context);
    } on FirebaseAuthException catch (e) {
      // Show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in. Try again. Error: $e'),
        ),
      );
    } catch (e) {
      // Show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in. Try again. Error: $e'),
        ),
      );
    } finally {
      // Stop loading indicator
      LoadingUtils(context).stopLoading();
      _loading = false;
      notifyListeners();
    }
  }

// SignOut from Google Account.
  void signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      deleteFromDevice() async {
        // update page
        updateBottomBarPages(context);

        // delete user avatar(link) form SharedPreferences
        prefs.remove("avatarUrl");

        // disconnect user form the app
        await googleSignIn.disconnect();
      }

      if (kIsWeb) {
        googleSignIn.signOut().then((value) async {
          // delete account from device
          deleteFromDevice();
        });
      } else {
        FirebaseAuth.instance.signOut().then((value) async {
          // delete account from device
          deleteFromDevice();
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out. Try again. Error: $error'),
        ),
      );
    }

    notifyListeners();
  }

// Deleting Google Account.
  Future<void> deleteGoogleAccount(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentUser == null) {
      // user is not authorized, show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authencation error. Try again. Error: signIn please'),
        ),
      );
    }

    // object for work with Google Sign-In API
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // get user's credentials Google
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signInSilently(suppressErrors: true);

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    // object or user's credentials Firebase
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // object of Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference accountCollection =
        firestore.collection('users').doc(currentUser!.uid);

    // object of FireStorage
    final reference =
        storage.ref().child('users/${currentUser.uid}/avatar.jpg');

    try {
      LoadingUtils(context).startLoading();
      // disconnect user form the app
      await googleSignIn.disconnect();

      // delete user data from Firestore
      await accountCollection.delete();

      // delete user avatar from FireStorage
      await reference.delete();

      // delete user from Firebase
      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.delete();
      updateBottomBarPages(context);
      // delete user avatar(link) form SharedPreferences
      await prefs.remove("avatarUrl");
    } on FirebaseAuthException catch (e) {
      // treatment authencation errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authencation error. Try again. Error: $e'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account deletion error. Try again. Error: $e'),
        ),
      );
    } finally {
      // hide loading indicator
      LoadingUtils(context).stopLoading();
    }
    notifyListeners();
  }

// Get all users from FireStore
  Future<List> getAllUsers() async {
    // get snapshot of the collection
    List<dynamic> usersCollections =
        await users.get().then((QuerySnapshot querySnapshot) {
      List<dynamic> collection = [];
      for (var doc in querySnapshot.docs) {
        collection.add(doc
            .data()); // write each document information in List<dynamic> collection
      }
      return collection; // return result
    });

    return usersCollections; // return List<dynamic> with information about all users
  }
}
