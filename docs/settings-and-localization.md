# Settings and Localization

## Settings Screen

- **Location**: Second or third tab in bottom nav (Shops, Favorites, Settings).
- **Content**: Avatar (gradient circle with store icon), language button, app name (“Grocery Stores App”), app version (“1.0.0”).
- **Language button**: Tap calls `LanguageCubit.changeLanguage(currentLangAr() ? 'en' : 'ar')` to toggle locale. Implemented in `SettingsLanguageButton` with scale-on-tap animation.
- **Widgets**: `SettingsAvatarSection`, `SettingsLanguageButton`, `SettingsAnimatedSection` (staggered fade/slide) under `lib/features/settings/presentation/widgets/`.

## Localization

- **Mechanism**: `AppLocalizations` loaded from `assets/lang/{locale}.json` (en, ar). Extension `context.tr('key')` for translated strings.
- **Locale source**: `LanguageCubit`; state is `ChangeLanguageState(locale)` or initial. Locale can be persisted (e.g. via secure storage) via `getSavedLanguage()` on startup.
- **Usage**: All user-visible strings use `context.tr('key')`. For model fields that have both English and Arabic (e.g. shop name, description), use `currentLangAr()` from `app_localizations.dart` to pick the correct property.

## Translation Files

- **assets/lang/en.json** – English keys and values.
- **assets/lang/ar.json** – Arabic keys and values.

Keys cover: common (loading, error, retry), auth, shops (grocery_stores, search, sort, filter, open, closed, eta, min_order, location, description, shop_details, back), favorites (favourites, no_favourites_yet, remove), settings (settings, change_language, app_name, version), connectivity (offline, online), etc.

## RTL

- Flutter’s locale (e.g. `ar`) drives text direction and layout when the app supports RTL for Arabic.
