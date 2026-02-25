# Grocery Stores – Flutter App

Flutter application that displays a list of grocery stores (shops) with search, sort, and filter (Track A).

## How to Run

### Prerequisites

- Flutter SDK (see `environment.sdk` in `pubspec.yaml`)
- Dart 3.x

### Configuration

The app reads the shops API URL and secret key from environment files. Configure them before running:

1. **Environment files** (already set up under `env/`):
   - `env/.env.dev` – development
   - `env/.env.prod` – production

2. **Required variables:**
   - `BASE_URL` – full URL of the shops API (e.g. `https://api.orianosy.com/shop/test/find/all/shop`)
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

If you omit `--dart-define=ENV=...`, the app defaults to `dev` and uses `env/.env.dev`.

## Features

- **Shops list**: Cover photo, name, description, estimated delivery time, minimum order, location, Open/Closed badge.
- **Search**: Debounced search by shop name or description (~400 ms).
- **Sort**: By ETA (ascending) or minimum order (ascending).
- **Filter**: Toggle “Open only” to show only open shops.
- **Clear**: Button to reset search, sort, and filter.
- **States**: Loading, error (with retry), empty list, and “no results” when filters/search return nothing.

## Architecture

- **State management**: Cubit (flutter_bloc) with clear separation of UI, state, and data.
- **Structure** (aligned with `lib/features/users/`):
  - **Data**: `data/datasources/` (abstract + remote), `data/models/`, `data/repos/`.
  - **Presentation**: `presentation/cubits/shop/`, `presentation/screens/`, `presentation/widgets/`.
- **DI**: GetIt in `lib/core/services/injection_container.dart`; env and shops stack registered there.
- **Routing**: go_router; Shops is the first tab on the home layout.

## Error Handling

- **Network**: Failures mapped to user-facing messages (timeout, no connection, server errors).
- **UI**: Loading indicator while fetching, error message + Retry on failure, empty and “no results” states.

## Assumptions & Trade-offs

- **API shape**: Shops API returns a JSON array (or an object with `data` / `shops`). Both snake_case and camelCase keys are accepted (normalized in the data source).
- **Env**: `initEnv()` is called in `main()` before `initServiceLocator()` so `env.baseUrl` and `env.secretKey` are available for the shops API. Dio’s default base URL remains for other endpoints (e.g. users); shops use the full URL from `env.baseUrl` with `secretKey` in headers.
- **Shops tab**: Shops are the first tab in the bottom navigation so the grocery list is the default view after splash.

## Documentation

- [Shops feature (Track A)](docs/shops-feature.md) – data flow, Cubit, UI, and API usage.
- [Configuration and env](docs/configuration-and-env.md) – env setup and run modes.
