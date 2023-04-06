import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_provider/providers/auth_service.dart';
import 'package:notes_provider/utils/check_internet.dart';
import 'package:notes_provider/view/pages/all_users.dart';
import 'package:notes_provider/view/widgets/google_account_avatar.dart';
import 'package:notes_provider/view/widgets/update_note_dialog.dart';
import 'package:notes_provider/view/widgets/user_permission_stream.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color textThemeColor = Theme.of(context).primaryColor;

    final authService = Provider.of<AuthService>(context);

    User? currentUser = FirebaseAuth.instance.currentUser;

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
            GoogleAccountAvatar(currentUser), // user avatar
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: currentUser!.displayName, // user name
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
                    child: UserPermissionStream(currentUser), // user permission
                  )
                ],
              ),
            ),
            Text(
              "${currentUser.email}", // user email
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
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          Future<bool> internet = Internet().checkInternet();

          if (await internet) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return RenameDialog(
                  title: 'Do you really want to delete your account?',
                  content: Center(
                    child: Column(
                      children: [
                        Text(
                          "This action is irreversible.",
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Do not close the application when uninstalling.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onCancelPressed: () {
                    Navigator.of(context).pop();
                  },
                  onOkPressed: () async {
                    if (await internet) {
                      await authService.deleteGoogleAccount(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Error: You need internet connection to delete your account'),
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Error: You need internet connection to delete your account'),
              ),
            );
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.red),
        ),
        child: Text("Delete Account"),
      ),
    );
  }
}
