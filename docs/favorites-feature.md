# Favorites Feature

## Overview

Users can mark shops as favorites from the list (shop card) or from the shop details screen. The favorites list is shown in a dedicated tab and persisted with HydratedBloc so it survives app restarts.

## State

- **FavoritesCubit** (extends `HydratedCubit<FavoritesState>`).
- **FavoritesState**: `List<ShopModel> items`; helper `isFavorite(shop)`.
- **Persistence**: `toJson()` / `fromJson()` serialize/deserialize the list of `ShopModel` (using existing model `toJson`/`fromJson`).

## Cubit API

- `addFavorite(ShopModel)` – Add if not already in list.
- `removeFavorite(ShopModel)` – Remove by shop id.
- `toggleFavorite(ShopModel)` – Add or remove.

## UI

- **Favorite heart** – Used on `ShopCard` (over cover) and in `ShopDetailsScreen` app bar. Animated heart icon; tap toggles favorite. Implemented in `FavoriteHeartButton` (scale animation).
- **Favorites screen** – Second tab in bottom nav. Title “Favourites”, then list of favorite shops. Each item shows thumbnail, name, ETA, and heart; tap opens shop details; swipe-to-dismiss or heart tap removes from favorites. Empty state when no favorites.
- **Favorite item tile** – Uses `AppCachedNetworkImage` for thumbnail; name uses `currentLangAr()` for en/ar.

## Navigation

- Favorites tab is part of `HomeLayout` (same stack as Shops and Settings).
- Tapping a favorite item: `context.push(AppPaths.shopDetails, extra: shop)`.

## Dependency Injection & Provision

- `FavoritesCubit` is registered as lazy singleton in GetIt.
- Provided via `BlocProvider.value(value: sl<FavoritesCubit>())` in the home route and in the shop-details route so both list/details and favorites screen can read/write favorites.

## File Layout

- `lib/features/favorites/`
  - `presentation/cubit/` – `favorites_cubit.dart`, `favorites_state.dart`
  - `presentation/screens/` – `favorites_screen.dart`
  - `presentation/widgets/` – `favorite_heart_button.dart`, `favorite_item_tile.dart`

## Translations

Keys used: `favourites`, `no_favourites_yet`, `remove` (and shared keys for open/closed, etc.).
