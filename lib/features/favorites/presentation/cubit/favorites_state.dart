import 'package:equatable/equatable.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';

class FavoritesState extends Equatable {
  const FavoritesState({this.items = const []});
  final List<ShopModel> items;

  FavoritesState copyWith({List<ShopModel>? items}) {
    return FavoritesState(items: items ?? this.items);
  }

  bool isFavorite(ShopModel shop) {
    final id = shop.id;
    if (id == null) return false;
    return items.any((s) => s.id == id);
  }

  /// For HydratedBloc persistence.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  /// For HydratedBloc persistence.
  static FavoritesState fromJson(Map<String, dynamic> json) {
    final list = json['items'];
    if (list == null || list is! List) return const FavoritesState();
    return FavoritesState(
      items: list
          .map(
            (e) => ShopModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [items];
}
