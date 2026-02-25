import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/injection_container.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_router.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/cubit/language_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LanguageCubit>()..getSavedLanguage(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          final locale = state is ChangeLanguageState
              ? state.locale
              : Locale(defaultLanguage());
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            locale: locale,
            title: "Grocery Stores",
            debugShowCheckedModeBanner: false,
            supportedLocales: const [Locale("en"), Locale("ar")],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (Locale locale in supportedLocales) {
                if (deviceLocale != null &&
                    deviceLocale.languageCode == locale.languageCode) {
                  return deviceLocale;
                }
              }
              return supportedLocales.first;
            },
            theme: ThemeData(
              fontFamily: 'myFont',
              useMaterial3: true,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColors.primaryColor,
                selectionColor: AppColors.primaryColor,
                selectionHandleColor: AppColors.primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
