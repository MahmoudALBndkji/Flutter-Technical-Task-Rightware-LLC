# Connectivity and Offline Behavior

## Connectivity Snackbar

- **Package**: `connectivity_plus`.
- **ConnectivityCubit**: Listens to `Connectivity().onConnectivityChanged` and runs an initial `checkConnectivity()`. Emits `ConnectivityStatus.online` or `ConnectivityStatus.offline`.
- **Root snackbar**: In `MyApp`, `MaterialApp.router` uses a `builder` that wraps the child in `BlocProvider<ConnectivityCubit>` and `BlocListener<ConnectivityCubit, ConnectivityStatus>`. Listener runs only when status **changes** (`listenWhen: (prev, curr) => prev != curr`).
  - **Offline**: Snackbar with grey background (`AppColors.offlineSnackbarColor`), offline icon, message `context.tr('offline')`.
  - **Online**: Snackbar with green background (`AppColors.onlineSnackbarColor`), wifi icon, message `context.tr('online')`.
- **Style**: Floating snackbar, margin 12, duration 2 seconds; previous snackbar is hidden before showing the new one.

## Offline and Cached Data

- **Shops list**: `ShopCubit` is a `HydratedCubit`; state (list + filters) is persisted. On app restart or when offline, the last loaded list is shown.
- **Favorites**: `FavoritesCubit` is a `HydratedCubit`; favorites list is persisted and restored on restart.
- **Pull-to-refresh**: On the shops list, `RefreshIndicator.onRefresh` checks connectivity; if offline it returns without calling the API; if online it calls `loadShops()` and awaits it. So refresh only hits the endpoint when online.

## When Data Is Loaded

- **Shops**: On navigating to home, if `ShopCubit.state.shops.data` is null or empty, `loadShops()` is called. Otherwise cached state is used (from HydratedBloc). User can pull-to-refresh when online to refetch.
- **Favorites**: Always from cubit state (persisted); no network call.

## Translations

- Keys `offline` and `online` in `assets/lang/en.json` and `assets/lang/ar.json` for the snackbar messages.
