part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class ChangeBottomNavigationBar extends HomeEvent {
  final int index;
  const ChangeBottomNavigationBar({required this.index});
}

class ChangeCurrentOrderTabBar extends HomeEvent {
  final int index;
  const ChangeCurrentOrderTabBar({required this.index});
}

class NavigationDestinationPage extends HomeEvent {
  final int pageIndex;
  const NavigationDestinationPage({required this.pageIndex});
}

class GetCategories extends HomeEvent {
  final BuildContext context;

  GetCategories({required this.context});
}

class GetFixingOrdersEvent extends HomeEvent {
  final BuildContext context;
  final int status;

  GetFixingOrdersEvent({required this.context, required this.status});
}

class GetTopBanner extends HomeEvent {
  final BuildContext context;
  GetTopBanner({required this.context});
}

class GetNewProductsEvent extends HomeEvent {
  final BuildContext context;

  GetNewProductsEvent({required this.context});
}

class GetOrdersCategoryArchieveEvent extends HomeEvent {
  final BuildContext context;
  final String khazenId;

  GetOrdersCategoryArchieveEvent({
    required this.context,
    required this.khazenId,
  });
}

class ChangeInitSliderCategoryArchieve extends HomeEvent {
  final bool isSearch;

  ChangeInitSliderCategoryArchieve({required this.isSearch});
}

class GetLastPaymentEvent extends HomeEvent {
  final BuildContext context;

  GetLastPaymentEvent({required this.context});
}

class StoreTokenEmployeeEvent extends HomeEvent {
  final BuildContext context;
  StoreTokenEmployeeEvent({required this.context});
}

class SetFromHistoryDate extends HomeEvent {
  final String value;
  final bool isFrom;

  SetFromHistoryDate({required this.value, this.isFrom = true});
}
