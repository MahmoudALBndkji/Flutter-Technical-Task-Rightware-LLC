import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/styles.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key, required this.shop});
  final ShopModel shop;

  @override
  Widget build(BuildContext context) {
    final isAr = currentLangAr();
    final name = isAr
        ? (shop.shopName?.ar ?? shop.shopName?.en ?? '—')
        : (shop.shopName?.en ?? shop.shopName?.ar ?? '—');
    final descriptionText = isAr
        ? (shop.description?.ar ?? shop.description?.en ?? '')
        : (shop.description?.en ?? shop.description?.ar ?? '');
    final isOpen = shop.isOpen;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: AppColors.primaryColor.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CoverPhoto(
            coverPhoto: shop.coverPhoto,
            isOpen: isOpen,
            openLabel: context.tr('open'),
            closedLabel: context.tr('closed'),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyles.textStyle20.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                if (descriptionText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    descriptionText,
                    style: TextStyles.textStyle14.copyWith(
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: AppColors.primaryColor.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${context.tr('eta')}: ${shop.estimatedDeliveryTimeDisplay}',
                      style: TextStyles.textStyle12,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 16,
                      color: AppColors.primaryColor.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${context.tr('min_order')}: ${_formatMinOrder(shop.minimumOrderAmount)}',
                      style: TextStyles.textStyle12,
                    ),
                  ],
                ),
                if (shop.location.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.primaryColor.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shop.location,
                          style: TextStyles.textStyle12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatMinOrder(num? value) {
    if (value == null) return '—';
    if (value == value.truncate()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}

class CoverPhoto extends StatelessWidget {
  const CoverPhoto({
    super.key,
    this.coverPhoto,
    required this.isOpen,
    required this.openLabel,
    required this.closedLabel,
  });
  final String? coverPhoto;
  final bool isOpen;
  final String openLabel;
  final String closedLabel;

  @override
  Widget build(BuildContext context) {
    final statusLabel = isOpen ? openLabel : closedLabel;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: coverPhoto != null && coverPhoto!.isNotEmpty
              ? Image.network(
                  coverPhoto!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, Object e, StackTrace? st) => _placeholder(),
                )
              : _placeholder(),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isOpen
                  ? AppColors.primaryColor
                  : AppColors.cancelledColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              statusLabel,
              style: TextStyles.textStyle12.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.secondaryColor.withOpacity(0.2),
      child: Icon(
        Icons.store,
        size: 48,
        color: AppColors.primaryColor.withOpacity(0.5),
      ),
    );
  }
}
