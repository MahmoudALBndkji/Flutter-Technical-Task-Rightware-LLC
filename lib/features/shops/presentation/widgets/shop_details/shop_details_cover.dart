import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/widgets/app_cached_network_image.dart';

/// Shop details hero cover with gradient overlay.
class ShopDetailsCover extends StatelessWidget {
  const ShopDetailsCover({
    super.key,
    this.coverPhoto,
    required this.isOpen,
    required this.statusLabel,
  });

  final String? coverPhoto;
  final bool isOpen;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              coverPhoto != null && coverPhoto!.isNotEmpty
                  ? AppCachedNetworkImage(
                      imageUrl: coverPhoto!,
                      fit: BoxFit.cover,
                      memCacheWidth: 800,
                      memCacheHeight: 450,
                    )
                  : _placeholder(),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.primaryColor.withValues(alpha: 0.4),
                    ],
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOpen
                  ? AppColors.primaryColor
                  : AppColors.cancelledColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              statusLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.secondaryColor.withValues(alpha: 0.2),
      child: Icon(
        Icons.store_rounded,
        size: 56,
        color: AppColors.primaryColor.withValues(alpha: 0.5),
      ),
    );
  }
}
