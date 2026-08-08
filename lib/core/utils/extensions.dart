import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../../features/locale/presentation/cubit/locale_cubit.dart';
import '../../data/models/transaction_model.dart';

extension StringExtension on String {
  String get capitalized =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  String get arabicCategoryName {
    final cat = AppConstants.categories.firstWhere(
      (c) => c['name'] == this,
      orElse: () => {'ar': this},
    );
    return cat['ar'] as String;
  }

  String localizedCategoryName(BuildContext context) {
    // Support income categories (salary/freelance/gift) from translations map
    final incomeCategories = {'salary', 'freelance', 'gift'};
    final matches = AppConstants.categories.where((c) => c['name'] == this);
    final isAr = context.read<LocaleCubit>().state.isArabic;
    if (matches.isEmpty) {
      // Fallback to translation map for income categories
      if (incomeCategories.contains(this)) {
        return context.tr(this);
      }
      return this;
    }
    final cat = matches.first;
    if (!isAr) {
      return AppStrings.en[cat['name']] ?? cat['name'] as String;
    }
    return cat['ar'] as String;
  }

  String get categoryEmoji {
    final cat = AppConstants.categories.firstWhere(
      (c) => c['name'] == this,
      orElse: () => {'emoji': '💸'},
    );
    return cat['emoji'] as String;
  }

  Color get categoryColor {
    final cat = AppConstants.categories.firstWhere(
      (c) => c['name'] == this,
      orElse: () => {'color': const Color(0xFF8E8E93)},
    );
    return cat['color'] as Color;
  }
}

extension DoubleExtension on double {
  String get formattedAmount {
    final settingsBox = Hive.box('app_settings');
    final currencyCode =
        settingsBox.get('currency', defaultValue: 'EGP') as String;

    final currencySymbols = {
      'EGP': 'EGP',
      'SAR': 'SAR',
      'AED': 'AED',
      'USD': '\$',
      'EUR': '€',
    };

    final symbol = currencySymbols[currencyCode] ?? 'EGP';
    final absValue = abs();
    final formatter = NumberFormat('#,##0.##');
    final formatted = formatter.format(
        absValue == absValue.roundToDouble() ? absValue.toInt() : absValue);

    return '\u200E${this < 0 ? '-' : ''}$formatted $symbol';
  }
}

extension TransactionTitleExtension on TransactionModel {
  String localizedTitle(BuildContext context) {
    final incomeCategories = {'salary', 'freelance', 'gift'};
    final matches = AppConstants.categories.where((c) => c['name'] == category);
    String arName;
    if (matches.isNotEmpty) {
      arName = matches.first['ar'] as String;
    } else if (incomeCategories.contains(category)) {
      arName = AppStrings.ar[category] ?? category;
    } else {
      return title;
    }
    if (title.isEmpty || title == arName || title == category) {
      return category.localizedCategoryName(context);
    }
    return title;
  }
}

extension DateTimeExtension on DateTime {
  String formattedDate(BuildContext context) {
    final locale = context.read<LocaleCubit>().state.locale;
    return DateFormat('d/M/yyyy', locale.languageCode).format(this);
  }

  String dayName(BuildContext context) {
    const days = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ];
    return context.tr(days[weekday % 7]);
  }

  String monthName(BuildContext context) {
    const months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december'
    ];
    return context.tr(months[month - 1]);
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String relativeDate(BuildContext context) {
    if (isToday) return context.tr('today');
    if (isYesterday) return context.tr('yesterday');
    return formattedDate(context);
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
}

extension BuildContextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Size get screenSize => MediaQuery.of(this).size;

String tr(String key) {
    final localeState = read<LocaleCubit>().state;
    final strings = localeState.isArabic ? AppStrings.ar : AppStrings.en;
    return strings[key] ?? key;
  }
}
