import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_provider/utils/loading_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarService extends ChangeNotifier {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // save avatar url in firestore
  saveAvatarUrl(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentUser != null) {
      // get User Storage
      final reference =
          storage.ref().child('users/${currentUser.uid}/avatar.jpg');

      // check files exists in firestore
      bool fileExists = await reference
          .getDownloadURL()
          .then((_) => true)
          .catchError((error) => false);
      if (!fileExists) {
        // file not exists
        try {
          // save User Avatar
          final Response response = await Dio().get(
            currentUser.photoURL!,
            options: Options(responseType: ResponseType.bytes),
          );
          final Uint8List bytes = response.data;
          await reference.putData(bytes);

          final downloadUrl = await reference.getDownloadURL();
          final userRef = firestore.collection('users').doc(currentUser.uid);
          await userRef.update({'avatarUrl': downloadUrl});

          // cache avatar
          prefs.setString("avatarUrl", downloadUrl);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error save your avatar. Try again. Error: $error'),
            ),
          );
        }
      } else {
        // file exists
        final downloadUrl = await reference.getDownloadURL();
        final userRef = firestore.collection('users').doc(currentUser.uid);
        await userRef.update({'avatarUrl': downloadUrl});

        // cache avatar
        prefs.setString("avatarUrl", downloadUrl);
      }
    }
  }

  // save avatar in firestorage
  // pick avatar from device
  saveAvatarFile(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentUser != null) {
      // get User Storage
      final reference =
          storage.ref().child('users/${currentUser.uid}/avatar.jpg');

      final imagePicker = ImagePicker();

      try {
        LoadingUtils(context).startLoading();
        final imageFile =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (imageFile != null) {
          // get file from device
          final file = File(imageFile.path);
          await reference.putFile(file);

          // save avater url in firestore
          final downloadUrl = await reference.getDownloadURL();
          final firestore = FirebaseFirestore.instance;
          final userRef = firestore.collection('users').doc(currentUser.uid);
          await userRef.update({'avatarUrl': downloadUrl});

          await prefs
              .setString("avatarUrl", downloadUrl)
              .then((value) => LoadingUtils(context).stopLoading());
        } else {
          LoadingUtils(context).stopLoading();
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error save your avatar. Try again. Error: $error'),
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<String> getAvatar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String avatarUrl = prefs.getString("avatarUrl") ?? "null";
    return avatarUrl;
  }
}
