import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStyle {
  static TextStyle _fontType(
      {required double fontSize, FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static double _getResponsiveFontSize(double baseFontSize) {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final screenHeight = MediaQuery.of(Get.context!).size.height;
    final screenRatio = screenWidth / screenHeight;

    if (screenRatio < 0.6) {
      return baseFontSize * 1.2;
    } else if (screenRatio < 0.8) {
      return baseFontSize * 1.4;
    } else {
      return baseFontSize * 1.6;
    }
  }

  static TextStyle headLine1 = _fontType(
    fontSize: _getResponsiveFontSize(24.0),
    fontWeight: FontWeight.bold,
  );
  static TextStyle headLine2 = _fontType(
    fontSize: _getResponsiveFontSize(20.0),
    fontWeight: FontWeight.bold,
  );
  static TextStyle headLine3 =
      _fontType(fontSize: _getResponsiveFontSize(18.0));
  static TextStyle headLine4 =
      _fontType(fontSize: _getResponsiveFontSize(16.0));
  static TextStyle headLine5 =
      _fontType(fontSize: _getResponsiveFontSize(14.0));
  static TextStyle headLine6 =
      _fontType(fontSize: _getResponsiveFontSize(12.0));

  static TextStyle subTitle1 = _fontType(
    fontSize: _getResponsiveFontSize(18.0),
    color: Colors.grey,
  );
  static TextStyle subTitle2 = _fontType(
    fontSize: _getResponsiveFontSize(16.0),
    color: Colors.grey,
  );
  static TextStyle subTitle3 = _fontType(
    fontSize: _getResponsiveFontSize(14.0),
    color: Colors.grey,
  );
  static TextStyle subTitle4 = _fontType(
    fontSize: _getResponsiveFontSize(12.0),
    color: Colors.grey,
  );
  static TextStyle subTitle5 = _fontType(
    fontSize: _getResponsiveFontSize(10.0),
    color: Colors.grey,
  );

  static TextStyle bodyText1 = _fontType(
    fontSize: _getResponsiveFontSize(16.0),
    fontWeight: FontWeight.bold,
  );
  static TextStyle bodyText2 = _fontType(
    fontSize: _getResponsiveFontSize(14.0),
  );

  static TextStyle bodyText3 = _fontType(
    fontSize: _getResponsiveFontSize(12.0),
  );

  static TextStyle bodyText4 = _fontType(
    fontSize: _getResponsiveFontSize(10.0),
  );

  static TextStyle bodyText5 = _fontType(
    fontSize: _getResponsiveFontSize(8.0),
  );

  static TextStyle button = _fontType(fontSize: _getResponsiveFontSize(16.0));
  static TextStyle smallButton = _fontType(
    fontSize: _getResponsiveFontSize(12.0),
  );
}
