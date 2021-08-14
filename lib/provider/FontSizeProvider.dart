import 'package:flutter/material.dart';

class FontSizesProvider extends ChangeNotifier {
  double themeFontSize = 10.0;

  void changeFontSize(double newFontSize) {
    themeFontSize = newFontSize;
    notifyListeners();
  }
}