import 'dart:convert';
import 'package:flutter_technical_task_rightware_llc/core/network/local/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_router.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations({required this.locale});

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationDelegate();

  late Map<String, String> _localizedStrings;

  bool hasKey(String key) => _localizedStrings.containsKey(key);

  Future<void> load() async {
    final jsonString = await rootBundle.loadString(
      'assets/lang/${locale.languageCode}.json',
    );

    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      const ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale: locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

class LocalizationService {
  static AppLocalizations get _instance {
    final context = navigatorKey.currentContext;
    if (context == null) {
      throw Exception('Localization context is not ready');
    }
    return AppLocalizations.of(context);
  }

  static String tr(String key) {
    return _instance.translate(key);
  }
}

extension TranslateX on String {
  String tr() => LocalizationService.tr(this);
}

extension LocalizationX on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this).translate(key);
  }
}

String defaultLanguage() => "en";

bool isCacheLanguage() => SecureStorage.instance.locale != null;

bool isArabic() => SecureStorage.instance.locale == "ar";

bool currentLangAr() => isCacheLanguage()
    ? isArabic()
          ? true
          : false
    : false;
