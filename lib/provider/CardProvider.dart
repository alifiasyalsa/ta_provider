import 'package:flutter/material.dart';

class CardColorProvider extends ChangeNotifier {
  Color cardColor = Colors.white;

  void changeCardBackground(Color newCardColor) {
    cardColor = newCardColor;
    notifyListeners();
  }

}