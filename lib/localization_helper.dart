import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationHelper {
  final Locale locale;

  LocalizationHelper(this.locale);

  static late Map<String, String> _localizedStrings;

  static LocalizationHelper of(BuildContext context) {
    return Localizations.of<LocalizationHelper>(context, LocalizationHelper)!;
  }

  Future<bool> load() async {
    final String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key, {Map<String, String>? params}) {
    String? value = _localizedStrings[key];

    if (value == null) return key;

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        value = value!.replaceAll('{$paramKey}', paramValue);
      });
    }

    return value!;
  }

  static const LocalizationsDelegate<LocalizationHelper> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<LocalizationHelper> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<LocalizationHelper> load(Locale locale) async {
    final localizations = LocalizationHelper(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
