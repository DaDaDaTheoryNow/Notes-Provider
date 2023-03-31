import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes_provider/models/users_collection_data_model.dart';
import 'package:notes_provider/providers/auth_service.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
      ),
      body: FutureBuilder<dynamic>(
        future: authService.getAllUsers(),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          List<UsersCollectionData> data = [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: Theme.of(context).primaryColor,
                rightDotColor: Theme.of(context).iconTheme.color!,
                size: 50,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // get all fields from doc
            for (var item in snapshot.data!) {
              data.add(UsersCollectionData(
                item["Info"]![0],
                item["Info"]![1],
                item["Info"]![2],
                item["Info"]![3],
              ));
            }
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(data[index].photoURL),
                ),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: data[index].name,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: "  ",
                      ),
                      TextSpan(
                        text: data[index].permission,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  data[index].email,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
