import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';

/// Animated button to clear search and filters. Uses [primaryColor] / [secondaryColor].
class ShopsClearFiltersButton extends StatefulWidget {
  const ShopsClearFiltersButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<ShopsClearFiltersButton> createState() => _ShopsClearFiltersButtonState();
}

class _ShopsClearFiltersButtonState extends State<ShopsClearFiltersButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: TextButton.icon(
        onPressed: widget.onPressed,
        icon: Icon(
          Icons.clear_all_rounded,
          size: 20,
          color: AppColors.primaryColor,
        ),
        label: Text(
          context.tr('clear'),
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.secondaryColor.withValues(alpha: 0.25),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
