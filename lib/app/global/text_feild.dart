import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? labelColor;
  final Color? cursorColor; // اللون المخصص لمؤشر الكتابة
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLength;
  final TextAlign textAlign;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final Function(String)? onChanged;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? labelStyle;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextDirection? textDirection;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.errorText,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.labelColor,
    this.cursorColor, // تمرير اللون المخصص للمؤشر
    this.borderRadius = 8.0,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.prefixIcon,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.onChanged,
    this.hintStyle,
    this.errorStyle,
    this.labelStyle,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استخدم ThemeData للحصول على الألوان الافتراضية
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      cursorColor: cursorColor ?? colorScheme.primary, // لون المؤشر
      style: TextStyle(
        color: textColor ?? colorScheme.background, // لون النص داخل الحقل
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: hintStyle ??
            TextStyle(
              color: labelColor ?? colorScheme.background, // لون التلميح
              fontSize: fontSize,
            ),
        errorStyle: errorStyle ??
            TextStyle(
              color: colorScheme.error, // لون النص الخاص بالخطأ
              fontSize: fontSize - 2,
            ),
        labelStyle: labelStyle ??
            TextStyle(
              color: labelColor ?? colorScheme.background, // لون النص التوضيحي
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
        filled: true,
        fillColor: backgroundColor ?? colorScheme.onBackground, // لون الخلفية
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? colorScheme.background), // لون الحدود
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? colorScheme.onBackground), // لون الحدود عند التمكين
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor ?? colorScheme.onBackground, // لون الحدود عند التركيز
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: colorScheme.error), // لون الحدود عند وجود خطأ
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onTapSuffixIcon,
                child: suffixIcon,
              )
            : null,
        counterText: "", // إخفاء عداد الأحرف
      ),
    );
  }
}
