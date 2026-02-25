# Shops Feature (Track A)

## Overview

The Shops feature displays a list of grocery stores from a remote API, with debounced search, sort, filter, clear, and explicit loading/error/empty and “no results” states.

## Data Flow

1. **Data layer**
   - `ShopDataSource` (abstract) → `ShopRemoteDataSource` (uses `ApiConsumer` and `Env`).
   - API: GET to `env.baseUrl` with header `secretKey: env.secretKey`.
   - Response: JSON array or object with `data` / `shops`; keys can be snake_case or camelCase (normalized in the data source).
   - `ShopRepository` calls the data source and returns `Future<List<ShopModel>>`.

2. **State**
   - `ShopCubit` holds:
     - `BaseState<List<ShopModel>> shops` (loading / success / failure and list).
     - `searchQuery`, `sortBy` (none | etaAsc | minOrderAsc), `openOnly`.
   - `displayedShops` is derived: filter by search (name/description), then by `openOnly`, then sort by ETA or min order when selected.

3. **UI**
   - `ShopsScreen`: App bar + body with `ShopsListView`.
   - `ShopsListView`: Search field (debounced), sort dropdown, “Open only” switch, “Clear” button, and list or empty/error/no-results states.
   - `ShopCard`: Cover image, name, description, ETA, minimum order, location, Open/Closed badge.

## Cubit API

- `loadShops()` – fetches from repository and updates `shops` state.
- `setSearchQuery(String)` – updates search (UI debounces before calling).
- `setSortBy(ShopSortBy)` – none / etaAsc / minOrderAsc.
- `setOpenOnly(bool)` – filter to open shops only.
- `clearFilters()` – resets search, sort, and open-only.

## Track A Requirements

| Requirement        | Implementation                                      |
|--------------------|-----------------------------------------------------|
| Debounced search   | ~400 ms timer in `ShopsListView` before `setSearchQuery` |
| Sort by ETA        | `ShopSortBy.etaAsc`                                 |
| Sort by min order  | `ShopSortBy.minOrderAsc`                            |
| Filter open only   | `openOnly` flag + filter in `displayedShops`       |
| Clear button       | “Clear” resets search/sort/filter                   |
| No results state   | When `displayedShops` is empty but raw list is not |

## File Layout

- `lib/features/shops/`
  - `data/datasources/shop_data_source.dart`, `shop_remote_data_source.dart`
  - `data/models/shop_model.dart` (+ `.g.dart`)
  - `data/repos/shop_repository.dart`
  - `presentation/cubits/shop/shop_cubit.dart`, `shop_state.dart`
  - `presentation/screens/shops_screen.dart`
  - `presentation/widgets/shop_card.dart`, `shops_list_view.dart`

## Dependency Injection

Registered in `initServiceLocator()`:

- `Env` → global `env`
- `ShopDataSource` → `ShopRemoteDataSource(apiConsumer, env)`
- `ShopRepository` → `ShopRepository(dataSource)`
- `ShopCubit` → `ShopCubit(repository: sl())`

`ShopCubit` is provided to the home route so the Shops tab has access to it.
