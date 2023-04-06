import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_provider/constants.dart';

class UserPermissionStream extends StatelessWidget {
  final User? currentUser;
  const UserPermissionStream(this.currentUser, {super.key});

  @override
  Widget build(BuildContext context) {
    String uid = currentUser!.uid;

    final Stream<DocumentSnapshot> userPermissionStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: userPermissionStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Something wrong!",
            style: TextStyle(color: Colors.red),
          );
        }

        var data = snapshot.data;

        if (data != null && data.exists) {
          return AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                data["Info"][2],
                textStyle: userPermissionTextStyle,
                speed: Duration(milliseconds: 150),
              ),
            ],
            isRepeatingAnimation: false,
          );
        } else {
          return const Text(
            "...",
            style: TextStyle(color: Colors.grey),
          );
        }
      },
    );
  }
}
