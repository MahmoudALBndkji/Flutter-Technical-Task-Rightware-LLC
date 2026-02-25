import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/styles.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';

void customSnackBar({
  required BuildContext context,
  required String keyLanguage,
  EdgeInsets? margin = const EdgeInsets.all(8.0),
  Color? backgroundColor = AppColors.primaryColor,
}) => ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    margin: margin,
    backgroundColor: backgroundColor,
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.tr(keyLanguage),
          style: TextStyles.textStyle16.copyWith(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ),
);
