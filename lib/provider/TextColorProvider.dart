import 'package:flutter/material.dart';

class TextColorProvider extends ChangeNotifier {

  double themeFontSize = 10;
  Color titleColor = Colors.black;

  void changeTextColor(Color newTextColor) {
    titleColor = newTextColor;
    notifyListeners();
  }

}