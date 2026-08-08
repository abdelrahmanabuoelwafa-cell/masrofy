import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../data/local/isar_service.dart';
import '../../features/add_transaction/presentation/cubit/add_transaction_cubit.dart';
import '../../features/add_transaction/presentation/pages/add_transaction_sheet.dart';
import '../../features/all_transactions/presentation/cubit/all_transactions_cubit.dart';
import '../../features/all_transactions/presentation/pages/all_transactions_page.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/statistics/presentation/cubit/statistics_cubit.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/locale/presentation/cubit/locale_cubit.dart';
import '../../features/locale/presentation/cubit/locale_state.dart';

class MainPage extends StatefulWidget {
  final IsarService isarService;
  const MainPage({super.key, required this.isarService});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  void _goToSettings() => setState(() => _currentIndex = 3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return IndexedStack(
              index: _currentIndex,
              children: [
                HomePage(onSetBudget: _goToSettings),
                const StatisticsPage(),
                const AllTransactionsPage(),
                const SettingsPage(),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final cubit = AddTransactionCubit(widget.isarService);
          final homeCubit = context.read<HomeCubit>();
          final allCubit = context.read<AllTransactionsCubit>();
          final statsCubit = context.read<StatisticsCubit>();
          final settingsCubit = context.read<SettingsCubit>();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
                value: cubit, child: const AddTransactionSheet()),
          ).then((_) {
            homeCubit.loadHomeData();
            allCubit.loadAllTransactions();
            statsCubit.loadStatistics(statsCubit.state.selectedPeriod);
            settingsCubit.loadSettings();
          });
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add, size: 24),
        label: Text(context.tr('new_transaction'),
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return Container(
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            decoration: BoxDecoration(
                color: context.isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4))
                ]),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BottomNavigationBar(
                  currentIndex:
                      _currentIndex >= 2 ? _currentIndex + 1 : _currentIndex,
                  onTap: (i) =>
                      setState(() => _currentIndex = i >= 2 ? i - 1 : i),
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: AppColors.textSecondary,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: [
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.home_outlined, size: 22),
                        activeIcon: const Icon(Icons.home, size: 22),
                        label: context.tr('home')),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.bar_chart_outlined, size: 22),
                        activeIcon: const Icon(Icons.bar_chart, size: 22),
                        label: context.tr('statistics')),
                    const BottomNavigationBarItem(
                        icon: SizedBox(width: 22),
                        activeIcon: SizedBox(width: 22),
                        label: ''),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.receipt_long_outlined, size: 22),
                        activeIcon: const Icon(Icons.receipt_long, size: 22),
                        label: context.tr('transactions')),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.settings_outlined, size: 22),
                        activeIcon: const Icon(Icons.settings, size: 22),
                        label: context.tr('settings')),
                  ],
                )),
          );
        },
      ),
    );
  }
}
