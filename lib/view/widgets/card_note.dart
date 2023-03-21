import 'package:notes_provider/models/note.dart';
import 'package:notes_provider/models/note_operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardNote extends StatelessWidget {
  final Note note;
  final int index;

  const CardNote(this.note, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Card(
          color: const Color.fromARGB(255, 230, 226, 226),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      note.description,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: IconButton(
                    onPressed: () =>
                        Provider.of<NotesOperations>(context, listen: false)
                            .deleteNote(index),
                    icon: const Icon(Icons.delete),
                    iconSize: 31,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
