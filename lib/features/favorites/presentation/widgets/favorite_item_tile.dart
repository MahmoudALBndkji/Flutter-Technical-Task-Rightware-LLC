import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/widgets/app_cached_network_image.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/widgets/favorite_heart_button.dart';

class FavoriteItemTile extends StatelessWidget {
  const FavoriteItemTile({
    super.key,
    required this.shop,
    required this.displayName,
    required this.isFavorite,
    required this.onTap,
    required this.onRemoveFavorite,
  });

  final ShopModel shop;
  final String displayName;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onRemoveFavorite;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(shop.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.cancelledColor.withValues(alpha: 0.3),
        child: Icon(
          Icons.delete_outline_rounded,
          color: AppColors.cancelledColor,
          size: 28,
        ),
      ),
      onDismissed: (_) => onRemoveFavorite(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 72,
                    child:
                        shop.coverPhoto != null && shop.coverPhoto!.isNotEmpty
                        ? AppCachedNetworkImage(
                            imageUrl: shop.coverPhoto!,
                            fit: BoxFit.cover,
                            memCacheWidth: 200,
                            memCacheHeight: 200,
                          )
                        : Container(
                            color: AppColors.secondaryColor.withValues(
                              alpha: 0.2,
                            ),
                            child: Icon(
                              Icons.store_rounded,
                              size: 36,
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor.withValues(alpha: 0.95),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            shop.estimatedDeliveryTimeDisplay,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FavoriteHeartButton(
                  isFavorite: isFavorite,
                  onTap: onRemoveFavorite,
                  size: 26,
                  padding: const EdgeInsets.all(6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
