import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../models/settings_model.dart';
import '../models/notification_model.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  Box<TransactionModel>? _transactionsBox;
  Box<dynamic>? _settingsBox;
  Box<NotificationModel>? _notificationsBox;

  factory IsarService() => _instance;
  IsarService._internal();

  Future<void> initialize() async {
    // Safe check before registering adapters to prevent duplicate registration on hot-reload
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SettingsModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }

    _transactionsBox = await _getOrOpenBox<TransactionModel>('transactions');
    _settingsBox = await _getOrOpenBox<dynamic>('app_settings');
    _notificationsBox = await _getOrOpenBox<NotificationModel>('notifications');

    final settings = await getSettings();
    if (settings == null) {
      await saveSettings(SettingsModel());
    }
  }

  // Opens a box with the requested type, or safely reuses it if already open.
  // Handles the case where the box is still open with a different type
  // (e.g. Box<dynamic> from a previous session / hot-reload) by closing and
  // reopening it with the correct type.
  Future<Box<T>> _getOrOpenBox<T>(String name) async {
    if (!Hive.isBoxOpen(name)) {
      return Hive.openBox<T>(name);
    }
    try {
      return Hive.box<T>(name);
    } catch (_) {
      // Close the already-open box, then reopen it with the correct type.
      await Hive.box(name).close();
      return Hive.openBox<T>(name);
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    transaction.id = (_transactionsBox?.length ?? 0) + 1;
    await _transactionsBox?.add(transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final index = _transactionsBox?.values
        .toList()
        .indexWhere((item) => item.id == transaction.id);
    if (index != null && index >= 0) {
      await _transactionsBox?.putAt(index, transaction);
    } else {
      await _transactionsBox?.add(transaction);
    }
  }

  Future<void> deleteTransaction(int id) async {
    final index =
        _transactionsBox?.values.toList().indexWhere((item) => item.id == id);
    if (index != null && index >= 0) {
      await _transactionsBox?.deleteAt(index);
    }
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final items = _transactionsBox?.values.toList() ?? <TransactionModel>[];
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<List<TransactionModel>> getTransactionsInRange(
      DateTime start, DateTime end) async {
    final items = (await getAllTransactions()).where((item) {
      return !item.date.isBefore(start) && !item.date.isAfter(end);
    }).toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<List<TransactionModel>> getMonthlyTransactions(
      int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);
    return getTransactionsInRange(start, end);
  }

  Future<List<TransactionModel>> getWeeklyTransactions() async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final startOfDay = DateTime(start.year, start.month, start.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return getTransactionsInRange(startOfDay, endOfDay);
  }

  Future<List<TransactionModel>> getYearlyTransactions(int year) async {
    return getTransactionsInRange(
        DateTime(year, 1, 1), DateTime(year, 12, 31, 23, 59, 59));
  }

  Future<void> saveSettings(SettingsModel settings) async {
    settings.id = 1;
    await _settingsBox?.put(settings.id, settings);
  }

Future<SettingsModel?> getSettings() async {
    final s = _settingsBox?.get(1) as SettingsModel?;
    if (s == null) return null;
    // Return a fresh copy so state managers (equatable) detect changes instead
    // of re-using the same Hive object reference (which would not rebuild UI).
    return s.copyWith();
  }

  Future<void> updateBudget(double budget) async {
    final settings = await getSettings();
    if (settings != null) {
      settings.monthlyBudget = budget;
      await saveSettings(settings);
    }
  }

  Future<void> updateDarkMode(bool isDark) async {
    final settings = await getSettings();
    if (settings != null) {
      settings.darkMode = isDark;
      await saveSettings(settings);
    }
  }

  Future<void> updateUserName(String name) async {
    final settings = await getSettings();
    if (settings != null) {
      settings.userName = name;
      await saveSettings(settings);
    }
  }

Future<void> clearAllTransactions() async {
    await _transactionsBox?.clear();
  }

  Future<void> addNotification(NotificationModel notification) async {
    notification.id =
        (_notificationsBox?.values.length ?? 0) + 1;
    await _notificationsBox?.add(notification);
  }

  Future<List<NotificationModel>> getNotifications() async {
    final items =
        _notificationsBox?.values.toList() ?? <NotificationModel>[];
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<void> markNotificationRead(int id) async {
    final index = _notificationsBox?.values
        .toList()
        .indexWhere((item) => item.id == id);
    if (index != null && index >= 0) {
      final item = _notificationsBox?.getAt(index);
      if (item != null) {
        item.isRead = true;
        await _notificationsBox?.putAt(index, item);
      }
    }
  }

  Future<void> clearNotifications() async {
    await _notificationsBox?.clear();
  }

  Future<void> clearAllData() async {
    await _transactionsBox?.clear();
    await _settingsBox?.clear();
    await _notificationsBox?.clear();
    await saveSettings(SettingsModel());
  }
}
