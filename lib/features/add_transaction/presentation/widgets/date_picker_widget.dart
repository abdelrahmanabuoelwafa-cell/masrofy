import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DatePickerWidget(
      {super.key, required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('date'),
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: [
            _dateChip(context.tr('today'), selectedDate.isToday,
                () => onDateChanged(now), context),
            const SizedBox(width: 10),
            _dateChip(
                context.tr('yesterday'),
                selectedDate.isYesterday,
                () => onDateChanged(now.subtract(const Duration(days: 1))),
                context),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2024),
                    lastDate: now,
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.light(
                              primary: AppColors.primary)),
                      child: child!,
                    ),
                  );
                  if (picked != null) onDateChanged(picked);
                },
                child: _dateChipContainer(
                    selectedDate.formattedDate(context),
                    !selectedDate.isToday && !selectedDate.isYesterday,
                    context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateChip(
      String label, bool isSelected, VoidCallback onTap, BuildContext context) {
    return Expanded(
        child: GestureDetector(
            onTap: onTap,
            child: _dateChipContainer(label, isSelected, context)));
  }

  Widget _dateChipContainer(
      String label, bool isSelected, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : (context.isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.bgLight),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (context.isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.divider),
            width: isSelected ? 1.5 : 1),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppColors.primary
                : (context.isDark ? Colors.white70 : AppColors.textPrimary),
          ),
          overflow: TextOverflow.ellipsis),
    );
  }
}
