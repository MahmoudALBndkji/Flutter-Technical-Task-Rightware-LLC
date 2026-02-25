import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/cubit/language_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/settings/presentation/widgets/settings_animated_section.dart';
import 'package:flutter_technical_task_rightware_llc/features/settings/presentation/widgets/settings_avatar_section.dart';
import 'package:flutter_technical_task_rightware_llc/features/settings/presentation/widgets/settings_language_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  static const int _staggerMs = 80;
  static const int _animDurationMs = 420;

  late AnimationController _animController;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    final curve = Curves.easeOutCubic;
    _fadeAnims = List.generate(4, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(
            (i * _staggerMs / _animDurationMs).clamp(0.0, 0.85),
            0.3 + (i * 0.2),
            curve: curve,
          ),
        ),
      );
    });
    _slideAnims = List.generate(4, (i) {
      return Tween<Offset>(
        begin: const Offset(0, 0.06),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(
            (i * _staggerMs / _animDurationMs).clamp(0.0, 0.85),
            0.35 + (i * 0.2),
            curve: curve,
          ),
        ),
      );
    });
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              SettingsAnimatedSection(
                fade: _fadeAnims[0],
                slide: _slideAnims[0],
                child: const SettingsAvatarSection(),
              ),
              const SizedBox(height: 40),
              SettingsAnimatedSection(
                fade: _fadeAnims[1],
                slide: _slideAnims[1],
                child: SettingsLanguageButton(
                  onTap: () => context.read<LanguageCubit>().changeLanguage(
                    currentLangAr() ? 'en' : 'ar',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SettingsAnimatedSection(
                fade: _fadeAnims[2],
                slide: _slideAnims[2],
                child: Text(
                  context.tr('app_name'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor.withValues(alpha: 0.95),
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              SettingsAnimatedSection(
                fade: _fadeAnims[3],
                slide: _slideAnims[3],
                child: Text(
                  '${context.tr('version')} 1.0.0',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryColor.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
