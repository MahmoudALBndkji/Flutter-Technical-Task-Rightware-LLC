# Architecture

## Overview

The app is structured by feature with a shared core. State is managed with Cubit (flutter_bloc); persistence uses HydratedBloc where needed. Navigation uses go_router; dependency injection uses GetIt.

## Folder Structure

```
lib/
├── core/                    # Shared code
│   ├── base/                # Base state, etc.
│   ├── constants/           # App colors, etc.
│   ├── env/                 # Environment (envied)
│   ├── errors/              # Failures, error parsing
│   ├── languages/           # Localization, LanguageCubit
│   ├── network/             # ConnectivityCubit, bloc observer, secure storage, HTTP
│   ├── routing/             # go_router, app_paths
│   ├── security/            # SecurityWrapper, RestrictedScreen
│   ├── services/            # API consumer, Dio, SecurityService, injection_container
│   ├── utils/               # Styles, assets, themes
│   └── widgets/             # Reusable widgets (e.g. AppCachedNetworkImage, LogoAnimationLoading)
├── features/
│   ├── favorites/           # Favorites list and persistence
│   ├── home/                # Home layout, bottom nav
│   ├── settings/            # Settings screen, language
│   ├── shops/               # Shops list, details, data layer
│   └── splash/              # Splash screen
└── main.dart, my_app.dart
```

## State Management

- **Cubit (flutter_bloc)** for all feature state.
- **HydratedCubit** for state that must survive restarts:
  - `ShopCubit` – shops list and filters.
  - `FavoritesCubit` – favorites list.
- **ConnectivityCubit** – online/offline; provided in `MyApp` builder.
- **LanguageCubit** – locale; provided at root in `MyApp`.
- **HomeCubit** – bottom nav index; created per home route.

Persistence is initialized in `main()`: `HydratedBloc.storage = await HydratedStorage.build(...)` (path_provider for directory; web uses `HydratedStorageDirectory.web`).

## Dependency Injection (GetIt)

Registered in `lib/core/services/injection_container.dart`:

- **Core**: Dio, AppInterceptors, ApiConsumer (DioConsumer), LanguageCubit (factory).
- **Shops**: ShopDataSource → ShopRemoteDataSource, ShopRepository, ShopCubit (lazy singleton).
- **Favorites**: FavoritesCubit (lazy singleton).

Cubits that are HydratedCubit are still registered as normal; HydratedBloc uses the same storage instance set in `main()`.

## Routing (go_router)

- **Paths** (`app_paths.dart`): `/` (splash), `/home`, `/shop/details`, `/favorites`, `/restricted`.
- **Router** (`app_router.dart`):
  - **Restricted** at `/restricted`: query `threat`; builds `RestrictedScreen(threat)` (no SecurityWrapper).
  - **Splash** at `/`: wrapped in `SecurityWrapper`; builds `SplashScreen`.
  - **Home** at `/home`: wrapped in `SecurityWrapper`; provides HomeCubit, ShopCubit, FavoritesCubit; loads shops if data is null/empty; builds `HomeLayout`.
  - **Shop details** at `/shop/details`: wrapped in `SecurityWrapper`; receives `ShopModel` in `state.extra`; provides FavoritesCubit; builds `ShopDetailsScreen`.

Navigator key is used for global navigator state (e.g. localization).

## Core Components

- **App colors** – `lib/core/constants/app_colors.dart` (primary, secondary, offline/online snackbar, etc.).
- **Localization** – `AppLocalizations`, `context.tr('key')`, `currentLangAr()`; JSON in `assets/lang/en.json`, `assets/lang/ar.json`.
- **Cached images** – `AppCachedNetworkImage` (cached_network_image, logo placeholder/error, optional memCacheWidth/Height).
- **Connectivity** – `ConnectivityCubit` (connectivity_plus); root snackbar in `MyApp` builder.
- **Security** – `SecurityService` (root/jailbreak, developer mode, emulator; see [Security](security.md)), `SecurityWrapper` (per-route check + periodic re-check), `RestrictedScreen` (block UI and exit). Splash, home, and shop-details routes are wrapped with `SecurityWrapper`.

## Separation of Concerns

- **Screens** – Compose widgets and orchestrate; minimal layout logic.
- **Widgets** – Reusable, presentational; under `presentation/widgets/` per feature (or shared in `core/widgets`).
- **Cubits** – Business logic and state; no UI.
- **Data** – Data sources (remote), models, repositories; no UI or state.
