import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocaleState extends Equatable {
  final String languageCode;
  final bool isArabic;
  final Locale locale;

  const LocaleState({
    required this.languageCode,
    required this.isArabic,
    required this.locale,
  });

  LocaleState copyWith({
    String? languageCode,
    bool? isArabic,
    Locale? locale,
  }) {
    return LocaleState(
      languageCode: languageCode ?? this.languageCode,
      isArabic: isArabic ?? this.isArabic,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object> get props => [languageCode, isArabic, locale];
}
