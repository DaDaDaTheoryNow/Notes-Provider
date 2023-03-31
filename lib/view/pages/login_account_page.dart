import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes_provider/providers/auth_service.dart';
import 'package:notes_provider/utils/check_internet.dart';
import 'package:provider/provider.dart';

class LoginAccountPage extends StatefulWidget {
  const LoginAccountPage({super.key});

  @override
  State<LoginAccountPage> createState() => _LoginAccountPageState();
}

class _LoginAccountPageState extends State<LoginAccountPage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    bool loading = authService.loading!;

    return Scaffold(
      body: Center(
        child: (!loading)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Account",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  const Text(
                    "For using the account you need to register.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          Future<bool> internet = Internet().checkInternet();

                          Future<void> signInWithGoogle() {
                            return authService.signInWithGoogle(context);
                          }

                          ScaffoldMessengerState scaffoldMessenger =
                              ScaffoldMessenger.of(context);

                          if (await internet) {
                            await signInWithGoogle();
                          } else {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Error: You need internet connection to signing'),
                              ),
                            );
                          }
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: "SignIn with Google",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: "  ",
                              ),
                              WidgetSpan(
                                child: FaIcon(
                                  FontAwesomeIcons.google,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : LoadingAnimationWidget.beat(
                color: Theme.of(context).primaryColor,
                size: 90,
              ),
      ),
    );
  }
}
