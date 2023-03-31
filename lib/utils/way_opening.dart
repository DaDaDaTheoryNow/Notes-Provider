// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_provider/view/pages/login_account_page.dart';
import 'package:notes_provider/view/pages/account_page.dart';

class WayOpening extends StatelessWidget {
  WayOpening({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return const LoginAccountPage();
        }
        // If the user is already signed-in, return the main app UI
        return const AccountPage();
      },
    );
  }
}
