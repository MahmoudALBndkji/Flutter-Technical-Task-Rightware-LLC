import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'styles.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: "myFont",
  colorScheme: const ColorScheme.light().copyWith(
    primary: AppColors.primaryColor,
    secondary: AppColors.primaryColor,
    error: AppColors.cancelledColor,
  ),
  useMaterial3: true,
  textTheme: TextTheme(
    bodyLarge: TextStyles.textStyle20.copyWith(
      fontFamily: "myFont",
      color: AppColors.blackColor,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyles.textStyle18.copyWith(
      fontFamily: "myFont",
      color: AppColors.whiteColor,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 1.0,
    backgroundColor: AppColors.primaryColor,
    titleTextStyle: TextStyles.textStyle20.copyWith(
      fontFamily: "myFont",
      color: AppColors.blackColor,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  ),
  scaffoldBackgroundColor: AppColors.whiteColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.blue[400]!,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: AppColors.primaryColor,
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: "myFont",
  colorScheme: const ColorScheme.dark().copyWith(
    primary: AppColors.primaryColor,
    secondary: AppColors.primaryColor,
    error: AppColors.cancelledColor,
  ),
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    elevation: 1.0,
    titleTextStyle: TextStyles.textStyle20.copyWith(
      fontFamily: "myFont",
      color: AppColors.whiteColor,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: AppColors.primaryColor,
  ),
  scaffoldBackgroundColor: AppColors.primaryColor,
  textTheme: TextTheme(
    bodyLarge: TextStyles.textStyle20.copyWith(
      fontFamily: "myFont",
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyles.textStyle18.copyWith(
      fontFamily: "myFont",
      color: AppColors.blackColor,
    ),
  ),
);
