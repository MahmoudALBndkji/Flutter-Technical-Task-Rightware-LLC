# Security

## Overview

The app includes a **device security layer** that blocks usage on rooted/jailbroken devices, when developer mode is enabled (Android), or when running on an emulator/simulator. When a threat is detected, the user is shown a **restricted screen** and the app exits after a short countdown. Security checks run at app entry and periodically while the app is in use.

## Components

### 1. SecurityService (`lib/core/services/security_service.dart`)

**Role**: Runs all security checks and returns a result; provides localized threat messages for the UI.

- **Singleton**: Single instance via factory constructor.
- **Dependencies**: Uses `root_checker_plus` (root/jailbreak, developer mode) and `device_info_plus` (physical device vs emulator/simulator).

**SecurityThreat enum**:

| Threat | Platform | Description |
|--------|----------|-------------|
| `rootDetected` | Android | Device is rooted (RootCheckerPlus). |
| `jailbreakDetected` | iOS | Device is jailbroken (RootCheckerPlus). |
| `developerModeEnabled` | Android | Developer options are enabled (RootCheckerPlus). |
| `debugModeEnabled` | — | Debug build (check is present but commented out so dev builds can run). |
| `emulatorDetected` | Android / iOS | App is running on an emulator (Android) or simulator (iOS) instead of a physical device. |

**API**:

- **`performSecurityCheck(BuildContext context)`**  
  Runs checks in order; returns `SecurityCheckResult(isSecure, threat, message)`.
  - **Android**: Root → developer mode → emulator (via `DeviceInfoPlugin.androidInfo.isPhysicalDevice`).
  - **iOS**: Jailbreak → simulator (via `DeviceInfoPlugin.iosInfo.isPhysicalDevice`).
  - On any exception, returns **secure** to avoid blocking the app due to check failures.
- **`getThreatMessage(BuildContext context, SecurityThreat threat)`**  
  Returns the localized message for the given threat (used by RestrictedScreen). Falls back to English if `context.tr(key)` fails.
- **`isSecure`** / **`currentThreat`**  
  Last result of the security check (internal state).

**Localization keys** (used in SecurityService and RestrictedScreen):

- `security_alert`, `app_will_close_in`, `seconds`
- `security_rooted_message`, `security_jailbroken_message`, `security_developer_mode_message`, `security_debug_mode_message`, `security_emulator_message`
- Optional / future: `rooted_device_detected`, `jailbroken_device_detected`, `developer_mode_enabled`, `emulator_detected`, `simulator_detected`, `device_is_secure`, `security_check_completed`

### 2. SecurityWrapper (`lib/core/security/security_wrapper.dart`)

**Role**: Wraps each protected screen; runs a security check before showing content and periodically while the screen is active.

- **Child**: The actual screen widget (e.g. SplashScreen, HomeLayout, ShopDetailsScreen).
- **On init**:
  1. Calls **`_checkSecurity()`** (async).
  2. Starts **`_startPeriodicCheck()`**: after 2 minutes, runs `_checkSecurity()` again and reschedules (every 2 minutes).
- **`_checkSecurity()`**:
  1. Calls `SecurityService().performSecurityCheck(context)`.
  2. If **not secure** and `result.threat != null`:
     - If current route is **not** already `AppPaths.restricted`, navigates with **`context.go('${AppPaths.restricted}?threat=${result.threat!.name}')`**.
  3. Updates local state (`_isChecking = false`, `_isSecure = result.isSecure`).
- **Build**:
  - While **checking**: shows full-screen `LogoAnimationLoading`.
  - If **not secure**: returns `SizedBox.shrink()` (restricted screen is shown via navigation).
  - Otherwise: returns `widget.child`.

**Usage in router**: Splash, home, and shop-details routes wrap their content in `SecurityWrapper(child: ...)`. The restricted route is **not** wrapped so the user always sees the restricted screen when redirected there.

### 3. RestrictedScreen (`lib/core/security/restricted_screen.dart`)

**Role**: Full-screen block when a security threat is detected. Informs the user and then closes the app.

- **Input**: `SecurityThreat threat` (passed from the route query parameter `threat`).
- **Behavior**:
  - Shows a **security alert** title and a **threat-specific message** (from `SecurityService().getThreatMessage(context, threat)`).
  - Shows a **threat-specific icon** (e.g. `Icons.security` for root/jailbreak, `Icons.developer_mode` for developer mode, `Icons.bug_report` for debug, `Icons.phone_android` for emulator).
  - **20-second countdown** with a visible timer and progress indicator.
  - After countdown: calls **`exit(0)`** on Android and iOS to terminate the process.
- **UI**: Gradient background (secondary color), fade/scale/pulse animations, localized strings (`context.tr('security_alert')`, `context.tr('app_will_close_in')`, `context.tr('seconds')`).

## Routing

- **Path**: `AppPaths.restricted` = `/restricted`.
- **Query**: `threat` = enum name (e.g. `rootDetected`, `emulatorDetected`). If missing or invalid, defaults to `SecurityThreat.developerModeEnabled`.
- **Builder**: Parses `state.uri.queryParameters['threat']`, maps to `SecurityThreat`, and builds `RestrictedScreen(threat: threat)`.

Protected routes (splash, home, shop details) are wrapped with `SecurityWrapper`; the restricted route is standalone so no security check runs on the restricted screen itself.

## Flow Summary

1. User opens app → navigates to splash (or home). Route builder returns `SecurityWrapper(child: SplashScreen())`.
2. SecurityWrapper runs `performSecurityCheck()`. While running, user sees loading.
3. If **secure**: SecurityWrapper shows child (e.g. SplashScreen). Every 2 minutes, SecurityWrapper runs the check again; if a threat appears, it does `context.go('/restricted?threat=...')`.
4. If **not secure**: SecurityWrapper navigates to `/restricted?threat=...`. RestrictedScreen shows the alert and countdown, then `exit(0)`.
5. Restricted route has no SecurityWrapper, so the user cannot “go back” into the app from that screen.

## File Layout

- `lib/core/services/security_service.dart` – SecurityService, SecurityThreat, SecurityCheckResult.
- `lib/core/security/security_wrapper.dart` – SecurityWrapper widget.
- `lib/core/security/restricted_screen.dart` – RestrictedScreen widget.
- `lib/core/routing/app_paths.dart` – `restricted` path.
- `lib/core/routing/app_router.dart` – Restricted route and SecurityWrapper on splash, home, shop-details.

## Configuration and Customization

- **Debug mode**: The check for `debugModeEnabled` is commented out so the app can run in debug during development. To block debug builds, uncomment that block in `SecurityService.performSecurityCheck()`.
- **Emulator**: If you need to allow emulators (e.g. for QA), you can skip or relax the emulator check in `SecurityService` (e.g. only enforce in release).
- **Periodic check interval**: Currently 2 minutes in `SecurityWrapper._startPeriodicCheck()` (`Duration(minutes: 2)`). Can be changed for more or less frequent checks.
- **Countdown duration**: 20 seconds in `RestrictedScreen` (`_countdown = 20` and timer). Can be adjusted or replaced with an “Exit” button only.

## Error Handling

- If any security check throws (e.g. plugin failure), `SecurityService.performSecurityCheck()` catches and returns **secure** so the app is not blocked by false positives.
- Developer mode and emulator checks use try/catch and log with `debugPrint`; on error they do not set a threat and execution continues to the next check or to “all passed”.
