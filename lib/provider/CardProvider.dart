import 'package:flutter/material.dart';

class CardProvider extends ChangeNotifier {
  Color cardColor = Colors.white;

  void changeCardBackground(Color newCardColor) {
    cardColor = newCardColor;
    notifyListeners();
  }

}