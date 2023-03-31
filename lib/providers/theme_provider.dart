import 'package:flutter/material.dart';

//---This to switch theme from Switch button----
class ThemeProvider extends ChangeNotifier {
  //-----Store the theme of our app--
  ThemeMode themeMode = ThemeMode.dark;

  //----If theme mode is equal to dark then we return True----
  //-----isDarkMode--is the field we will use in our switch---
  bool get isDarkMode => themeMode == ThemeMode.dark;

  //---implement ToggleTheme function----
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    //---notify material app to update UI----
    notifyListeners();
  }
}

//---------------Themes settings here-----------
class MyThemes {
  //-------------DARK THEME SETTINGS----
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Colors.purple,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.purple,
    ),
    primaryColor: Colors.purple,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    hintColor: Colors.grey,
    //colorScheme: ColorScheme.dark(),
  );

  //-------------light THEME SETTINGS----
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.cyan[400],
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.cyan,
    ),
    primaryColor: Colors.cyan,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    hintColor: Colors.grey,
    //colorScheme: ColorScheme.light(),
  );
}
