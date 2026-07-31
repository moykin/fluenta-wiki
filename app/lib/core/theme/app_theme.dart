import 'package:flutter/material.dart';

import 'tokens.dart';

/// Тема приложения, собранная из дизайн-токенов.
///
/// Дизайн — светлый минимализм с типографикой во главе: белые карточки,
/// волосяные бордеры, никаких градиентов и стеклянных эффектов.
abstract final class AppTheme {
  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: FluentaColors.indigo,
      onPrimary: Colors.white,
      primaryContainer: FluentaColors.indigo50,
      onPrimaryContainer: FluentaColors.indigoHover,
      secondary: FluentaColors.amberStrong,
      onSecondary: FluentaColors.text,
      surface: FluentaColors.surface,
      onSurface: FluentaColors.text,
      error: FluentaColors.error,
      onError: Colors.white,
      outline: FluentaColors.border,
    );

    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: FluentaFonts.sans,
      scaffoldBackgroundColor: FluentaColors.background,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),

      appBarTheme: const AppBarTheme(
        backgroundColor: FluentaColors.background,
        foregroundColor: FluentaColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: FluentaColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentaRadius.card),
          side: const BorderSide(color: FluentaColors.border),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: FluentaColors.border,
        thickness: 1,
        space: 1,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              backgroundColor: FluentaColors.indigo,
              foregroundColor: Colors.white,
              // Тач-цель не меньше 44px даже там, где кнопка визуально ниже.
              minimumSize: const Size(0, kMinTouchTarget),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FluentaRadius.control),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return FluentaColors.indigoHover;
                }
                return null;
              }),
            ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FluentaColors.text,
          minimumSize: const Size(0, kMinTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          side: const BorderSide(color: FluentaColors.border),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FluentaRadius.control),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FluentaColors.indigo,
          minimumSize: const Size(0, kMinTouchTarget),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FluentaColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FluentaRadius.control),
          borderSide: const BorderSide(color: FluentaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FluentaRadius.control),
          borderSide: const BorderSide(color: FluentaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FluentaRadius.control),
          borderSide: const BorderSide(color: FluentaColors.indigo, width: 2),
        ),
        hintStyle: const TextStyle(
          color: FluentaColors.textMuted,
          fontSize: 14,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: FluentaColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        indicatorColor: FluentaColors.indigo50,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? FluentaColors.indigo
                : FluentaColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 21,
            color: selected
                ? FluentaColors.indigo
                : FluentaColors.textSecondary,
          );
        }),
      ),

      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: FluentaColors.surface,
        indicatorColor: FluentaColors.indigo50,
        selectedIconTheme: IconThemeData(color: FluentaColors.indigo, size: 22),
        unselectedIconTheme: IconThemeData(
          color: FluentaColors.textSecondary,
          size: 22,
        ),
        selectedLabelTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: FluentaColors.indigo,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 12,
          color: FluentaColors.textSecondary,
        ),
      ),

      chipTheme: const ChipThemeData(
        backgroundColor: FluentaColors.indigo50,
        side: BorderSide(color: FluentaColors.indigo100),
        labelStyle: TextStyle(
          fontSize: 12.5,
          height: 1.45,
          color: FluentaColors.indigoHover,
          fontWeight: FontWeight.w500,
        ),
        shape: StadiumBorder(),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: FluentaColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    // Заголовки и всё, что относится к языку, — серифом. Интерфейсные
    // подписи — Inter. Так задумано в макетах: текст читается как текст,
    // а не как элемент управления.
    return base.copyWith(
      displayLarge: _serif(52, FontWeight.w600, height: 1.1),
      displayMedium: _serif(40, FontWeight.w600, height: 1.15),
      headlineLarge: _serif(32, FontWeight.w600, height: 1.2),
      headlineMedium: _serif(27, FontWeight.w600, height: 1.25),
      headlineSmall: _serif(22, FontWeight.w600, height: 1.3),
      titleLarge: _serif(19, FontWeight.w600, height: 1.35),
      titleMedium: _sans(15, FontWeight.w600),
      titleSmall: _sans(13.5, FontWeight.w600),
      bodyLarge: _sans(15, FontWeight.w400, height: 1.55),
      bodyMedium: _sans(14, FontWeight.w400, height: 1.55),
      bodySmall: _sans(
        12.5,
        FontWeight.w400,
        height: 1.45,
        color: FluentaColors.textSecondary,
      ),
      labelLarge: _sans(14, FontWeight.w600),
      labelMedium: _sans(12.5, FontWeight.w500),
      labelSmall: _sans(11, FontWeight.w500, color: FluentaColors.textMuted),
    );
  }

  static TextStyle _serif(
    double size,
    FontWeight weight, {
    double? height,
    Color color = FluentaColors.text,
  }) => TextStyle(
    fontFamily: FluentaFonts.serif,
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color,
  );

  static TextStyle _sans(
    double size,
    FontWeight weight, {
    double? height,
    Color color = FluentaColors.text,
  }) => TextStyle(
    fontFamily: FluentaFonts.sans,
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color,
  );

  /// Стиль текста в читалке — используется только там.
  static const TextStyle readerBody = TextStyle(
    fontFamily: FluentaFonts.serif,
    fontSize: FluentaReaderType.fontSize,
    height: FluentaReaderType.height,
    color: FluentaColors.text,
  );
}
