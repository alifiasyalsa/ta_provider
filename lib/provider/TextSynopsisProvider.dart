import 'package:flutter/material.dart';

class TextSynopsisProvider extends ChangeNotifier {
  Color synopsisFontColor = Colors.black;
  double synopsisFontSize = 10;

  void changeSynopsisFontColor(Color newFontColor) {
    synopsisFontColor = newFontColor;
    notifyListeners();
  }

  void changeSynopsisFontSize(double newFontSize) {
    synopsisFontSize = newFontSize;
    notifyListeners();
  }

}