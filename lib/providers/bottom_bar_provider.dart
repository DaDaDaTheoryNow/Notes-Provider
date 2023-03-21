import 'package:flutter/material.dart';
import 'package:notes_provider/view/pages/notes_page.dart';
import 'package:notes_provider/view/pages/settings_page.dart';

class BottomBarProvider extends ChangeNotifier {
  int _index = 0;

  final List _pages = [
    const NotePage(),
    const SettingsPage(),
  ];

  int get index => _index;

  void setIndex(int index) {
    _index = index;
    getPage();
    notifyListeners();
  }

  Widget getPage() {
    return _pages.elementAt(_index);
  }
}
