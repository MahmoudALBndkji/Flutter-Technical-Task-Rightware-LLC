# Grocery Stores App

Flutter application for browsing grocery stores (shops) with search, sort, filter, favorites, and offline support. Supports English and Arabic with RTL-aware UI.

## Demo Video
https://github.com/user-attachments/assets/7e5ff3a4-6e61-4d4c-83b2-2959da8b383b

## Try the app

| | |
|---|---|
| **Try the app (APK)** | Download **Grocery Stores App.apk** for Android from the shared folder: [Grocery Stores App – Google Drive](https://drive.google.com/drive/folders/1qeilcVZ_RHDuWmLfvD33jT5eOZnotwVo?usp=sharing). Install on your device and run (you may need to allow installation from unknown sources). |

## Features

- **Shops list** – Cover photo, name, description, ETA, minimum order, location, Open/Closed badge. Tap to open shop details.
- **Search** – Debounced search by shop name or description (~400 ms).
- **Sort** – By ETA (ascending) or minimum order (ascending).
- **Filter** – “Open only” to show only open shops; clear button to reset.
- **Shop details** – Full-screen details with cover, info, and description; favorite heart in app bar.
- **Favorites** – Add/remove from list and details; list persisted across app restarts (HydratedBloc).
- **Settings** – Avatar, language toggle (EN/AR), app name, version.
- **Connectivity** – Root snackbar when going offline (grey) or back online (green). Pull-to-refresh on shops list only when online.
- **Offline & cache** – Shops list and favorites are persisted; after restart or when offline, last data is shown. Refresh indicator recalls the API only when online.
- **Security** – Device checks (root/jailbreak, developer mode, emulator); restricted screen with countdown and app exit when a threat is detected. See [Security](docs/security.md).

## How to Run

### Prerequisites

- Flutter SDK (see `environment.sdk` in `pubspec.yaml`, e.g. ^3.10.8)
- Dart 3.x

### Configuration

The app reads the shops API base URL and secret key from environment files:

1. **Environment files** (under `env/`):
   - `env/.env.dev` – development
   - `env/.env.prod` – production

2. **Required variables:**
   - `BASE_URL` – full URL of the shops API (e.g. `https://api.example.com/shop/test/find/all/shop`)
   - `SECRET_KEY` – API secret key (sent in request headers)

3. **Regenerate env code** after changing `.env.*` files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Run commands

```bash
# Install dependencies
flutter pub get

# Run in development (uses .env.dev)
flutter run --dart-define=ENV=dev

# Run in production (uses .env.prod)
flutter run --dart-define=ENV=prod
```

If you omit `--dart-define=ENV=...`, the app defaults to `dev`.

## Architecture

- **State management** – Cubit (flutter_bloc). Shops and Favorites use HydratedCubit for persistence.
- **Structure** – Feature-based: `lib/features/<feature>/` with data (datasources, models, repos) and presentation (cubits, screens, widgets).
- **DI** – GetIt in `lib/core/services/injection_container.dart`.
- **Routing** – go_router; paths in `lib/core/routing/app_paths.dart`, routes in `app_router.dart`.
- **Localization** – `context.tr('key')`, keys in `assets/lang/en.json` and `assets/lang/ar.json`; `currentLangAr()` for en/ar model fields.

## Documentation

| Document | Description |
|----------|-------------|
| [Specification](docs/specification.md) | Product and technical specification, data models, API, requirements. |
| [Architecture](docs/architecture.md) | App structure, DI, routing, state, and core components. |
| [Shops feature](docs/shops-feature.md) | Shops list, details, data flow, Cubit, caching, and refresh. |
| [Favorites feature](docs/favorites-feature.md) | Favorites Cubit, persistence, and UI. |
| [Settings & localization](docs/settings-and-localization.md) | Settings screen, language switch, and translations. |
| [Connectivity & offline](docs/connectivity-and-offline.md) | Connectivity snackbar and offline/cache behavior. |
| [Security](docs/security.md) | Device security checks, SecurityWrapper, RestrictedScreen, and flow. |
| [Configuration and env](docs/configuration-and-env.md) | Env setup, run modes, and API configuration. |

## Key Dependencies

- `flutter_bloc` / `hydrated_bloc` – state and persistence
- `go_router` – navigation
- `dio` – HTTP (shops API)
- `connectivity_plus` – online/offline
- `cached_network_image` – image caching with logo placeholder/error
- `flutter_secure_storage` – e.g. locale persistence
- `envied` – compile-time env from `.env.*`
- `root_checker_plus` – root/jailbreak and developer mode detection
- `device_info_plus` – physical device vs emulator/simulator

## Assumptions & trade-offs

- Shops API returns a JSON array (or object with a list). Keys are normalized in the data source.
- `initEnv()` is called in `main()` before `initServiceLocator()` so env is available for the shops API.
- Connectivity is best-effort (device connectivity state); actual reachability to the API may differ.
- Favorites and shops cache are stored via HydratedBloc (default storage directory); no encryption.
