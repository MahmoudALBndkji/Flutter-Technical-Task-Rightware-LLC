import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/security_service.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';

class RestrictedScreen extends StatefulWidget {
  final SecurityThreat threat;
  const RestrictedScreen({super.key, required this.threat});

  @override
  State<RestrictedScreen> createState() => _RestrictedScreenState();
}

class _RestrictedScreenState extends State<RestrictedScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  int _countdown = 20;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startCountdown();
  }

  void _initializeAnimations() {
    // Fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Scale animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Pulse animation for icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });

        if (_countdown <= 0) {
          _timer.cancel();
          _closeApp();
        }
      }
    });
  }

  void _closeApp() {
    if (Platform.isAndroid) {
      exit(0);
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _getThreatMessage() {
    final securityService = SecurityService();
    return securityService.getThreatMessage(context, widget.threat);
  }

  IconData _getThreatIcon() {
    switch (widget.threat) {
      case SecurityThreat.rootDetected:
      case SecurityThreat.jailbreakDetected:
        return Icons.security;
      case SecurityThreat.developerModeEnabled:
        return Icons.developer_mode;
      case SecurityThreat.debugModeEnabled:
        return Icons.bug_report;
      case SecurityThreat.emulatorDetected:
        return Icons.phone_android;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondaryColor,
              AppColors.secondaryColor.withValues(alpha: 0.9),
              AppColors.secondaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.cancelledColor.withValues(
                                  alpha: 0.2,
                                ),
                                border: Border.all(
                                  color: AppColors.cancelledColor,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                _getThreatIcon(),
                                size: 60,
                                color: AppColors.cancelledColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Text(
                        context.tr('security_alert'),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.whiteColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getThreatMessage(),
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.whiteColor,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            context.tr('app_will_close_in'),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.whiteColor.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cancelledColor.withValues(
                                alpha: 0.2,
                              ),
                              border: Border.all(
                                color: AppColors.cancelledColor,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 20, end: _countdown),
                                duration: const Duration(seconds: 1),
                                builder: (context, value, child) {
                                  return Text(
                                    '$value',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.cancelledColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.tr('seconds'),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.whiteColor.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: AppColors.whiteColor.withValues(alpha: 0.2),
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 1.0,
                            end: _countdown / 20.0,
                          ),
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,
                          builder: (context, value, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.cancelledColor,
                                      AppColors.cancelledColor.withValues(
                                        alpha: 0.7,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
