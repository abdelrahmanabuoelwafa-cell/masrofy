import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'core/services/notification_service.dart';
import 'data/local/isar_service.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/add_transaction/presentation/cubit/add_transaction_cubit.dart';
import 'features/statistics/presentation/cubit/statistics_cubit.dart';
import 'features/all_transactions/presentation/cubit/all_transactions_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/locale/presentation/cubit/locale_cubit.dart';
import 'features/locale/presentation/cubit/locale_state.dart';
import 'features/splash/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Platform-specific settings (skip on web)
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
    }

    // Initialize Hive for Flutter Web compatibility
    await Hive.initFlutter();

    // Open 'user_box' once only (guarded to survive hot-reload / retry).
    // NOTE: 'app_settings' is deliberately NOT opened here as Box<dynamic>.
    // It is opened by IsarService as Box<SettingsModel> during initialize(),
    // so it is always a single, consistent type.
    if (!Hive.isBoxOpen('user_box')) {
      await Hive.openBox('user_box');
    }

    // Initialize Isar service
    final isarService = IsarService();
    await isarService.initialize();

    // Initialize notification service (skip on web as it's not supported)
    if (!kIsWeb) {
      try {
        final notificationService = NotificationService();
        await notificationService.initialize();

        final notifEnabled = Hive.box('app_settings')
            .get('notifications_enabled', defaultValue: true) as bool;
        if (notifEnabled) {
          await notificationService.scheduleDailyReminder();
        }
      } catch (e) {
        // Silently fail on notification errors
        print('Notification service initialization failed: $e');
      }
    }

    // Load language from Hive with safe fallback
    final languageCode =
        Hive.box('user_box').get('language', defaultValue: 'ar') as String;

    runApp(
        MasroufyApp(isarService: isarService, initialLanguage: languageCode));
  } catch (e, stackTrace) {
    // Catch any initialization errors and show a fallback UI
    print('Initialization error: $e');
    print('Stack trace: $stackTrace');

    runApp(
      MaterialApp(
        title: 'مصروفي - Masroufy',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Initialization Error',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Error: $e',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Retry initialization
                    main();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MasroufyApp extends StatelessWidget {
  final IsarService isarService;
  final String initialLanguage;
  const MasroufyApp(
      {super.key, required this.isarService, required this.initialLanguage});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit(isarService)),
        BlocProvider(create: (_) => AddTransactionCubit(isarService)),
        BlocProvider(create: (_) => StatisticsCubit(isarService)),
        BlocProvider(create: (_) => AllTransactionsCubit(isarService)),
        BlocProvider(create: (_) => SettingsCubit(isarService)),
        BlocProvider(create: (_) => LocaleCubit(initialLanguage)),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                key: ValueKey(localeState.languageCode),
                title: 'مصروفي - Masrofy',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode:
                    themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                locale: localeState.locale,
                supportedLocales: const [Locale('ar'), Locale('en')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder: (context, child) {
                  return Directionality(
                    textDirection: localeState.isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: child!,
                  );
                },
                home: SplashPage(isarService: isarService),
              );
            },
          );
        },
      ),
    );
  }
}
