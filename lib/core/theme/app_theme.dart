import 'package:flutter/material.dart';

/// Application theme configuration - Light and Dark Automotive Performance UI
class AppTheme {
  AppTheme._();

  // ========== Dark theme color tokens ==========
  static const Color bgPrimaryDark = Color(0xFF0B0D10);
  static const Color bgSecondaryDark = Color(0xFF141821);
  static const Color bgElevatedDark = Color(0xFF1C2130);
  static const Color borderDark = Color(0xFF242A3A);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB4B8C5);
  static const Color textMutedDark = Color(0xFF7C8296);
  static const Color textDisabledDark = Color(0xFF4A4F63);

  // ========== Light theme color tokens ==========
  static const Color bgPrimaryLight = Color(0xFFF5F6F8);
  static const Color bgSecondaryLight = Color(0xFFFFFFFF);
  static const Color bgElevatedLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E5EA);
  static const Color textPrimaryLight = Color(0xFF0B0D10);
  static const Color textSecondaryLight = Color(0xFF4A4F63);
  static const Color textMutedLight = Color(0xFF7C8296);
  static const Color textDisabledLight = Color(0xFFB4B8C5);

  // Shared (accent) - same in both themes
  static const Color redPrimary = Color(0xFFE10600);
  static const Color redPressed = Color(0xFFB30500);
  static const Color redSoft = Color(0xFFFF4D4D);
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA502);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF1E90FF);

  // Legacy compatibility (dark; for widgets not yet theme-aware)
  static const Color bgPrimary = bgPrimaryDark;
  static const Color bgSecondary = bgSecondaryDark;
  static const Color bgElevated = bgElevatedDark;
  static const Color border = borderDark;
  static const Color textPrimary = textPrimaryDark;
  static const Color textSecondary = textSecondaryDark;
  static const Color textMuted = textMutedDark;
  static const Color textDisabled = textDisabledDark;
  static const Color primaryColor = redPrimary;
  static const Color secondaryColor = redPressed;
  static const Color errorColor = error;
  static const Color warningColor = warning;
  static const Color successColor = success;
  static const Color backgroundColor = bgPrimaryDark;
  static const Color surfaceColor = bgSecondaryDark;

  static const String fontFamily = 'Inter';
  static const String fontFallback =
      'system-ui, -apple-system, BlinkMacSystemFont, sans-serif';

  static ThemeData get lightTheme => _buildLightTheme();
  static ThemeData get darkTheme => _buildDarkTheme();

  static ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: redPrimary,
        onPrimary: Colors.white,
        secondary: bgSecondaryLight,
        onSecondary: textPrimaryLight,
        error: error,
        onError: Colors.white,
        surface: bgSecondaryLight,
        onSurface: textPrimaryLight,
      ),
      scaffoldBackgroundColor: bgPrimaryLight,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: bgPrimaryLight,
        foregroundColor: textPrimaryLight,
        iconTheme: const IconThemeData(color: textPrimaryLight),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: bgSecondaryLight,
        shadowColor: Colors.black12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: redPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondaryLight,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSecondaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: redPrimary, width: 2),
        ),
        hintStyle: const TextStyle(color: textMutedLight, fontFamily: fontFamily),
        labelStyle: const TextStyle(
          color: textSecondaryLight,
          fontFamily: fontFamily,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
          fontFamily: fontFamily,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimaryLight,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        titleLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimaryLight,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryLight,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMutedLight,
          fontFamily: fontFamily,
          height: 1.4,
        ),
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: redPrimary,
        onPrimary: textPrimaryDark,
        secondary: bgSecondaryDark,
        onSecondary: textPrimaryDark,
        error: error,
        onError: textPrimaryDark,
        surface: bgSecondaryDark,
        onSurface: textPrimaryDark,
      ),
      scaffoldBackgroundColor: bgPrimaryDark,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: bgPrimaryDark,
        foregroundColor: textPrimaryDark,
        iconTheme: const IconThemeData(color: textPrimaryDark),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: bgSecondaryDark,
        shadowColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: redPrimary,
          foregroundColor: textPrimaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondaryDark,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSecondaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: redPrimary, width: 2),
        ),
        hintStyle: const TextStyle(color: textMutedDark, fontFamily: fontFamily),
        labelStyle: const TextStyle(
          color: textSecondaryDark,
          fontFamily: fontFamily,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderDark,
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimaryDark,
          fontFamily: fontFamily,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimaryDark,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        titleLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimaryDark,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryDark,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondaryDark,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMutedDark,
          fontFamily: fontFamily,
          height: 1.4,
        ),
      ),
    );
  }
}
