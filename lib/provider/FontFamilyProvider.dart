import 'package:flutter/material.dart';

class FontFamilyProvider extends ChangeNotifier {

  String themeFontFamily = "Arial";

  void changeFontFamily(String newFontFamily) {
    themeFontFamily = newFontFamily;
    notifyListeners();
  }

}