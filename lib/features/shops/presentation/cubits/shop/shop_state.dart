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

  /// For HydratedBloc: persist shops list so it survives app restart (e.g. offline).
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'shops': <String, dynamic>{
        'status': shops.status.name,
        'data': shops.data?.map((e) => e.toJson()).toList(),
        'error': shops.error,
      },
      'searchQuery': searchQuery,
      'sortBy': sortBy.name,
      'openOnly': openOnly,
    };
  }

  /// For HydratedBloc: restore cached state.
  static ShopState fromJson(Map<String, dynamic> json) {
    final shopsMap = json['shops'] as Map<String, dynamic>?;
    BaseState<List<ShopModel>> shops = const BaseState();
    if (shopsMap != null) {
      final statusStr = shopsMap['status'] as String?;
      var status = BaseStatus.initial;
      if (statusStr != null) {
        try {
          status = BaseStatus.values.firstWhere((e) => e.name == statusStr);
        } catch (_) {}
      }
      List<ShopModel>? data;
      final dataList = shopsMap['data'] as List<dynamic>?;
      if (dataList != null && dataList.isNotEmpty) {
        data = dataList
            .map((e) =>
                ShopModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      shops = BaseState(
        status: status,
        data: data,
        error: shopsMap['error'] as String?,
      );
    }
    var sortBy = ShopSortBy.none;
    final sortStr = json['sortBy'] as String?;
    if (sortStr != null) {
      try {
        sortBy = ShopSortBy.values.firstWhere((e) => e.name == sortStr);
      } catch (_) {}
    }
    return ShopState(
      shops: shops,
      searchQuery: json['searchQuery'] as String? ?? '',
      sortBy: sortBy,
      openOnly: json['openOnly'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [shops, searchQuery, sortBy, openOnly];
}
