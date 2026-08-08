import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';

class StatsBarChart extends StatelessWidget {
  final Map<DateTime, double> dailyExpenses;
  final String selectedPeriod;
  const StatsBarChart(
      {super.key, required this.dailyExpenses, required this.selectedPeriod});

  @override
  Widget build(BuildContext context) {
    if (dailyExpenses.isEmpty) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(context.tr('no_data_period'),
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.textSecondary))));
    }

    final maxExpense = dailyExpenses.values.reduce((a, b) => a > b ? a : b);
    final entries = dailyExpenses.entries.toList();

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < entries.length; i++) {
      barGroups.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: entries[i].value,
          gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColors.primary, AppColors.primaryLight]),
          borderRadius: BorderRadius.circular(8),
          width: entries.length > 15 ? 10 : 18,
          backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxExpense * 1.2,
              color: AppColors.divider.withValues(alpha: 0.3)),
        ),
      ]));
    }

    final dayLabels = entries.map((e) => '${e.key.day}').toList();

    return SizedBox(
      height: 220,
      child: BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxExpense * 1.3,
        barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: AppColors.textPrimary,
          getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
              rod.toY.formattedAmount,
              GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        )),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox();
                    return Text(
                        value >= 1000
                            ? '${(value / 1000).toStringAsFixed(0)}K'
                            : value.toInt().toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: AppColors.textSecondary));
                  })),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= dayLabels.length) {
                      return const SizedBox();
                    }
                    return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(dayLabels[idx],
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: AppColors.textSecondary)));
                  })),
        ),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxExpense / 4,
            getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.divider.withValues(alpha: 0.5),
                strokeWidth: 1,
                dashArray: [4, 4])),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      )),
    );
  }
}
