import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:notes_provider/providers/avatar_service.dart';
import 'package:provider/provider.dart';

class GoogleAccountAvatar extends StatelessWidget {
  final currentUser;
  const GoogleAccountAvatar(this.currentUser, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatarService = Provider.of<AvatarService>(context);
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
            radius: 60,
            backgroundColor: Colors.transparent,
          );
        }
        return CachedNetworkImage(
          imageUrl: snapshot.data!,
          imageBuilder: (context, imageProvider) => GestureDetector(
            onTap: () {
              avatarService.saveAvatarFile(context);
            },
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              backgroundImage: imageProvider,
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
      },
    );
  }
}
