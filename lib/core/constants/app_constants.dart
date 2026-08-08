import 'package:flutter/material.dart';

class AppConstants {
  static const List<Map<String, dynamic>> categories = [
    {'name': 'food', 'ar': 'أكل', 'emoji': '🍔', 'color': Color(0xFFFF6B6B)},
    {
      'name': 'transport',
      'ar': 'مواصلات',
      'emoji': '🚌',
      'color': Color(0xFF54A0FF)
    },
    {'name': 'study', 'ar': 'دراسة', 'emoji': '📚', 'color': Color(0xFF6C5CE7)},
    {
      'name': 'entertainment',
      'ar': 'ترفيه',
      'emoji': '🎮',
      'color': Color(0xFFFF9FF3)
    },
    {
      'name': 'shopping',
      'ar': 'شوبينج',
      'emoji': '🛒',
      'color': Color(0xFFFeca57)
    },
    {'name': 'health', 'ar': 'صحة', 'emoji': '🏥', 'color': Color(0xFF1DD1A1)},
    {
      'name': 'bills',
      'ar': 'فواتير',
      'emoji': '🧾',
      'color': Color(0xFF48DBFB)
    },
    {'name': 'other', 'ar': 'أخرى', 'emoji': '💸', 'color': Color(0xFF8E8E93)},
  ];

  static const List<Color> chartColors = [
    Color(0xFFFF6B6B),
    Color(0xFF54A0FF),
    Color(0xFF6C5CE7),
    Color(0xFFFF9FF3),
    Color(0xFFFECA57),
    Color(0xFF1DD1A1),
    Color(0xFF48DBFB),
    Color(0xFF8E8E93),
  ];

  static const List<String> dateFilters = [
    'This Week',
    'This Month',
    'This Year'
  ];
  static const List<String> dateFiltersAr = [
    'هذا الأسبوع',
    'هذا الشهر',
    'هذا العام'
  ];
  static const String expenseType = 'expense';
  static const String incomeType = 'income';
  static const double warningThreshold = 0.80;
  static const double dangerThreshold = 1.00;
}
