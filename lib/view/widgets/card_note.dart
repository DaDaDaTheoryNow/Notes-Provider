import 'package:flutter/material.dart';
import 'package:notes_provider/models/note_model.dart';
import 'package:notes_provider/providers/notes_provider.dart';
import 'package:notes_provider/view/widgets/rename_dialog.dart';
import 'package:provider/provider.dart';

class CardNote extends StatelessWidget {
  final Note note;
  final int index;

  const CardNote({Key? key, required this.note, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController newTitleController = TextEditingController();
    final TextEditingController newDescriptionController =
        TextEditingController();

    return Container(
      margin: const EdgeInsets.fromLTRB(7, 15, 7, 15),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          strokeAlign: StrokeAlign.inside,
          width: 3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          color: const Color.fromARGB(255, 230, 226, 226),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            note.description,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    // delete note button
                    Expanded(
                      child: IconButton(
                        onPressed: () =>
                            Provider.of<NotesOperations>(context, listen: false)
                                .deleteNote(index),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        iconSize: 31,
                      ),
                    ),

                    // rename note button
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RenameDialog(
                                title: 'Rename \'${note.title}\' note',
                                content: Column(
                                  children: [
                                    // rename note title
                                    TextField(
                                      controller: newTitleController,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2.2,
                                          ),
                                        ),
                                        hintText: "New Title",
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    // rename note description
                                    TextField(
                                      controller: newDescriptionController,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2.2,
                                          ),
                                        ),
                                        hintText: "New Description",
                                      ),
                                    ),
                                  ],
                                ),
                                onCancelPressed: () {
                                  Navigator.of(context).pop();
                                  newTitleController.clear();
                                  newDescriptionController.clear();
                                },
                                onOkPressed: () {
                                  Provider.of<NotesOperations>(context,
                                          listen: false)
                                      .updateNote(
                                          index,
                                          newTitleController.text,
                                          newDescriptionController.text);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.drive_file_rename_outline_sharp,
                          color: Colors.black,
                        ),
                        iconSize: 31,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
