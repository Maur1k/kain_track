import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const background = Color(0xFFF3FAF6);
  static const teal = Color(0xFF006A60);
  static const mint = Color(0xFF98EFE0);
  static const mintHover = Color(0xFF82E6D5);
  static const pillGrey = Color(0xFFF5F2F8);
  static const protein = Color(0xFF10B981);
  static const carbs = Color(0xFF0EA5E9);
  static const fat = Color(0xFFF59E0B);
  static const over = Color(0xFFF43F5E);
}

ThemeData buildAppTheme() {
  const colorScheme = ColorScheme.light(
    primary: AppColors.teal,
    onPrimary: Colors.white,
    secondary: AppColors.mint,
    onSecondary: AppColors.teal,
    surface: Colors.white,
    onSurface: Color(0xFF17332F),
    error: AppColors.over,
    onError: Colors.white,
  );
  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: Color(0xFF17332F),
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        side: BorderSide(color: Color(0xFFE6F0EC)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.mint,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.mint,
      foregroundColor: AppColors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
