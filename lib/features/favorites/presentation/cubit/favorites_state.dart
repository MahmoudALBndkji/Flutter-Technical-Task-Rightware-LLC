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

  @override
  List<Object?> get props => [items];
}
