import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes_provider/constants.dart';
import 'package:notes_provider/models/user_collection_data_model.dart';
import 'package:notes_provider/providers/auth_service.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users - We are Family"),
        centerTitle: true,
      ),
      body: FutureBuilder<dynamic>(
        future: authService.getAllUsers(),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          List<UsersCollectionData> data = [];

          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData ||
              snapshot.hasError) {
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
                item["avatarUrl"],
              ));
            }
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(data[index].photoURL),
                ),
                title: Row(
                  children: [
                    Text(
                      data[index].name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText(
                            data[index].permission,
                            textStyle: userPermissionTextStyle,
                            speed: Duration(milliseconds: 150),
                          ),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                  ],
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
