import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// ─────────────────────────────────────────────────────────────
/// Interna Crystal Design System
/// Theme: Luminous Obsidian – Dark glassmorphism with gradient accents
/// ─────────────────────────────────────────────────────────────

class InternaCrystal {
  InternaCrystal._(); // Private constructor – utility class

  // ── Core Palette ──────────────────────────────────────────
  static const Color bgDeep       = Color(0xFF040E1F);   // Deepest background
  static const Color bgCard       = Color(0xFF102036);   // Card / surface
  static const Color bgSidebar    = Color(0xFF061326);   // Sidebar panel
  static const Color bgElevated   = Color(0xFF1B2C47);   // Elevated elements

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFFDBE6FE);   // Headings, body
  static const Color textSecondary= Color(0xFFA0ABC2);   // Muted / labels
  static const Color textMuted    = Color(0xFF6B7A94);   // Very muted

  // ── Accent ────────────────────────────────────────────────
  static const Color accentPurple = Color(0xFF8B5CF6);   // Primary brand
  static const Color accentBlue   = Color(0xFF0EA5E9);   // Secondary brand
  static const Color accentGreen  = Color(0xFF10B981);   // Success
  static const Color accentOrange = Color(0xFFF59E0B);   // Warning / pending
  static const Color accentRed    = Color(0xFFEF4444);   // Error / destructive

  // ── Gradient ──────────────────────────────────────────────
  static const LinearGradient brandGradient = LinearGradient(
    colors: [accentPurple, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Borders & Glows ───────────────────────────────────────
  static const Color borderSubtle      = Color(0x12FFFFFF);  // White 7% opacity
  static const Color borderLight       = Color(0x1FFFFFFF);  // White 12% opacity

  // ── Glassmorphism helpers ─────────────────────────────────
  static BoxDecoration glassCard({double opacity = 0.6, double radius = 20}) {
    return BoxDecoration(
      color: bgCard.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderSubtle),
    );
  }

  static BoxDecoration glassSurface({double radius = 16}) {
    return BoxDecoration(
      color: bgDeep.withOpacity(0.5),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderSubtle),
    );
  }

  // ── ThemeData ─────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDeep,
      colorScheme: const ColorScheme.dark(
        primary: accentPurple,
        secondary: accentBlue,
        surface: bgCard,
        error: accentRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
      ),
      iconTheme: const IconThemeData(color: accentPurple, size: 24),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge:  TextStyle(color: textPrimary),
          displayMedium: TextStyle(color: textPrimary),
          displaySmall:  TextStyle(color: textPrimary),
          headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          titleLarge:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
          titleSmall:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary),
          bodyLarge:   TextStyle(fontSize: 16, color: textPrimary),
          bodyMedium:  TextStyle(fontSize: 14, color: textPrimary),
          bodySmall:   TextStyle(fontSize: 12, color: textSecondary),
          labelLarge:  TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
          labelSmall:  TextStyle(fontSize: 11, color: textMuted),
        ),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderSubtle),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: borderSubtle,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgDeep.withOpacity(0.5),
        hintStyle: GoogleFonts.inter(color: textMuted),
        labelStyle: GoogleFonts.inter(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentPurple, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPurple,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: bgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 15,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: bgElevated,
        contentTextStyle: GoogleFonts.inter(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: accentPurple,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        indicatorColor: Colors.white,
        labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accentPurple;
          return textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accentPurple.withOpacity(0.3);
          return borderSubtle;
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: bgCard.withOpacity(0.5),
        selectedColor: accentPurple,
        labelStyle: GoogleFonts.inter(color: textSecondary, fontWeight: FontWeight.w600, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide.none,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: bgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(color: textPrimary, fontSize: 14),
      ),
      listTileTheme: ListTileThemeData(
        textColor: textPrimary,
        iconColor: textSecondary,
        selectedColor: accentPurple,
        selectedTileColor: accentPurple.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentPurple,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  static void showPremiumDatePicker(
    BuildContext context, {
    required DateTime initialDate,
    required ValueChanged<DateTime> onChanged,
    DateTime? minimumDate,
  }) {
    DateTime selectedDate = initialDate;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 350,
        decoration: BoxDecoration(
          color: bgDeep,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: borderSubtle, width: 0.5),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Chọn ngày',
              style: GoogleFonts.inter(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Theme(
                data: ThemeData.dark().copyWith(
                  cupertinoOverrideTheme: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: GoogleFonts.inter(
                        color: textPrimary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      final date = (minimumDate ?? DateTime.now()).add(Duration(days: index));
                      selectedDate = date;
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final date = (minimumDate ?? DateTime.now()).add(Duration(days: index));
                        return Center(
                          child: Text(
                            DateFormat('EEEE, dd MMMM', 'vi').format(date),
                            style: GoogleFonts.inter(
                              color: textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                      childCount: 365,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () {
                  onChanged(selectedDate);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('XÁC NHẬN', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
