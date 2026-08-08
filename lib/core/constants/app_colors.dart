import 'package:flutter/material.dart';

class AppColors {
  // === PRIMARY (Rich Emerald system) ===
  static const Color primary = Color(0xFF10B981); // Vibrant emerald
  static const Color primaryGlow = Color(0xFF34D399); // Glow green
  static const Color primaryLight = Color(0xFFA7F3D0); // Light mint
  static const Color primaryDark = Color(0xFF059669); // Deep emerald
  static const Color primarySoft = Color(0xFFECFDF5); // Soft mint bg
  static const Color primaryGradientColor = Color(0xFF0D9488); // Teal-green

  // === ACCENT ===
  static const Color accent = Color(0xFF34D399);
  static const Color accentLight = Color(0xFFD1FAE5);
  static const Color accentViolet = Color(0xFF7C5CF7); // New violet accent

  // === FINANCIAL ===
  static const Color income = Color(0xFF10B981); // Income green
  static const Color expense = Color(0xFFF43F5E); // Expense rose red
  static const Color expenseSoft = Color(0xFFFFF1F2); // Light rose bg
  static const Color incomeLight = Color(0xFFECFDF5); // Light green bg
  static const Color expenseLight = Color(0xFFFFF1F2); // Light rose bg

  // === BACKGROUNDS ===
  static const Color lightBackground = Color(0xFFF7F9FC); // App bg (light)
  static const Color darkBackground = Color(0xFF0B1320); // App bg (dark)
  static const Color cardLight = Color(0xFFFFFFFF); // Card (light)
  static const Color cardDark = Color(0xFF172033); // Card (dark)
  static const Color surfaceDark = Color(0xFF172033); // Surface (dark)
  static const Color bgLight = Color(0xFFEDF1F6); // subtle bg
  static const Color bgDark = Color(0xFF0B1320); // app bg dark
  static const Color statisticsBackground =
      Color(0xFFF0FDF4); // Stats page (very light green)

  // === NEW ALIASES (match the final spec names) ===
  static const Color background = Color(0xFFF7F9FC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE4EAF0);
  static const Color textDark = Color(0xFF0B1220);
  static const Color textLight = Color(0xFF8E99A8);
  static const Color expenseBg = Color(0xFFFFF1F2);
  static const Color incomeBg = Color(0xFFECFDF5);
  static const Color darkCard = Color(0xFF172033);

  // === TEXT ===
  static const Color textPrimary = Color(0xFF0B1220);
  static const Color textSecondary = Color(0xFF5B6B7C);
  static const Color textMuted = Color(0xFF8E99A8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDarkPrimary = Color(0xFFF3F6FA);
  static const Color textDarkSecondary = Color(0xFF9AA7B8);

  // === UI ELEMENTS ===
  static const Color divider = Color(0xFFE4EAF0);
  static const Color disabled = Color(0xFFCBD5E1);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);

  // === GRADIENTS (Premium/Deep) ===
  static const LinearGradient balanceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF064E3B), Color(0xFF059669), Color(0xFF34D399)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF022C22), Color(0xFF065F46), Color(0xFF0D9488)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF10B981), Color(0xFF34D399)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF059669), Color(0xFF10B981)],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6D28D9), Color(0xFF7C5CF7), Color(0xFF34D399)],
  );

  // === CATEGORY COLORS (Richer) ===
  static const List<Color> categoryColors = [
    Color(0xFF065F46),
    Color(0xFF2563EB),
    Color(0xFFE11D48),
    Color(0xFFF59E0B),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFF0891B2),
    Color(0xFF64748B),
    Color(0xFF0D9488),
    Color(0xFFEA580C),
  ];

  // === DARK MODE EXTRAS ===
  static const Color darkCardBorder = Color(0xFF2A3A52);
  static const Color darkDivider = Color(0xFF2A3A52);
  static const Color darkIconColor = Color(0xFFCBD5E1);
}
