import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Light colors
  static const Color primary = Color(0xFF031636);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1A2B4C);
  static const Color onPrimaryContainer = Color(0xFF8293BA);
  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color primaryFixedDim = Color(0xFFB6C6F0);

  static const Color secondary = Color(0xFF006B5F);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF62FAE3);
  static const Color onSecondaryContainer = Color(0xFF007165);
  static const Color secondaryFixed = Color(0xFF62FAE3);
  static const Color secondaryFixedDim = Color(0xFF3CDDC7);

  static const Color background = Color(0xFFF7F9FB);
  static const Color onBackground = Color(0xFF191C1E);
  static const Color surface = Color(0xFFF7F9FB);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color surfaceVariant = Color(0xFFE0E3E5);
  static const Color onSurfaceVariant = Color(0xFF44474E);
  static const Color surfaceDim = Color(0xFFD8DADC);
  static const Color surfaceBright = Color(0xFFF7F9FB);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color tertiary = Color(0xFF07182B);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF1D2D41);
  static const Color onTertiaryContainer = Color(0xFF8494AC);

  // Dark colors
  static const Color darkPrimary = Color(0xFFD8E2FF);
  static const Color darkOnPrimary = Color(0xFF031636);
  static const Color darkPrimaryContainer = Color(0xFF1A2B4C);
  static const Color darkOnPrimaryContainer = Color(0xFFB6C6F0);

  static const Color darkSecondary = Color(0xFF62FAE3);
  static const Color darkOnSecondary = Color(0xFF003731);
  static const Color darkSecondaryContainer = Color(0xFF3CDDC7);
  static const Color darkOnSecondaryContainer = Color(0xFF007165);

  static const Color darkBackground = Color(0xFF030712);
  static const Color darkOnBackground = Color(0xFFF3F4F6);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkOnSurface = Color(0xFFF3F4F6);
  static const Color darkSurfaceVariant = Color(0xFF1F2937);
  static const Color darkOnSurfaceVariant = Color(0xFF9CA3AF);
  static const Color darkSurfaceDim = Color(0xFF111827);
  static const Color darkSurfaceBright = Color(0xFF1F2937);
  static const Color darkSurfaceContainerLow = Color(0xFF1F2937);
  static const Color darkSurfaceContainer = Color(0xFF1F2937);
  static const Color darkSurfaceContainerHigh = Color(0xFF374151);
  static const Color darkSurfaceContainerHighest = Color(0xFF374151);
  static const Color darkSurfaceContainerLowest = Color(0xFF030712);

  static const Color darkOutline = Color(0xFF6B7280);
  static const Color darkOutlineVariant = Color(0xFF374151);

  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  static const Color darkTertiary = Color(0xFF8494AC);
  static const Color darkOnTertiary = Color(0xFF07182B);
  static const Color darkTertiaryContainer = Color(0xFF1D2D41);
  static const Color darkOnTertiaryContainer = Color(0xFF8494AC);

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double gutter = 12;
  static const double containerMargin = 20;

  static Color surfaceContainerOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceContainer
        : surfaceContainer;

  static Color surfaceContainerLowOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceContainerLow
        : surfaceContainerLow;

  static Color surfaceContainerHighOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceContainerHigh
        : surfaceContainerHigh;

  static Color surfaceContainerHighestOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceContainerHighest
        : surfaceContainerHighest;

  static Color surfaceContainerLowestOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceContainerLowest
        : surfaceContainerLowest;

  static Color surfaceDimOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceDim
        : surfaceDim;

  static Color surfaceBrightOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceBright
        : surfaceBright;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: secondary,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondary,
          side: BorderSide(color: secondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: darkPrimary,
        onPrimary: darkOnPrimary,
        primaryContainer: darkPrimaryContainer,
        onPrimaryContainer: darkOnPrimaryContainer,
        secondary: darkSecondary,
        onSecondary: darkOnSecondary,
        secondaryContainer: darkSecondaryContainer,
        onSecondaryContainer: darkOnSecondaryContainer,
        tertiary: darkTertiary,
        onTertiary: darkOnTertiary,
        tertiaryContainer: darkTertiaryContainer,
        onTertiaryContainer: darkOnTertiaryContainer,
        error: darkError,
        onError: darkOnError,
        errorContainer: darkErrorContainer,
        onErrorContainer: darkOnErrorContainer,
        background: darkBackground,
        onBackground: darkOnBackground,
        surface: darkSurface,
        onSurface: darkOnSurface,
        surfaceVariant: darkSurfaceVariant,
        onSurfaceVariant: darkOnSurfaceVariant,
        outline: darkOutline,
        outlineVariant: darkOutlineVariant,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkSecondary,
        unselectedItemColor: darkOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkSecondary,
          side: BorderSide(color: darkSecondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AppTextStyle {
  static const TextStyle headlineLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 40 / 32,
  );

  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: 'Inter',
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 32 / 26,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  static const TextStyle dataDisplay = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
  );

  static const TextStyle labelCaps = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.05,
    height: 16 / 12,
  );
}
