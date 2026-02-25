# Configuration and Environment

## Environment Variables

The app uses [envied](https://pub.dev/packages/envied) for compile-time env. Values are read from:

- **Development**: `env/.env.dev`
- **Production**: `env/.env.prod`

Required variables:

| Variable     | Description                          | Example |
|-------------|--------------------------------------|---------|
| `BASE_URL`  | Full URL of the shops list API       | `https://api.orianosy.com/shop/test/find/all/shop` |
| `SECRET_KEY`| Secret key sent in API request header | `PostInterview022026` |

## How Env Is Loaded

1. `main()` calls `initEnv()` (from `lib/core/env/init_env.dart`).
2. `initEnv()` sets the global `env` based on `--dart-define=ENV=dev|prod` (default: `dev`).
3. `initServiceLocator()` registers `Env` in GetIt as `env` for injection (e.g. `ShopRemoteDataSource`).

## Regenerating Env Code

After editing `env/.env.dev` or `env/.env.prod`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Generated files:

- `lib/core/env/env.dev.g.dart`
- `lib/core/env/env.prod.g.dart`

Do not edit these by hand.

## Run Modes

- **Dev** (default): `flutter run` or `flutter run --dart-define=ENV=dev` → uses `DevEnv` and `env/.env.dev`.
- **Prod**: `flutter run --dart-define=ENV=prod` → uses `ProdEnv` and `env/.env.prod`.

## Shops API Usage

The shops feature uses:

- **URL**: `env.baseUrl` (full request URL).
- **Header**: `secretKey: env.secretKey`.

No other code changes are needed when switching dev/prod as long as the corresponding `.env.*` files are set correctly and code generation has been run.
