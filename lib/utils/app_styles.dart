import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle getTextFieldStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey[600],
    );
  }

  static TextStyle getHeadlineStyle() {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle getButtonTextStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontFamily: 'Poppins1',
      fontWeight: FontWeight.bold,
    );
  }

  static InputDecoration getTextFieldDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: getTextFieldStyle(),
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFff5c30)),
      ),
    );
  }

  static BoxDecoration getGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFff5c30),
          Color(0xFFe74b1a),
        ],
      ),
    );
  }

  static BoxDecoration getButtonDecoration() {
    return BoxDecoration(
      color: Color(0Xffff5722),
      borderRadius: BorderRadius.circular(20),
    );
  }
}