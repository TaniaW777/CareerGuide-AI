import 'package:flutter/material.dart';

class AppColors {
  // --- LIGHT THEME (Original Restored) ---
  static const Color primaryLight = Color(0xFF0A4B8F); // Academic Blue
  static const Color accentLight = Color(0xFFF5A623);  // Education Gold
  static const Color secondaryLight = Color(0xFF00897B); // Education Teal
  static const Color backgroundLight = Color(0xFFF8F9FA); 
  static const Color surfaceLight = Colors.white;
  static const Color onPrimaryLight = Colors.white;
  static const Color onSurfaceLight = Color(0xFF1A1C1E);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color successLight = Color(0xFF2E7D32);
  static const Color warningLight = Color(0xFFF57C00);
  
  static const Color textFieldBackground = Colors.white;
  static const Color textFieldHint = Color(0xFF9CA3AF);

  // --- DARK THEME (Premium Education Theme) ---
  // Background: Deep educational navy
  static const Color backgroundDark = Color(0xFF0D1B2A); // Ultra deep navy for long reading sessions
  
  // Primary Surface: Sophisticated slate
  static const Color surfaceDark = Color(0xFF1A2332); // Rich dark blue-grey for cards
  static const Color surfaceDarkSecondary = Color(0xFF243447); // Slightly lighter for layering
  
  // Primary Actions: Bright, energetic cyan-blue (for hope/growth in education)
  static const Color primaryDark = Color(0xFF00D4FF); // Vivid cyan for primary actions
  static const Color primaryDarkAlt = Color(0xFF38BDF8); // Sky blue alternative
  
  // Accent: Warm gold for achievement/success
  static const Color accentDark = Color(0xFFFDD835); // Bright achievement gold
  static const Color accentDarkSecondary = Color(0xFFFBC02D); // Slightly muted gold
  
  // Secondary Colors for variety
  static const Color secondaryDark = Color(0xFF26C6DA); // Teal for positive actions
  static const Color warningDark = Color(0xFFFF9800); // Warm orange for alerts
  static const Color errorDark = Color(0xFFFF6B6B); // Bright red for errors
  static const Color successDark = Color(0xFF4CAF50); // Green for success
  
  // Text Colors
  static const Color onPrimaryDark = Color(0xFF0D1B2A); // Dark text on primary
  static const Color onSurfaceDark = Color(0xFFF1F5F9); // Clean light text on surfaces
  static const Color onSurfaceVariantDark = Color(0xFFCBD5E1); // Muted text for secondary info
  static const Color textMutedDark = Color(0xFF94A3B8); // Very muted grey-blue text
  
  // Borders and Dividers
  static const Color borderDark = Color(0xFF334155); // Visible but subtle borders
  static const Color borderDarkLight = Color(0xFF475569); // Lighter border for less emphasis
  
  // Special cards in dark mode
  static const Color cardShadowDark = Colors.black45;
  static const Color dividerDark = Color(0xFF1E293B); // Subtle dividers
  
  // Educational mood colors
  static const Color focusDark = Color(0xFF64B5F6); // Light blue for focus/attention
  static const Color inspireDark = Color(0xFF81C784); // Light green for inspiration
  static const Color creativeIdeasDark = Color(0xFFBA68C8); // Purple for creativity
  
  /// Get theme data for dark mode optimized for education
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryDark,
        onPrimary: onPrimaryDark,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        secondary: secondaryDark,
        onSecondary: Colors.black,
        error: errorDark,
        onError: Colors.black,
        tertiary: accentDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: onSurfaceDark,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderDark),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: onPrimaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  /// Get theme data for light mode
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.light(
        primary: primaryLight,
        onPrimary: onPrimaryLight,
        surface: surfaceLight,
        onSurface: onSurfaceLight,
        secondary: secondaryLight,
        onSecondary: Colors.white,
        error: errorLight,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: onSurfaceLight,
        elevation: 0,
      ),
    );
  }
}
