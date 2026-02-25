import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:flutter_technical_task_rightware_llc/core/widgets/logo_animation_loading.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/cubits/shop/shop_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shop_card.dart';

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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.shops.error!)));
        }
      },
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        if (state.shops.status.isLoading && state.shops.data == null) {
          return const LogoAnimationLoading();
        }
        if (state.shops.status.isFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    state.shops.error ?? 'Error',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.read<ShopCubit>().loadShops(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final displayed = state.displayedShops;
        final isEmpty = (state.shops.data ?? []).isEmpty;
        final noResults = !isEmpty && displayed.isEmpty;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search by name or description',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<ShopSortBy>(
                            key: ValueKey(state.sortBy),
                            initialValue: state.sortBy,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: ShopSortBy.none,
                                child: Text('Sort'),
                              ),
                              DropdownMenuItem(
                                value: ShopSortBy.etaAsc,
                                child: Text('ETA (asc)'),
                              ),
                              DropdownMenuItem(
                                value: ShopSortBy.minOrderAsc,
                                child: Text('Min order (asc)'),
                              ),
                            ],
                            onChanged: (v) {
                              if (v != null)
                                context.read<ShopCubit>().setSortBy(v);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Open only',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            Switch(
                              value: state.openOnly,
                              onChanged: (v) =>
                                  context.read<ShopCubit>().setOpenOnly(v),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (state.hasActiveFilters) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            _searchController.clear();
                            context.read<ShopCubit>().clearFilters();
                          },
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: const Text('Clear'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('No shops available')),
              )
            else if (noResults)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[500]),
                      const SizedBox(height: 16),
                      Text(
                        'No results',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try different search or filters',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ShopCard(shop: displayed[i]),
                  childCount: displayed.length,
                ),
              ),
          ],
        );
      },
    );
  }
}
