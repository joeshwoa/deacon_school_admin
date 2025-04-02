import 'package:flutter/cupertino.dart';

class Unit {
  final BuildContext context;
  final double baseWidth = 375.0;
  final double baseHeight = 914.2857142857143;

  Unit(this.context);

  double get getWidthSize => MediaQuery.of(context).size.width;
  double get getHeightSize => MediaQuery.of(context).size.height;

  double width(double pixels) => (pixels / baseWidth) * getWidthSize;

  double height(double pixels) => (pixels / baseHeight) * getHeightSize;

  double iconSize(double pixels) => ( width(pixels) + height(pixels) ) / 2;

  double fontSize(double pixels) => ( width(pixels) + height(pixels) ) / 2;
}
