import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/core/network/connectivity_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/core/widgets/logo_animation_loading.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/cubits/shop/shop_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/animated_shop_card.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shops_clear_filters_button.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shops_filter_bar.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shops_search_bar.dart';

class ShopsListView extends StatefulWidget {
  const ShopsListView({super.key});

  @override
  State<ShopsListView> createState() => _ShopsListViewState();
}

class _ShopsListViewState extends State<ShopsListView> {
  Timer? _debounce;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) context.read<ShopCubit>().setSearchQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if (state.shops.status.isFailure && state.shops.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.shops.error!),
              backgroundColor: AppColors.cancelledColor,
            ),
          );
        }
      },
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        if (state.shops.status.isLoading && state.shops.data == null) {
          return LogoAnimationLoading(message: 'loading');
        }
        if (state.shops.status.isFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.primaryColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.shops.error ?? context.tr('error'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryColor.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.read<ShopCubit>().loadShops(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.whiteColor,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: Text(context.tr('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        final displayed = state.displayedShops;
        final isEmpty = (state.shops.data ?? []).isEmpty;
        final noResults = !isEmpty && displayed.isEmpty;

        return RefreshIndicator(
          onRefresh: () async {
            if (context.read<ConnectivityCubit>().state ==
                ConnectivityStatus.offline) {
              return;
            }
            await context.read<ShopCubit>().loadShops();
          },
          color: AppColors.primaryColor,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ShopsSearchBar(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      hintText: context.tr('search_by_name_or_description'),
                    ),
                    const SizedBox(height: 12),
                    ShopsFilterBar(
                      sortBy: state.sortBy,
                      openOnly: state.openOnly,
                      onSortChanged: (v) =>
                          context.read<ShopCubit>().setSortBy(v),
                      onOpenOnlyChanged: (v) =>
                          context.read<ShopCubit>().setOpenOnly(v),
                    ),
                    if (state.hasActiveFilters) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ShopsClearFiltersButton(
                          onPressed: () {
                            _searchController.clear();
                            context.read<ShopCubit>().clearFilters();
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store_outlined,
                        size: 64,
                        color: AppColors.primaryColor.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.tr('no_shops_available'),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (noResults)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.primaryColor.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.tr('no_results'),
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr('try_different_search_or_filters'),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) =>
                      AnimatedShopCard(shop: displayed[i], index: i),
                  childCount: displayed.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
