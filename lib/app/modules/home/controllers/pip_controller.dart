
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
  // الحصول على حجم الشاشة بالبكسل
  final screenSize =
      MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;

  // تحديد العرض والارتفاع الافتراضي لـ PiP (إذا لم يتم تحديدهما)
  final defaultWidth = (screenSize.width * 0.4).toInt();  // 40% من عرض الشاشة
  final defaultHeight = (screenSize.height * 0.3).toInt(); // 30% من ارتفاع الشاشة

  final width =  defaultWidth;
  final height =  defaultHeight;

  // حساب نسبة العرض إلى الارتفاع بناءً على القيم المحددة
  final rational = Rational(width, height);

  // تحديد مستطيل PiP بحيث يكون في منتصف الشاشة أفقيًا
  final arguments = autoEnable
      ? OnLeavePiP(
          aspectRatio: rational,
          sourceRectHint: Rectangle<int>(
            ((screenSize.width.toInt() - width) ~/ 2),  // المنتصف أفقيًا
            ((screenSize.height.toInt() - height) ~/ 2), // المنتصف عموديًا
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

  // تفعيل وضع PiP
  final status = await floating.enable(arguments);
  debugPrint('PiP enabled? $status');
}


}