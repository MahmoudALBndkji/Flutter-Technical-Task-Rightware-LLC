import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/styles.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(context.tr("home_page"), style: TextStyles.textStyle16),
        elevation: 1.0,
        centerTitle: true,
      ),
      body: Center(
        child: Text(context.tr("home_page"), style: TextStyles.textStyle20),
      ),
    );
  }
}
