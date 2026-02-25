import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/widgets/favorite_heart_button.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shop_details/shop_details_cover.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shop_details/shop_details_description.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shop_details/shop_details_header.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shop_details/shop_details_info_section.dart';
import 'package:go_router/go_router.dart';

/// Shop details view with trendy UI and smooth animations.
class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({super.key, required this.shop});
  final ShopModel shop;

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0, 0.7, curve: Curves.easeOut),
      ),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 1, curve: Curves.easeOutCubic),
      ),
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
    final isAr = currentLangAr();
    final name = isAr
        ? (widget.shop.shopName?.ar ?? widget.shop.shopName?.en ?? '—')
        : (widget.shop.shopName?.en ?? widget.shop.shopName?.ar ?? '—');
    final descriptionText = isAr
        ? (widget.shop.description?.ar ?? widget.shop.description?.en ?? '')
        : (widget.shop.description?.en ?? widget.shop.description?.ar ?? '');
    final minOrderDisplay = _formatMinOrder(widget.shop.minimumOrderAmount);
    final statusLabel = widget.shop.isOpen
        ? context.tr('open')
        : context.tr('closed');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.tr('shop_details'),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              return FavoriteHeartButton(
                isFavorite: state.isFavorite(widget.shop),
                onTap: () =>
                    context.read<FavoritesCubit>().toggleFavorite(widget.shop),
                size: 26,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ShopDetailsCover(
                    coverPhoto: widget.shop.coverPhoto,
                    isOpen: widget.shop.isOpen,
                    statusLabel: statusLabel,
                  ),
                  ShopDetailsHeader(
                    shopName: name,
                    categoryType: widget.shop.categoryType,
                  ),
                  ShopDetailsInfoSection(
                    etaDisplay: widget.shop.estimatedDeliveryTimeDisplay,
                    minOrderDisplay: minOrderDisplay,
                    location: widget.shop.location,
                  ),
                  ShopDetailsDescription(descriptionText: descriptionText),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatMinOrder(num? value) {
    if (value == null) return '—';
    if (value == value.truncate()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}
