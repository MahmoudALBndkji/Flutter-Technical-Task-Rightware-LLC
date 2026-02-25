part of 'favourite_cubit.dart';

class FavouriteState extends Equatable {
  final BaseState<List<DataModel>> favourites;

  const FavouriteState({
    this.favourites = const BaseState<List<DataModel>>(),
  });

  factory FavouriteState.initial() {
    return const FavouriteState(
      favourites: BaseState<List<DataModel>>(),
    );
  }

  FavouriteState copyWith({
    BaseState<List<DataModel>>? favourites,
  }) {
    return FavouriteState(
      favourites: favourites ?? this.favourites,
    );
  }

  @override
  List<Object?> get props => [favourites];
}
