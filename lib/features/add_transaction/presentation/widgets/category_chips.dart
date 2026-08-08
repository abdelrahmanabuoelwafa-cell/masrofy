import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final bool isExpense;
  final ValueChanged<String> onSelected;

  const CategoryChips(
      {super.key,
      required this.selectedCategory,
      required this.isExpense,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final categories = isExpense
        ? AppConstants.categories
        : [
            {
              'name': 'salary',
              'ar': 'مرتب',
              'emoji': '💰',
              'color': AppColors.income
            },
            {
              'name': 'freelance',
              'ar': 'فريلانس',
              'emoji': '💻',
              'color': AppColors.primary
            },
            {
              'name': 'gift',
              'ar': 'هدية',
              'emoji': '🎁',
              'color': AppColors.warning
            },
            {
              'name': 'other',
              'ar': 'أخرى',
              'emoji': '💸',
              'color': AppColors.textSecondary
            },
          ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        final name = cat['name'] as String;
        final isSelected = selectedCategory == name;
        final color = cat['color'] as Color;
        return GestureDetector(
          onTap: () => onSelected(name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : (context.isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : AppColors.bgLight),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isSelected
                      ? color
                      : (context.isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.divider),
                  width: isSelected ? 2 : 1),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(cat['emoji'] as String,
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(name.localizedCategoryName(context),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? color
                        : (context.isDark
                            ? Colors.white70
                            : AppColors.textPrimary),
                  )),
            ]),
          ),
        );
      }).toList(),
    );
  }
}
