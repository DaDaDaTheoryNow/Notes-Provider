import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notes_provider/providers/bottom_bar_provider.dart';
import 'package:notes_provider/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:notes_provider/utils/check_internet.dart';
import 'package:notes_provider/view/widgets/change_theme_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // get saves notes
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NotesOperations>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    Future<bool> internet = Internet().checkInternet();
    return Scaffold(
      bottomNavigationBar: GNav(
        gap: 10,
        tabBackgroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        tabs: [
          GButton(
            icon: FontAwesomeIcons.house,
            text: "Home",
            iconColor: Theme.of(context).iconTheme.color,
            iconActiveColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryColor,
          ),
          GButton(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: (currentUser != null)
                  ? NetworkImage(currentUser.photoURL!)
                  : null,
              child: (currentUser == null)
                  ? Icon(
                      FontAwesomeIcons.houseChimneyUser,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            text: "Account",
            iconColor: Theme.of(context).iconTheme.color,
            iconActiveColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryColor,
            icon: FontAwesomeIcons.houseChimneyUser,
          ),
        ],
        onTabChange: ((index) {
          Provider.of<BottomBarProvider>(context, listen: false)
              .setIndex(index);
        }),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes with Flutter Provider"),
        titleTextStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        actions: const [
          SizedBox(
            width: 15,
          ),
          ChangeThemeButton(),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Provider.of<BottomBarProvider>(context).getPage(),
    );
  }
}
