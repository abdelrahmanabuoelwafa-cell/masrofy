import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';

class StatsPieChart extends StatefulWidget {
  final Map<String, double> categoryExpenses;
  final double totalExpense;
  const StatsPieChart(
      {super.key, required this.categoryExpenses, required this.totalExpense});

  @override
  State<StatsPieChart> createState() => _StatsPieChartState();
}

class _StatsPieChartState extends State<StatsPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryExpenses.isEmpty || widget.totalExpense == 0) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(context.tr('no_expenses_period'),
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.textSecondary))));
    }
    final entries = widget.categoryExpenses.entries.toList();
    return Column(children: [
      SizedBox(
          height: 200,
          child: PieChart(PieChartData(
            pieTouchData: PieTouchData(touchCallback: (event, response) {
              setState(() {
                touchedIndex = (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null)
                    ? -1
                    : response.touchedSection!.touchedSectionIndex;
              });
            }),
            borderData: FlBorderData(show: false),
            sectionsSpace: 4,
            centerSpaceRadius: 50,
            sections: List.generate(entries.length, (i) {
              final isTouched = i == touchedIndex;
              final pct = entries[i].value / widget.totalExpense * 100;
              final ci = AppConstants.categories
                  .indexWhere((c) => c['name'] == entries[i].key);
              return PieChartSectionData(
                color:
                    ci >= 0 ? AppConstants.chartColors[ci] : AppColors.disabled,
                value: entries[i].value,
                radius: isTouched ? 60.0 : 52.0,
                title: isTouched ? '${pct.toStringAsFixed(1)}%' : '',
                titleStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                titlePositionPercentageOffset: 0.5,
              );
            }),
          ))),
      const SizedBox(height: 20),
      ...entries.map((entry) {
        final ci =
            AppConstants.categories.indexWhere((c) => c['name'] == entry.key);
        final cat = ci >= 0
            ? AppConstants.categories[ci]
            : {'ar': entry.key, 'emoji': '💸'};
        final pct =
            (entry.value / widget.totalExpense * 100).toStringAsFixed(1);
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: ci >= 0
                          ? AppConstants.chartColors[ci]
                          : AppColors.disabled,
                      borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 12),
              Text(
                  '${cat['emoji']} ${entry.key.localizedCategoryName(context)}',
                  style: GoogleFonts.poppins(fontSize: 13)),
              const Spacer(),
              Text(entry.value.formattedAmount,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(width: 12),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text('$pct%',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary))),
            ]));
      }),
    ]);
  }
}
