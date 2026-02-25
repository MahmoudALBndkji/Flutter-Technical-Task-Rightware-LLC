# Product and Technical Specification

## Product Overview

**Grocery Stores App** is a Flutter mobile application that lets users browse a list of grocery stores (shops), view details, and manage a favorites list. The app supports English and Arabic, works offline with cached data, and shows connectivity status.

---

## Functional Requirements

### Shops List (Track A)

| Requirement | Implementation |
|-------------|----------------|
| Display list of grocery stores | Shops from remote API; card shows cover, name, description, ETA, min order, location, Open/Closed badge. |
| Debounced search by name/description | ~400 ms debounce; search in en/ar name and description. |
| Sort by ETA (ascending) | Sort option “ETA (asc)”. |
| Sort by minimum order (ascending) | Sort option “Min order (asc)”. |
| Filter: Open only | Checkbox “Open only”; filter by `availability == true`. |
| Clear filters | Button clears search, sort, and open-only. |
| No results state | When filters/search return empty list but raw list is not empty. |
| Loading / error / empty states | Loading indicator; error with retry; empty list message. |

### Shop Details

| Requirement | Implementation |
|-------------|----------------|
| Navigate from list item to details | Tap on shop card → push route with `ShopModel` as `extra`. |
| Details: cover, name, description, ETA, min order, location | Dedicated screen with sections; name/description use `currentLangAr()`. |
| Favorite from details | Heart icon in app bar toggles favorite. |

### Favorites

| Requirement | Implementation |
|-------------|----------------|
| Add/remove favorite from list and details | Heart on card and details app bar; FavoritesCubit add/remove/toggle. |
| Favorites list screen | Tab in bottom nav; list of favorite shops; tap → details; remove by swipe or heart. |
| Persist favorites across restarts | HydratedCubit; state serialized to JSON. |

### Settings and Localization

| Requirement | Implementation |
|-------------|----------------|
| Settings screen | Avatar, language button, app name, version. |
| Switch language (EN/AR) | Language button toggles locale via LanguageCubit. |
| All UI strings translatable | `context.tr('key')`; keys in `en.json` and `ar.json`. |
| Localized model fields | `currentLangAr()` to choose en vs ar for name, description, etc. |

### Connectivity and Offline

| Requirement | Implementation |
|-------------|----------------|
| Show when offline | Root snackbar (grey, offline icon) on connectivity change. |
| Show when back online | Root snackbar (green, wifi icon) on connectivity change. |
| Don’t lose data on restart | Shops and favorites state persisted with HydratedBloc. |
| Refresh shops when online | Pull-to-refresh on list; calls API only if online. |

---

## Data Models

### Shop (API / App)

- **id** (e.g. `_id`)
- **shopName** – LocalizedText (en, ar)
- **description** – LocalizedText (en, ar)
- **minimumOrder** – amount (num), currency
- **address** – street, city, state, country, otherDetails
- **estimatedDeliveryTime** – string (e.g. “30 minutes”)
- **coverPhoto**, **profilePhoto** – URLs
- **availability** – bool (open/closed)
- **categoryType**, **ownerFullName**, **enable**, **badgeTag**

Derived: `location` (formatted from address), `isOpen` (from availability), `estimatedDeliveryTimeDisplay`, `minimumOrderAmount`, etc.

### Favorites

- Stored as `List<ShopModel>` in FavoritesState; full shop model so details screen can show without a second fetch.

---

## API

### Shops List

- **Method**: GET
- **URL**: From env `BASE_URL` (full URL).
- **Headers**: `secretKey: SECRET_KEY` from env.
- **Response**: JSON array of shop objects (or object containing such an array); keys may be camelCase/snake_case (normalized in data source).

---

## Non-Functional Requirements

- **State management**: Cubit (flutter_bloc); HydratedCubit for shops and favorites.
- **DI**: GetIt; env and data layer registered before cubits.
- **Routing**: go_router; paths centralized in `AppPaths`.
- **Images**: Cached network images with logo placeholder and error fallback; optional memory limits (memCacheWidth/Height).
- **Separation of concerns**: Features with data + presentation; reusable widgets under `presentation/widgets/`.

---

## Out of Scope (Assumptions)

- No user authentication for this specification.
- Shops API is read-only (no create/update/delete).
- Connectivity is device-level (connectivity_plus); no explicit “API reachable” check.
- Favorites and shops cache are not encrypted.
