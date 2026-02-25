import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
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
}
