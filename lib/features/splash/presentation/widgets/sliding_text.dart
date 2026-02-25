import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/styles.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';

class SlidingText extends StatelessWidget {
  const SlidingText({super.key, required this.slidingAnimation});
  final Animation<Offset> slidingAnimation;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: slidingAnimation,
    builder: (context, _) => SlideTransition(
      position: slidingAnimation,
      child: Text(
        "Grocery Stores",
        textAlign: TextAlign.center,
        style: TextStyles.textStyle20.copyWith(color: AppColors.blackColor),
      ),
    ),
  );
}
