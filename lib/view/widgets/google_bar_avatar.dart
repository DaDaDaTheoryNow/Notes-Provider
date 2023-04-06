import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:notes_provider/providers/avatar_service.dart';
import 'package:notes_provider/utils/check_internet.dart';
import 'package:provider/provider.dart';

class GoogleBarAvatar extends StatelessWidget {
  const GoogleBarAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    final avatarService = Provider.of<AvatarService>(context);

    Future<bool> internet = Internet().checkInternet();

    // checks if there is internet to load an avatar in bar
    return FutureBuilder<bool>(
      future: internet,
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> snapshot,
      ) {
        if (snapshot.data == false) {
          return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              FontAwesomeIcons.houseChimneyUser,
              color: Theme.of(context).primaryColor,
            ),
          );
        }

        return FutureBuilder<String>(
          future: avatarService.getAvatar(),
          builder: (
            BuildContext context,
            AsyncSnapshot<String> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
              );
            }
            return CachedNetworkImage(
              imageUrl: snapshot.data!,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage:
                    (currentUser != null) ? NetworkImage(snapshot.data!) : null,
                child: (currentUser == null)
                    ? Icon(
                        FontAwesomeIcons.houseChimneyUser,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(
                FontAwesomeIcons.houseChimneyUser,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        );
      },
    );
  }
}
