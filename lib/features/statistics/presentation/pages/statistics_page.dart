import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../cubit/statistics_cubit.dart';
import '../cubit/statistics_state.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/pie_chart_widget.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final daily = state.dailyExpenses;
        final dailyCount = daily.length;
        final dailyAvg =
            dailyCount > 0 ? state.totalExpense / dailyCount : 0.0;
        MapEntry<DateTime, double>? topDay;
        daily.forEach((k, v) {
          if (topDay == null || v > topDay!.value) topDay = MapEntry(k, v);
        });
        return Scaffold(
          backgroundColor: context.isDark
              ? AppColors.darkBackground
              : AppColors.statisticsBackground,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(context.tr('statistics'),
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(context.tr('stats_subtitle'),
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 24),

// Period Selector
                Builder(builder: (context) {
                  final periodTexts = {
                    'This Week': context.tr('this_week'),
                    'This Month': context.tr('this_month'),
                    'This Year': context.tr('this_year'),
                  };
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? AppColors.surfaceDark
                          : AppColors.bgLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: List.generate(
                          AppConstants.dateFilters.length,
                          (i) => Expanded(
                                child: GestureDetector(
                                  onTap: () => context
                                      .read<StatisticsCubit>()
                                      .changePeriod(
                                          AppConstants.dateFilters[i]),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: state.selectedPeriod ==
                                              AppConstants.dateFilters[i]
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(11),
                                      boxShadow: state.selectedPeriod ==
                                              AppConstants.dateFilters[i]
                                          ? [
                                              BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 12)
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      periodTexts[
                                              AppConstants.dateFilters[i]] ??
                                          '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: state.selectedPeriod ==
                                                AppConstants.dateFilters[i]
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Total badge
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.expenseLight
                        .withValues(alpha: context.isDark ? 0.1 : 1.0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_down, color: AppColors.expense),
                      const SizedBox(width: 12),
                      Text(context.tr('total_expenses_label'),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: AppColors.textSecondary)),
                      const Spacer(),
                      Text(state.totalExpense.formattedAmount,
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.expense)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Daily Expenses
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? AppColors.surfaceDark
                        : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: context.isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.tr('daily_expenses'),
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(context.tr('stats_daily_hint'),
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.textSecondary)),
                      if (daily.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(context.tr('no_daily_data'),
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.textSecondary)),
                          ),
                        )
                      else ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
child: _summaryTile(
                                context,
                                Icons.calendar_view_day,
                                AppColors.primary,
                                context.tr('average_per_day'),
                                Text(
                                  dailyAvg.formattedAmount,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _summaryTile(
                                context,
                                Icons.local_fire_department,
                                AppColors.expense,
context.tr('busiest_day'),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${topDay!.key.dayName(context)} · ${topDay!.key.formattedDate(context)}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.warning),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      topDay!.value.formattedAmount,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.expense),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        StatsBarChart(
                            dailyExpenses: state.dailyExpenses,
                            selectedPeriod: state.selectedPeriod),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Pie Chart
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? AppColors.surfaceDark
                        : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: context.isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.tr('distribution_by_category'),
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      StatsPieChart(
                          categoryExpenses: state.categoryExpenses,
                          totalExpense: state.totalExpense),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Top Category
                if (state.topCategory.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('top_category_spend'),
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.85))),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${state.topCategory.categoryEmoji} ${state.topCategory.localizedCategoryName(context)}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${state.topCategoryPercentage.toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(state.topCategoryAmount.formattedAmount,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

Widget _summaryTile(BuildContext context, IconData icon, Color color,
      String label, Widget value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Directionality(
            textDirection: TextDirection.ltr,
            child: value,
          ),
        ],
      ),
    );
  }
}
