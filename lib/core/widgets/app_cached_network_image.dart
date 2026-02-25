import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/assets.dart';

/// App-wide cached network image with logo placeholder/error and tuned caching.
///
/// - Uses [AssetsImage.logo] while loading and on error.
/// - Memory-efficient decoding via [memCacheWidth]/[memCacheHeight].
/// - Smooth fade-in and configurable [BoxFit].
class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fadeInDuration = const Duration(milliseconds: 220),
    this.fadeOutDuration = const Duration(milliseconds: 120),
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  /// Decode image at this width for memory (smaller = less RAM). Omit for full resolution.
  final int? memCacheWidth;
  /// Decode image at this height for memory. Omit for full resolution.
  final int? memCacheHeight;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, Object)? errorWidget;

  /// Default placeholder/error: logo centered on a light background.
  static Widget buildLogoPlaceholder(BuildContext context) {
    return Container(
      color: AppColors.secondaryColor.withValues(alpha: 0.2),
      alignment: Alignment.center,
      child: Image.asset(
        AssetsImage.logo,
        fit: BoxFit.contain,
        width: 64,
        height: 64,
        errorBuilder: (_, __, ___) => Icon(
          Icons.store_rounded,
          size: 56,
          color: AppColors.primaryColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholder: placeholder ?? (_, __) => buildLogoPlaceholder(context),
      errorWidget: errorWidget ?? (_, __, ___) => buildLogoPlaceholder(context),
      cacheKey: imageUrl,
    );
  }
}
