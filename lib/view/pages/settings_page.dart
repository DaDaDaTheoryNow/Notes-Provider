import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Settings Page",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            const Text(
              "development...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: Colors.brown.shade800,
              radius: 40,
              child: const Text('Vladislav'),
            )
          ],
        ),
      ),
    );
  }
}
