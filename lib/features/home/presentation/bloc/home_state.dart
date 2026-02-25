part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

class HomeSwitchState extends HomeState {}

class ChangeBottomNavigationBarState extends HomeState {}

class ChangeCurrentOrderTabBarState extends HomeState {}

class NavigationDestinationPageState extends HomeState {}

class GetCategoriesLoading extends HomeState {}

class GetCategoriesFailure extends HomeState {
  final String errorMessage;
  GetCategoriesFailure({required this.errorMessage});
}

// class GetCategoriesSuccess extends HomeState {
//   final CategoryEntity categories;
//   GetCategoriesSuccess({required this.categories});
// }

class NavigateSubsequentOrderCardState extends HomeState {}

class NavigateReceivedOrderCardState extends HomeState {}

class GetFixingOrderLoading extends HomeState {}

class GetFixingOrderError extends HomeState {
  final String errorMessage;

  GetFixingOrderError({required this.errorMessage});
}

class GetTopBannerLoading extends HomeState {}

class GetTopBannerFailure extends HomeState {
  final String errorMessage;

  GetTopBannerFailure({required this.errorMessage});
}

// class GetTopBannerSuccess extends HomeState {
//   final List<TopBannerEntity> banners;

//   GetTopBannerSuccess({required this.banners});
// }

class GetNewProductsLoading extends HomeState {}

class GetNewProductsFailure extends HomeState {
  final String errorMessage;
  GetNewProductsFailure({required this.errorMessage});
}

// class GetNewProductsSuccess extends HomeState {
//   final List<NewProductsEntity> newProducts;
//   GetNewProductsSuccess({required this.newProducts});
// }

class SetFromHistoryDateState extends HomeState {}