import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/assets.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';

customError() {
  return ErrorWidget.builder = ((details) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            Expanded(flex: 2, child: Image.asset(AssetsImage.notFound)),
            const SizedBox(height: 10.0),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "something_wrong".tr(),
                  // if you want to show main message error cancel comment below
                  // details.exception.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
