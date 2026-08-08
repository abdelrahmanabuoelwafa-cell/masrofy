import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_state.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../../../locale/presentation/cubit/locale_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final budget = state.settings?.monthlyBudget ?? 5000;
        final pct = state.budgetPercentage;
        final progressColor = pct >= AppConstants.dangerThreshold
            ? AppColors.expense
            : pct >= AppConstants.warningThreshold
                ? AppColors.warning
                : AppColors.income;

        return Scaffold(
          backgroundColor: context.isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(context.tr('settings_title'),
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 24),

                // Budget Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.account_balance_wallet,
                                color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(context.tr('budget'),
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _showBudgetDialog(context, budget),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(context.tr('edit'),
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(budget.formattedAmount,
                          style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                      const SizedBox(height: 20),
Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.tr('spent_so_far'),
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                          Text('${(pct * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: progressColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.tr('remaining_budget'),
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                          Text(
                            state.remainingBudget.formattedAmount,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: state.remainingBudget >= 0
                                    ? AppColors.income
                                    : AppColors.expense),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: pct.clamp(0, 1),
                          backgroundColor: AppColors.divider,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(progressColor),
                          minHeight: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (pct >= AppConstants.dangerThreshold)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.expenseSoft.withValues(
                                  alpha: context.isDark ? 0.1 : 1.0),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: AppColors.expense, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(context.tr('exceeded_budget'),
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.expense,
                                          fontWeight: FontWeight.w500))),
                            ],
                          ),
                        )
                      else if (pct >= AppConstants.warningThreshold)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.warningLight.withValues(
                                  alpha: context.isDark ? 0.1 : 1.0),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.warning, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                      '${context.tr('near_budget')} (${(pct * 100).toStringAsFixed(0)}%)',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: const Color(0xFFD4A017),
                                          fontWeight: FontWeight.w500))),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Dark Mode
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    return _tile(Icons.dark_mode_outlined,
                        context.tr('dark_mode'), null, context,
                        trailing: Switch(
                            value: themeState.isDarkMode,
                            onChanged: (v) =>
                                context.read<ThemeCubit>().setTheme(v),
                            activeThumbColor: AppColors.primary));
                  },
                ),
                // Currency
                Builder(
                  builder: (context) {
                    final settingsBox = Hive.box('app_settings');
                    final currencyCode = settingsBox.get('currency',
                        defaultValue: 'EGP') as String;

                    final currencies = {
                      'EGP': {
                        'name': 'جنيه مصري',
                        'nameEn': 'Egyptian Pound',
                        'symbol': 'EGP'
                      },
                      'SAR': {
                        'name': 'ريال سعودي',
                        'nameEn': 'Saudi Riyal',
                        'symbol': 'SAR'
                      },
                      'AED': {
                        'name': 'درهم إماراتي',
                        'nameEn': 'UAE Dirham',
                        'symbol': 'AED'
                      },
                      'USD': {
                        'name': 'دولار أمريكي',
                        'nameEn': 'US Dollar',
                        'symbol': '\$'
                      },
                      'EUR': {'name': 'يورو', 'nameEn': 'Euro', 'symbol': '€'},
                    };

                    final isArabic = context.read<LocaleCubit>().state.isArabic;
                    final currentCurrency = currencies[currencyCode];
                    final currencyName = currentCurrency != null
                        ? (isArabic
                            ? currentCurrency['name']
                            : currentCurrency['nameEn'])
                        : (isArabic ? 'جنيه مصري' : 'Egyptian Pound');
                    final currencySymbol = currentCurrency != null
                        ? currentCurrency['symbol']
                        : currencyCode;

                    return _tile(
                      Icons.currency_exchange,
                      context.tr('currency'),
                      '$currencySymbol - $currencyName',
                      context,
                      onTap: () => _showCurrencyDialog(context, currencyCode,
                          context.read<LocaleCubit>().state.isArabic),
                    );
                  },
                ),
                // Notifications
                Builder(
                  builder: (context) {
                    final settingsBox = Hive.box('app_settings');
                    final notifEnabled = settingsBox.get(
                        'notifications_enabled',
                        defaultValue: true) as bool;

                    return _tile(
                      Icons.notifications_outlined,
                      context.tr('notifications'),
                      null,
                      context,
                      trailing: Switch(
                        value: notifEnabled,
                        onChanged: (value) async {
                          await settingsBox.put('notifications_enabled', value);
                          final notificationService = NotificationService();
                          if (value) {
                            await notificationService.scheduleDailyReminder();
                          } else {
                            await notificationService.cancelDailyReminder();
                          }
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    );
                  },
                ),
                // Language
                Builder(
                  builder: (context) {
                    return _tile(
                      Icons.language_outlined,
                      context.tr('language'),
                      context.read<LocaleCubit>().state.isArabic
                          ? context.tr('arabic')
                          : context.tr('english'),
                      context,
                      onTap: () => context.read<LocaleCubit>().switchLanguage(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // About
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(context.tr('app_masroufy'),
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(context.tr('app_desc'),
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.8)),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text('v1.0.0 — 100% Offline',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.6))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Clear Data
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showClearDialog(context),
                    icon: const Icon(Icons.delete_forever,
                        color: AppColors.expense),
                    label: Text(context.tr('clear_data_btn'),
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.expense)),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.expense, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
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

  Widget _tile(
      IconData icon, String title, String? subtitle, BuildContext context,
      {VoidCallback? onTap, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: context.isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.divider),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500)),
          subtitle: subtitle != null
              ? Text(subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.textSecondary))
              : null,
          trailing: trailing,
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, double current) {
    final c = TextEditingController(text: current.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('edit_budget'),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
              hintText: context.tr('enter_budget'),
              suffixText: 'EGP',
              suffixStyle: GoogleFonts.poppins(color: AppColors.textSecondary)),
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.tr('cancel'), style: GoogleFonts.poppins())),
          TextButton(
            onPressed: () {
              final v = double.tryParse(c.text);
              if (v != null && v > 0) {
                context.read<SettingsCubit>().updateBudget(v);
                context.read<HomeCubit>().updateBudget(v);
              }
              Navigator.pop(ctx);
            },
            child: Text(context.tr('save'),
                style: GoogleFonts.poppins(
                    color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('clear_confirmation'),
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: AppColors.expense)),
        content: Text(context.tr('clear_data_warning'),
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.tr('cancel'), style: GoogleFonts.poppins())),
          TextButton(
            onPressed: () {
              context.read<SettingsCubit>().clearAllData();
              context.read<HomeCubit>().loadHomeData();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(context.tr('data_cleared')),
                  backgroundColor: AppColors.income,
                  behavior: SnackBarBehavior.floating));
            },
            child: Text(context.tr('clear_all'),
                style: GoogleFonts.poppins(
                    color: AppColors.expense, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(
      BuildContext context, String currentCurrency, bool isArabic) {
    final currencies = [
      {
        'code': 'EGP',
        'name': 'جنيه مصري',
        'nameEn': 'Egyptian Pound',
        'symbol': 'EGP'
      },
      {
        'code': 'SAR',
        'name': 'ريال سعودي',
        'nameEn': 'Saudi Riyal',
        'symbol': 'SAR'
      },
      {
        'code': 'AED',
        'name': 'درهم إماراتي',
        'nameEn': 'UAE Dirham',
        'symbol': 'AED'
      },
      {
        'code': 'USD',
        'name': 'دولار أمريكي',
        'nameEn': 'US Dollar',
        'symbol': '\$'
      },
      {'code': 'EUR', 'name': 'يورو', 'nameEn': 'Euro', 'symbol': '€'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('choose_currency'),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              final name = isArabic ? currency['name'] : currency['nameEn'];
              final code = currency['code'];
              final symbol = currency['symbol'];
              final isSelected = code == currentCurrency;

              return ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () async {
                  if (code == null) return;
                  final settingsCubit = context.read<SettingsCubit>();
                  final settingsBox = Hive.box('app_settings');
                  await settingsBox.put('currency', code);
                  settingsCubit.loadSettings();
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                  }
                },
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                title: Text(name ?? '',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text(symbol ?? '',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textSecondary)),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.tr('cancel'), style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}
