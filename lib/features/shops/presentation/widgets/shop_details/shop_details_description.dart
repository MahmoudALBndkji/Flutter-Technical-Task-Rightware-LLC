import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';

/// Description block for shop details.
class ShopDetailsDescription extends StatelessWidget {
  const ShopDetailsDescription({
    super.key,
    required this.descriptionText,
  });

  final String descriptionText;

  @override
  Widget build(BuildContext context) {
    if (descriptionText.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('description'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descriptionText,
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: AppColors.primaryColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
