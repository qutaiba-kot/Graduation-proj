
import 'dart:math';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PipController extends GetxController {
  final floating = Floating();

  Future<void> enablePip(
  BuildContext context, {
  bool autoEnable = false,
}) async {
  final screenSize =
      MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;

  final defaultWidth = (screenSize.width * 0.4).toInt(); 
  final defaultHeight = (screenSize.height * 0.3).toInt();

  final width =  defaultWidth;
  final height =  defaultHeight;

  final rational = Rational(width, height);

  final arguments = autoEnable
      ? OnLeavePiP(
          aspectRatio: rational,
          sourceRectHint: Rectangle<int>(
            ((screenSize.width.toInt() - width) ~/ 2), 
            ((screenSize.height.toInt() - height) ~/ 2), 
            width,
            height,
          ),
        )
      : ImmediatePiP(
          aspectRatio: rational,
          sourceRectHint: Rectangle<int>(
            ((screenSize.width.toInt() - width) ~/ 2),
            ((screenSize.height.toInt() - height) ~/ 2),
            width,
            height,
          ),
        );
  final status = await floating.enable(arguments);
  debugPrint('PiP enabled? $status');
}


}