import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../locale/presentation/cubit/locale_cubit.dart';
import '../../../locale/presentation/cubit/locale_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/recent_transactions_widget.dart';
import '../widgets/notification_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onSetBudget;
  const HomePage({super.key, this.onSetBudget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<HomeCubit>().loadHomeData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${context.tr('greeting')} ${Hive.box('user_box').get('username', defaultValue: context.tr('my_friend'))} 👋',
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: context.isDark
                                        ? AppColors.textDarkPrimary
                                        : AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text(
                                '${DateTime.now().dayName(context)}، ${DateTime.now().formattedDate(context)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, themeState) {
                          return GestureDetector(
                            onTap: () =>
                                context.read<ThemeCubit>().toggleTheme(),
                            child: Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: context.isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                themeState.isDarkMode
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                                color: context.isDark
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<LocaleCubit, LocaleState>(
                        builder: (context, localeState) {
                          return GestureDetector(
                            onTap: () =>
                                context.read<LocaleCubit>().switchLanguage(),
                            child: Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: context.isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  localeState.languageCode == 'ar'
                                      ? 'EN'
                                      : 'عربي',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: context.isDark
                                          ? Colors.white
                                          : AppColors.primary),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          final hasUnread = state.notifications
                              .any((n) => !n.isRead);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const NotificationPage()),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: context.isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                      Icons.notifications_outlined,
                                      color: AppColors.primary),
                                ),
                                if (hasUnread)
                                  Positioned(
                                    right: 6,
                                    top: 6,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: AppColors.expense,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (onSetBudget != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onSetBudget,
                        icon: const Icon(Icons.savings_outlined,
                            color: Colors.white, size: 28),
                        label: Text(context.tr('set_budget_button'),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
const BalanceCard(),
                  if (state.showBudgetWarning) ...[
                    const SizedBox(height: 16),
                    _BudgetWarningBanner(),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 28),
                  Text(context.tr('spent_on'),
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? AppColors.surfaceDark
                          : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: context.isDark
                              ? AppColors.darkCardBorder
                              : AppColors.divider),
                    ),
                    child: const HomePieChart(),
                  ),
                  const SizedBox(height: 28),
                  Text(context.tr('recent_transactions'),
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textPrimary)),
                  const SizedBox(height: 14),
const RecentTransactionsWidget(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BudgetWarningBanner extends StatefulWidget {
  @override
  State<_BudgetWarningBanner> createState() => _BudgetWarningBannerState();
}

class _BudgetWarningBannerState extends State<_BudgetWarningBanner> {
  @override
  void initState() {
    super.initState();
    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.read<HomeCubit>().dismissBudgetWarning();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.expense.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.expense.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.expense, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.tr('budget_warning_message'),
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.expense,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
