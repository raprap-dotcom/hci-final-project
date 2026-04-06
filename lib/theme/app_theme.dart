import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  bool get isDark => value == ThemeMode.dark;

  void toggle() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}

final ThemeController themeController = ThemeController();

@immutable
class AppSizes extends ThemeExtension<AppSizes> {
  const AppSizes({required this.appBarHeight, required this.bottomNavHeight});

  final double appBarHeight;
  final double bottomNavHeight;

  @override
  AppSizes copyWith({double? appBarHeight, double? bottomNavHeight}) {
    return AppSizes(
      appBarHeight: appBarHeight ?? this.appBarHeight,
      bottomNavHeight: bottomNavHeight ?? this.bottomNavHeight,
    );
  }

  @override
  AppSizes lerp(ThemeExtension<AppSizes>? other, double t) {
    if (other is! AppSizes) return this;
    return AppSizes(
      appBarHeight: _lerpDouble(appBarHeight, other.appBarHeight, t),
      bottomNavHeight: _lerpDouble(bottomNavHeight, other.bottomNavHeight, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

ThemeData buildAppTheme() {
  const primary = Color(0xFF395886);
  const surface = Color(0xFFF2F6FC);
  const appSizes = AppSizes(appBarHeight: 66, bottomNavHeight: 72);

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: surface,
      brightness: Brightness.light,
    ),
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme().copyWith(
      // Titles and headings use Poppins
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      // Body text uses Inter (default)
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      bodySmall: GoogleFonts.inter(fontSize: 12),
      labelLarge: GoogleFonts.inter(fontSize: 14),
      labelMedium: GoogleFonts.inter(fontSize: 12),
      labelSmall: GoogleFonts.inter(fontSize: 10),
    ),
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      toolbarHeight: appSizes.appBarHeight,
      backgroundColor: primary,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
    extensions: const [appSizes],
  );
}

ThemeData buildDarkTheme() {
  const primary = Color(0xFF1F2E46);
  const surface = Color(0xFF131A24);
  const appSizes = AppSizes(appBarHeight: 66, bottomNavHeight: 72);
  const darkButtonForeground = Colors.white;
  final darkScheme = ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    surface: surface,
    brightness: Brightness.dark,
  ).copyWith(onPrimary: Colors.white);

  return ThemeData(
    colorScheme: darkScheme,
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme(),
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      toolbarHeight: appSizes.appBarHeight,
      backgroundColor: primary,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: darkButtonForeground,
        iconColor: darkButtonForeground,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkButtonForeground,
        iconColor: darkButtonForeground,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkButtonForeground,
        iconColor: darkButtonForeground,
        side: const BorderSide(color: darkButtonForeground),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: darkButtonForeground,
      ),
    ),
    extensions: const [appSizes],
  );
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Transform.rotate(
            angle: -0.35,
            child: IconButton(
              tooltip: isDark ? 'Light mode' : 'Dark mode',
              onPressed: themeController.toggle,
              icon: Icon(
                Icons.nightlight_round,
                color: isDark ? const Color(0xFFFFD54F) : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
