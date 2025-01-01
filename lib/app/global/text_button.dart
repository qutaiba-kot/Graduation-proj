import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text; 
  final Color textColor; 
  final double fontSize;
  final FontWeight fontWeight; 
  final VoidCallback onPressed; 
  final Color backgroundColor;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      style: TextButton.styleFrom(
        foregroundColor: textColor, backgroundColor: backgroundColor, 
        textStyle: TextStyle(
          fontSize: fontSize, 
          fontWeight: fontWeight,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), 
      ),
      child: Text(text),
    );
  }
}
