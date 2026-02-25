import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';

/// ETA, min order, and location rows for shop details.
class ShopDetailsInfoSection extends StatelessWidget {
  const ShopDetailsInfoSection({
    super.key,
    required this.etaDisplay,
    required this.minOrderDisplay,
    required this.location,
  });

  final String etaDisplay;
  final String minOrderDisplay;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: context.tr('eta'),
            value: etaDisplay,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.shopping_bag_rounded,
            label: context.tr('min_order'),
            value: minOrderDisplay,
          ),
          if (location.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.location_on_rounded,
              label: context.tr('location'),
              value: location,
              maxLines: 3,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
          color: AppColors.primaryColor.withValues(alpha: 0.9),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryColor.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.primaryColor.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
