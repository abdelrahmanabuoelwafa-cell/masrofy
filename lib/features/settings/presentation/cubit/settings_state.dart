import 'package:equatable/equatable.dart';
import '../../../../data/models/settings_model.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final SettingsModel? settings;
  final double budgetPercentage;
  final double remainingBudget;
  final String? error;
  final bool dataCleared;

  const SettingsState({
    this.isLoading = true,
    this.settings,
    this.budgetPercentage = 0,
    this.remainingBudget = 0,
    this.error,
    this.dataCleared = false});

  SettingsState copyWith({
    bool? isLoading,
    SettingsModel? settings,
    double? budgetPercentage,
    double? remainingBudget,
    String? error,
    bool? dataCleared,
  }) {
    return SettingsState(
        isLoading: isLoading ?? this.isLoading,
        settings: settings ?? this.settings,
        budgetPercentage: budgetPercentage ?? this.budgetPercentage,
        remainingBudget: remainingBudget ?? this.remainingBudget,
        error: error,
        dataCleared: dataCleared ?? this.dataCleared);
  }

  @override
  List<Object?> get props =>
      [isLoading, settings, budgetPercentage, remainingBudget, error, dataCleared];
}

