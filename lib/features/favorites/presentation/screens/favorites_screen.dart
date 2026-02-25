import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_paths.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/widgets/favorite_item_tile.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor.withValues(alpha: 0.12),
              AppColors.secondaryColor.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Text(
                    context.tr('favourites'),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor.withValues(alpha: 0.95),
                    ),
                  ),
                ),
              ),
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state.items.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border_rounded,
                              size: 80,
                              color: AppColors.primaryColor.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.tr('no_favourites_yet'),
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primaryColor.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final shop = state.items[index];
                        final isAr = currentLangAr();
                        final displayName = isAr
                            ? (shop.shopName?.ar ?? shop.shopName?.en ?? '—')
                            : (shop.shopName?.en ?? shop.shopName?.ar ?? '—');
                        return FavoriteItemTile(
                          shop: shop,
                          displayName: displayName,
                          isFavorite: state.isFavorite(shop),
                          onTap: () => context.push(
                            AppPaths.shopDetails,
                            extra: shop,
                          ),
                          onRemoveFavorite: () =>
                              context.read<FavoritesCubit>().removeFavorite(shop),
                        );
                      },
                      childCount: state.items.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
