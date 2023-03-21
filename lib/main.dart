import 'package:notes_provider/providers/bottom_bar_provider.dart';
import 'package:notes_provider/providers/notes_provider.dart';
import 'package:notes_provider/providers/theme_provider.dart';
import 'package:notes_provider/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<NotesOperations>(
                create: (_) => NotesOperations()),
            ChangeNotifierProvider<BottomBarProvider>(
                create: (_) => BottomBarProvider()),
          ],
          child: ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
            builder: (context, _) {
              final themeProvider = Provider.of<ThemeProvider>(context);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: MyThemes.lightTheme,
                darkTheme: MyThemes.darkTheme,
                themeMode: themeProvider.themeMode,
                home: const HomePage(),
              );
            },
          )),
    );
