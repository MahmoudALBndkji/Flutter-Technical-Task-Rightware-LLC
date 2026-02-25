import 'dart:convert';
import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/network/local/secure_storage.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/models/user_model.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  static const String _favouritesKey = 'favourite_users';

  FavouriteCubit() : super(FavouriteState.initial()) {
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    try {
      emit(
        state.copyWith(
          favourites: state.favourites.copyWith(status: BaseStatus.loading),
        ),
      );
      final favouritesJson =
          await SecureStorage.instance.read(key: _favouritesKey);

      if (favouritesJson != null && favouritesJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(favouritesJson);
        final favourites = decoded
            .map((item) => DataModel.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(
          state.copyWith(
            favourites: state.favourites.copyWith(
              status: BaseStatus.success,
              data: favourites,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            favourites: state.favourites.copyWith(
              status: BaseStatus.success,
              data: [],
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          favourites: state.favourites.copyWith(
            status: BaseStatus.failure,
            error: 'Failed to load favourites',
          ),
        ),
      );
    }
  }

  Future<void> addFavourite(DataModel user) async {
    try {
      final currentFavourites = List<DataModel>.from(
        state.favourites.data ?? [],
      );

      if (currentFavourites.any((fav) => fav.id == user.id)) {
        return;
      }

      final userModel = _convertToDataModel(user);
      currentFavourites.add(userModel);

      await _saveFavourites(currentFavourites);
      emit(
        state.copyWith(
          favourites: state.favourites.copyWith(
            status: BaseStatus.success,
            data: currentFavourites,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          favourites: state.favourites.copyWith(
            status: BaseStatus.failure,
            error: 'Failed to add favourite',
          ),
        ),
      );
    }
  }

  Future<void> removeFavourite(int userId) async {
    try {
      final currentFavourites = List<DataModel>.from(
        state.favourites.data ?? [],
      );
      currentFavourites.removeWhere((fav) => fav.id == userId);

      await _saveFavourites(currentFavourites);
      emit(
        state.copyWith(
          favourites: state.favourites.copyWith(
            status: BaseStatus.success,
            data: currentFavourites,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          favourites: state.favourites.copyWith(
            status: BaseStatus.failure,
            error: 'Failed to remove favourite',
          ),
        ),
      );
    }
  }

  bool isFavourite(int userId) {
    return state.favourites.data?.any((fav) => fav.id == userId) ?? false;
  }

  Future<void> _saveFavourites(List<DataModel> favourites) async {
    final favouritesJson = jsonEncode(
      favourites.map((fav) {
        final model = _convertToDataModel(fav);
        return model.toJson();
      }).toList(),
    );
    await SecureStorage.instance.write(key: _favouritesKey, value: favouritesJson);
  }

  DataModel _convertToDataModel(DataModel entity) {
    if (entity is DataModel) {
      return entity;
    }
    return DataModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      name: entity.name != null
          ? NameModel(
              firstname: entity.name!.firstname,
              lastname: entity.name!.lastname,
            )
          : null,
      address: entity.address != null
          ? AddressModel(
              street: entity.address!.street,
              city: entity.address!.city,
              zipcode: entity.address!.zipcode,
              country: entity.address!.country,
            )
          : null,
      phone: entity.phone,
      orders: entity.orders,
    );
  }
}
