import 'package:flutter/material.dart';

class ImageSizeProvider extends ChangeNotifier {

  List<double> imageSize = [100.0,120.0];

  void changeImageSize(String newSize){
    if(newSize == "small") {
      this.imageSize = [100.0,120.0];
    }else{
      this.imageSize = [120.0,140.0];
    }
    notifyListeners();
  }
}