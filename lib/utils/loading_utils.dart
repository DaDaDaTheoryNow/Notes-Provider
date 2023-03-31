import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingUtils {
  late BuildContext context;

  LoadingUtils(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor:
              Colors.transparent, // can change this to your prefered color
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: Theme.of(context).primaryColor,
                  rightDotColor: Theme.of(context).iconTheme.color!,
                  size: 50,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }
}
