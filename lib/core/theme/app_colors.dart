import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette explicitly specified for Xenobiz
  static const Color deepNavy = Color(0xFF050C1F);
  static const Color darkNavy = Color(0xFF02213F);
  static const Color brightCyan = Color(0xFF00BAFF);
  static const Color lightGray = Color(0xFFF4F4F4);
  static const Color nearBlack = Color(0xFF151515);

  // Semantic mappings
  static const Color primary = brightCyan;
  static const Color primaryDark = darkNavy;
  static const Color backgroundDark = deepNavy;
  static const Color backgroundLight = lightGray;
  static const Color textPrimary = nearBlack;
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFFFFFFFF);
  
  static const Color cardSurface = Colors.white;
  static const Color border = Color(0xFFE0E0E0);
  
  // Status Colors (derived/subtle)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = brightCyan;
}
