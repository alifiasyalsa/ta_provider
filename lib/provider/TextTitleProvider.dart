import 'package:flutter/material.dart';

class TextTitleProvider extends ChangeNotifier {
  Color titleFontColor = Colors.white;
  double titleFontSize = 20;

  void changeTitleFontColor(Color newFontColor) {
    titleFontColor = newFontColor;
    notifyListeners();
  }

  void changeTitleFontSize(double newFontSize) {
    titleFontSize = newFontSize;
    notifyListeners();
  }

}