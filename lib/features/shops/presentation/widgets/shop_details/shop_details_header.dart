import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';

/// Shop name and optional category with smooth appearance.
class ShopDetailsHeader extends StatelessWidget {
  const ShopDetailsHeader({
    super.key,
    required this.shopName,
    this.categoryType,
  });

  final String shopName;
  final String? categoryType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shopName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor.withValues(alpha: 0.95),
              letterSpacing: 0.2,
            ),
          ),
          if (categoryType != null && categoryType!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              categoryType!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
