# Shops Feature

## Overview

The Shops feature displays a list of grocery stores from a remote API, with debounced search, sort, filter, clear, shop details screen, pull-to-refresh (when online), and persistent cache so data survives app restarts and is available offline.

## Data Flow

1. **Data layer**
   - `ShopDataSource` (abstract) → `ShopRemoteDataSource` (uses `ApiConsumer` and `Env`).
   - API: GET to `env.baseUrl` with header `secretKey: env.secretKey`.
   - Response: JSON array (or object with list); keys normalized in the data source.
   - `ShopRepository` returns `Future<List<ShopModel>>`.

2. **State**
   - `ShopCubit` (extends `HydratedCubit<ShopState>`) holds:
     - `BaseState<List<ShopModel>> shops` (loading / success / failure and list).
     - `searchQuery`, `sortBy` (none | etaAsc | minOrderAsc), `openOnly`.
   - `displayedShops` is derived: filter by search (name/description), then by `openOnly`, then sort when selected.
   - State is persisted via HydratedBloc so the list is restored on app restart (e.g. when offline).

3. **UI**
   - **ShopsScreen**: Gradient app bar, `ShopListSection` (rounded content area).
   - **ShopListSection**: Wraps `ShopsListView` in a rounded container.
   - **ShopsListView**: Search bar (debounced), filter bar (sort + “Open only”), clear button, `RefreshIndicator`, and list or empty/error/no-results states. Uses `AppCachedNetworkImage` for cover images (logo placeholder/error).
   - **ShopCard**: Cover, name, description, ETA, min order, location, Open/Closed badge, favorite heart. Tap navigates to shop details.
   - **Shop details**: `ShopDetailsScreen` with cover, header, info (ETA, min order, location), description, and favorite heart in app bar. Name/description use `currentLangAr()` for en/ar.

## Cubit API

- `loadShops()` – Fetches from repository and updates `shops` state (and persists via HydratedBloc).
- `setSearchQuery(String)` – Updates search (UI debounces before calling).
- `setSortBy(ShopSortBy)` – none / etaAsc / minOrderAsc.
- `setOpenOnly(bool)` – Filter to open shops only.
- `clearFilters()` – Resets search, sort, and open-only.

## Pull-to-refresh

- `ShopsListView` wraps the scroll content in `RefreshIndicator`.
- `onRefresh`: If `ConnectivityCubit.state == ConnectivityStatus.offline`, returns immediately; otherwise calls `loadShops()` and awaits it.
- `AlwaysScrollableScrollPhysics()` ensures pull works even with short or empty content.

## Caching (HydratedBloc)

- `ShopState.toJson()` / `fromJson()` persist `shops` (status, data list, error), `searchQuery`, `sortBy`, `openOnly`.
- `ShopModel` is serialized via existing `toJson()` / `fromJson()` (generated).
- On app start, `ShopCubit` restores state from storage when available; home route only calls `loadShops()` when `shops.data` is null or empty.

## Navigation

- List item tap: `context.push(AppPaths.shopDetails, extra: shop)`.
- Shop details screen receives `ShopModel` from route `extra`; app bar has back and favorite heart.

## File Layout

- `lib/features/shops/`
  - `data/datasources/` – `shop_data_source.dart`, `shop_remote_data_source.dart`
  - `data/models/` – `shop_model.dart`, `shop_model.g.dart`
  - `data/repos/` – `shop_repository.dart`
  - `presentation/cubits/shop/` – `shop_cubit.dart`, `shop_state.dart`
  - `presentation/screens/` – `shops_screen.dart`, `shop_details_screen.dart`
  - `presentation/widgets/` – `shop_card.dart`, `animated_shop_card.dart`, `shops_list_view.dart`, `shop_list_section.dart`, `shop_custom_app_bar.dart`, `shops_search_bar.dart`, `shops_filter_bar.dart`, `shops_clear_filters_button.dart`, `shop_details/` (cover, header, info_section, description)

## Dependency Injection

- `ShopDataSource` → `ShopRemoteDataSource(apiConsumer, env)`
- `ShopRepository` → `ShopRepository(dataSource)`
- `ShopCubit` → `ShopCubit(repository: sl())` (HydratedCubit, persistence configured in `main.dart`)

`ShopCubit` is provided to the home route; `FavoritesCubit` is provided to home and to the shop-details route.
