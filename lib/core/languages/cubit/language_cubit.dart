import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/language_cache_helper.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static LanguageCubit get(context) => BlocProvider.of(context);

  String selectedLanguage = isCacheLanguage()
      ? isArabic()
            ? "ar"
            : "en"
      : "ar";

  LanguageCubit() : super(LanguageInitial());

  Future<void> getSavedLanguage() async {
    final String cachedLanguageCode = await LanguageCacheHelper()
        .getCachedLanguageCode();
    emit(
      ChangeLanguageState(locale: Locale(cachedLanguageCode.substring(0, 2))),
    );
  }

  Future<void> changeLanguage(String languageCode) async {
    selectedLanguage = languageCode;
    await LanguageCacheHelper().cacheLanguageCode(languageCode);
    emit(ChangeLanguageState(locale: Locale(languageCode)));
  }
}
