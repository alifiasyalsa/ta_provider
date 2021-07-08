import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color cardColor = Colors.white;
  Color titleColor = Colors.black;
  double themeFontSize = 10;
  String themeFontFamily = "Arial";

  void changeTextColor(Color newTextColor) {
    titleColor = newTextColor;
    notifyListeners();
  }

  void changeCardBackground(Color newCardColor) {
    cardColor = newCardColor;
    notifyListeners();
  }

  void changeFontSize(double newFontSize) {
    themeFontSize = newFontSize;
    notifyListeners();
  }

  void changeFontFamily(String newFontFamily) {
    themeFontFamily = newFontFamily;
    notifyListeners();
  }
}