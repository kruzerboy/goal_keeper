import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFEFF6FF);
  static const primaryDark = Color(0xFF1D4ED8);
  static const accent = Color(0xFF10B981);
  static const accentLight = Color(0xFFECFDF5);
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F5F9);
  static const border = Color(0xFFE2E8F0);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textHint = Color(0xFFCBD5E1);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const success = Color(0xFF10B981);
  static const gradientStart = Color(0xFF1E1B4B);
  static const gradientMid = Color(0xFF312E81);
  static const gradientEnd = Color(0xFF3730A3);
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 16);
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 100;
}

abstract final class AppTypography {
  static const _base = TextStyle(
    fontFamily: 'SF Pro Display',
    color: AppColors.textPrimary,
  );
  static final displayLarge =
      _base.copyWith(fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -1);
  static final displayMedium =
      _base.copyWith(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5);
  static final headlineLarge =
      _base.copyWith(fontSize: 22, fontWeight: FontWeight.bold);
  static final headlineMedium =
      _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600);
  static final titleLarge =
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final titleMedium =
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final bodyLarge =
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.normal);
  static final bodyMedium =
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.normal);
  static final bodySmall =
      _base.copyWith(fontSize: 12, color: AppColors.textSecondary);
  static final labelSmall = _base.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
      color: AppColors.textSecondary);
}

final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full)),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: const BorderSide(color: AppColors.border),
          ),
          margin: EdgeInsets.zero,
        ),
      );
}