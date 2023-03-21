import 'package:notes_provider/models/note_operation.dart';
import 'package:notes_provider/view/screens/add_screen.dart';
import 'package:notes_provider/view/widgets/card_note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Note app with Flutter Provider"),
        ),
        body: Consumer(
          builder: ((context, NotesOperations data, child) {
            return ListView.builder(
              itemCount: data.notes.length,
              itemBuilder: ((context, index) {
                return CardNote(data.notes[index], index);
              }),
            );
          }),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () => context.read<NotesOperations>().resetNotes(),
              child: const Text("Reset"),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const AddScreen()));
              },
              child: const Text("Add"),
            ),
          ],
        ));
  }
}
