import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_provider/providers/auth_service.dart';
import 'package:notes_provider/view/pages/all_users.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    Color textThemeColor = Theme.of(context).primaryColor;

    final authService = Provider.of<AuthService>(context);

    User? currentUser = FirebaseAuth.instance.currentUser;
    String uid = currentUser!.uid;

    final Stream<DocumentSnapshot> userPermissionStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Account Page",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(currentUser.photoURL!),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: currentUser.displayName,
                    style: TextStyle(
                      color: textThemeColor,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: " ",
                  ),
                  WidgetSpan(
                      child: StreamBuilder<DocumentSnapshot>(
                    stream: userPermissionStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text(
                          "load",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      if (snapshot.error != null) {
                        return const Text(
                          "load",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Text(
                          "Something wrong!",
                          style: TextStyle(color: Colors.red),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting &&
                          snapshot.connectionState == ConnectionState.none) {
                        return const Text(
                          "load",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      var data = snapshot.data;

                      if (data != null && data.exists) {
                        return Text(
                          data["Info"][3],
                          style: const TextStyle(color: Colors.grey),
                        );
                      } else {
                        return const Text(
                          "load",
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                    },
                  ))
                ],
              ),
            ),
            Text(
              "${currentUser.email}",
              style: TextStyle(
                color: textThemeColor,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const AllUsers()),
                        (route) => true);
                  },
                  child: const Text("Users"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    authService.signOut(context);
                  },
                  child: const Text("SignOut"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
