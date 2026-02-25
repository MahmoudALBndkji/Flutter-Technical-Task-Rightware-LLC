import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/cubit/language_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/core/network/connectivity_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_router.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/injection_container.dart';

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
            builder: (context, child) {
              return BlocProvider(
                create: (_) => ConnectivityCubit(),
                child: BlocListener<ConnectivityCubit, ConnectivityStatus>(
                  listenWhen: (prev, curr) => prev != curr,
                  listener: (context, status) {
                    final messenger = ScaffoldMessenger.maybeOf(context);
                    if (messenger == null) return;
                    messenger.hideCurrentSnackBar();
                    final isOffline =
                        status == ConnectivityStatus.offline;
                    messenger.showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              isOffline
                                  ? Icons.cloud_off_rounded
                                  : Icons.wifi_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                context.tr(isOffline ? 'offline' : 'online'),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: isOffline
                            ? AppColors.offlineSnackbarColor
                            : AppColors.onlineSnackbarColor,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(12),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
