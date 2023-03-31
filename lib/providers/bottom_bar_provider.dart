import 'package:flutter/material.dart';
import 'package:notes_provider/utils/way_opening.dart';
import 'package:notes_provider/view/pages/notes_page.dart';

class BottomBarProvider extends ChangeNotifier {
  int _index = 0;

  // list of pages

  List<Widget> _pages = [
    const NotePage(),
    WayOpening(),
  ];

  int get index => _index;

  // setter for pages
  set pages(List<Widget> newPages) {
    _pages = newPages;
    notifyListeners();
  }

  // set index of page
  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

  // return page
  Widget getPage() {
    return _pages.elementAt(_index);
  }
}
