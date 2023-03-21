import 'package:flutter/material.dart';
import 'package:notes_provider/providers/notes_provider.dart';
import 'package:notes_provider/view/pages/add_page.dart';
import 'package:notes_provider/view/widgets/card_note.dart';
import 'package:provider/provider.dart';

class NotePage extends StatelessWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
          builder: ((context, NotesOperations data, child) {
            return (data.notes.isNotEmpty)
                ? ListView.builder(
                    itemCount: data.notes.length,
                    itemBuilder: ((context, index) {
                      return CardNote(
                        note: data.notes[index],
                        index: index,
                      );
                    }),
                  )
                : Center(
                    child: Text(
                      "Nothing here yet  ;(",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  );
          }),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () => context.read<NotesOperations>().resetNotes(),
              label: const Text("reset"),
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
                        builder: (BuildContext context) => const AddPage()));
              },
              child: const Text("Add"),
            ),
          ],
        ));
  }
}
