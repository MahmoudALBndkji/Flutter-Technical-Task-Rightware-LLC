part of 'shop_cubit.dart';

enum ShopSortBy { none, etaAsc, minOrderAsc }

class ShopState extends Equatable {
  final BaseState<List<ShopModel>> shops;
  final String searchQuery;
  final ShopSortBy sortBy;
  final bool openOnly;

  const ShopState({
    required this.shops,
    this.searchQuery = '',
    this.sortBy = ShopSortBy.none,
    this.openOnly = false,
  });

  List<ShopModel> get displayedShops {
    var list = shops.data ?? [];
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      list = list.where((s) {
        final nameEn = (s.shopName?.en ?? '').toLowerCase();
        final nameAr = (s.shopName?.ar ?? '').toLowerCase();
        final descEn = (s.description?.en ?? '').toLowerCase();
        final descAr = (s.description?.ar ?? '').toLowerCase();
        return nameEn.contains(q) ||
            nameAr.contains(q) ||
            descEn.contains(q) ||
            descAr.contains(q);
      }).toList();
    }
    if (openOnly) {
      list = list.where((s) => s.isOpen).toList();
    }
    switch (sortBy) {
      case ShopSortBy.etaAsc:
        list = List.from(list)
          ..sort((a, b) =>
              (a.estimatedDeliveryTimeMinutes ?? 0)
                  .compareTo(b.estimatedDeliveryTimeMinutes ?? 0));
        break;
      case ShopSortBy.minOrderAsc:
        list = List.from(list)
          ..sort((a, b) =>
              (a.minimumOrderAmount ?? 0).compareTo(b.minimumOrderAmount ?? 0));
        break;
      case ShopSortBy.none:
        break;
    }
    return list;
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || sortBy != ShopSortBy.none || openOnly;

  ShopState copyWith({
    BaseState<List<ShopModel>>? shops,
    String? searchQuery,
    ShopSortBy? sortBy,
    bool? openOnly,
  }) {
    return ShopState(
      shops: shops ?? this.shops,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      openOnly: openOnly ?? this.openOnly,
    );
  }

  @override
  List<Object?> get props => [shops, searchQuery, sortBy, openOnly];
}
