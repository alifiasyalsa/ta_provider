import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color cardColor = Colors.white;
  Color titleColor = Colors.black;
  double themeFontSize = 10;
  String themeFontFamily = "Arial";
  List<double> imageSize = [100.0,120.0];

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

  void changeImageSize(String newSize){
    if(newSize == "small") {
      this.imageSize = [100.0,120.0];
    }else{
      this.imageSize = [120.0,140.0];
    }

    notifyListeners();
  }
}