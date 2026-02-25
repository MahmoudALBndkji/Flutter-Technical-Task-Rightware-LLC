import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/assets.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_paths.dart';
import 'package:flutter_technical_task_rightware_llc/features/splash/presentation/widgets/sliding_text.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    initSlidingAnimation();
    navigateToLogin();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          AssetsImage.logo,
          fit: BoxFit.contain,
          width: widthScreen / 2,
          height: widthScreen / 1.5,
        ),
        const SizedBox(height: 30.0),
        SlidingText(slidingAnimation: slidingAnimation),
      ],
    );
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    slidingAnimation = Tween<Offset>(
      begin: const Offset(0, 10),
      end: Offset.zero,
    ).animate(animationController);
    animationController.forward();
  }

  void navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () => context.go(AppPaths.home));
  }
}
