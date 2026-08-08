import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePieChart extends StatefulWidget {
  const HomePieChart({super.key});
  @override
  State<HomePieChart> createState() => _HomePieChartState();
}

class _HomePieChartState extends State<HomePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.categoryExpenses.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(context.tr('no_expenses_period'),
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.textSecondary)),
            ),
          );
        }

        final totalExpense =
            state.categoryExpenses.values.fold(0.0, (a, b) => a + b);
        final entries = state.categoryExpenses.entries.toList();

        return Column(
          children: [
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            response.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 45,
                  sections: List.generate(entries.length, (i) {
                    final isTouched = i == touchedIndex;
                    final pct = (entries[i].value / totalExpense * 100);
                    final colorIndex = AppConstants.categories
                        .indexWhere((c) => c['name'] == entries[i].key);
                    final color = colorIndex >= 0
                        ? AppConstants.chartColors[colorIndex]
                        : AppColors.disabled;

                    return PieChartSectionData(
                      color: color,
                      value: entries[i].value,
                      radius: isTouched ? 55.0 : 50.0,
                      title: isTouched ? '${pct.toStringAsFixed(0)}%' : '',
                      titleStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      titlePositionPercentageOffset: 0.5,
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: entries.map((entry) {
                final catIndex = AppConstants.categories
                    .indexWhere((c) => c['name'] == entry.key);
                final cat = catIndex >= 0
                    ? AppConstants.categories[catIndex]
                    : {'ar': entry.key, 'emoji': '💸'};
                final pct =
                    (entry.value / totalExpense * 100).toStringAsFixed(0);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '${cat['emoji']} ${entry.key.localizedCategoryName(context)}',
                        style: GoogleFonts.poppins(fontSize: 11)),
                    const SizedBox(width: 4),
                    Text('$pct%',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                  ],
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
