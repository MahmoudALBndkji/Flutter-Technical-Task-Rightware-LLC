import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/styles.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key, required this.shop});
  final ShopModel shop;

  @override
  Widget build(BuildContext context) {
    final isOpen = shop.isOpen;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CoverPhoto(coverPhoto: shop.coverPhoto, isOpen: isOpen),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: TextStyles.textStyle20.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (shop.descriptionText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    shop.descriptionText,
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
                    Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'ETA: ${shop.estimatedDeliveryTimeDisplay}',
                      style: TextStyles.textStyle12,
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Min: ${_formatMinOrder(shop.minimumOrderAmount)}',
                      style: TextStyles.textStyle12,
                    ),
                  ],
                ),
                if (shop.location.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
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
  const CoverPhoto({super.key, this.coverPhoto, required this.isOpen});
  final String? coverPhoto;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
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
              color: isOpen ? Colors.green : AppColors.cancelledColor,
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
              isOpen ? 'Open' : 'Closed',
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
      color: Colors.grey[300],
      child: Icon(Icons.store, size: 48, color: Colors.grey[500]),
    );
  }
}
