import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FavoritesCubit extends HydratedCubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState());

  void addFavorite(ShopModel shop) {
    if (state.isFavorite(shop)) return;
    emit(state.copyWith(items: [...state.items, shop]));
  }

  void removeFavorite(ShopModel shop) {
    final id = shop.id;
    if (id == null) return;
    emit(state.copyWith(
      items: state.items.where((s) => s.id != id).toList(),
    ));
  }

  void toggleFavorite(ShopModel shop) {
    if (state.isFavorite(shop)) {
      removeFavorite(shop);
    } else {
      addFavorite(shop);
    }
  }

  @override
  FavoritesState? fromJson(Map<String, dynamic> json) =>
      FavoritesState.fromJson(json);

  @override
  Map<String, dynamic> toJson(FavoritesState state) => state.toJson();
}
