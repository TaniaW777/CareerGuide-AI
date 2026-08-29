import 'package:flutter/material.dart';

class AppColors {
  // Light Theme - Academic Blue & Gold
  static const Color primaryLight = Color(0xFF0A4B8F); // Academic Blue
  static const Color accentLight = Color(0xFFF5A623);  // Education Gold/Yellow
  static const Color secondaryLight = Color(0xFF00897B); // Education Teal
  static const Color backgroundLight = Color(0xFFF8F9FA); // Off-white background
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onPrimaryLight = Colors.white;
  static const Color onSurfaceLight = Color(0xFF1A1C1E);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color errorLight = Color(0xFFBA1A1A);
  
  // Specific for Text Fields
  static const Color textFieldBackground = Colors.white;
  static const Color textFieldText = Colors.black;
  static const Color textFieldHint = Color(0xFF9CA3AF);
  static const Color searchBarColor = Color(0xFFF3F4F6); // Light grey

  // Dark Theme - Premium Night Palette (Blue & Gold)
  static const Color primaryDark = Color(0xFF64B5F6); // Light Blue for contrast
  static const Color accentDark = Color(0xFFFFCA28);  // Pale Gold
  static const Color secondaryDark = Color(0xFF4DD0E1); // Light Teal
  static const Color backgroundDark = Color(0xFF0F172A); // Deep Night Blue
  static const Color surfaceDark = Color(0xFF1E293B); // Slate-Blue Surface
  static const Color onPrimaryDark = Color(0xFF0F172A); // Text on primary should be dark for light primary
  static const Color onSurfaceDark = Color(0xFFF1F5F9);
  static const Color borderDark = Color(0xFF27374D); // Subtle border
  static const Color errorDark = Color(0xFFFFB4AB);
}
