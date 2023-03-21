import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:notes_provider/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    //----First we want to get the theme provider----
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DayNightSwitcher(
      //---isDarkMode to return if its dark or not--true or false--
      starsColor: Colors.purple,
      isDarkModeEnabled: themeProvider.isDarkMode,
      onStateChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}
