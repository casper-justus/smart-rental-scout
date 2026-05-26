# TenantMatch — AGENTS.md

## What this is

A Flutter rental-matching app. The root also contains an old HTML prototype (`app.js` + HTML files) that is not the real app — ignore it.

## Key structure

```
tenantmatch_app/
├── lib/
│   ├── main.dart              # Entrypoint & global singletons
│   ├── app.dart               # MaterialApp with onGenerateRoute routing
│   ├── models/property.dart   # PropertyListing model + static sample data
│   ├── screens/               # One file per screen
│   ├── widgets/               # Reusable widgets (PropertyCard, AppBottomNav, FilterBottomSheet, etc.)
│   ├── services/              # Global services (Favorites, FormData, Commute, Theme)
│   └── theme/app_theme.dart   # AppTheme colors/spacing + AppTextStyle
```

## Build & test

- Flutter SDK is at `/opt/flutter/bin/flutter` on the CI codespace (not in PATH).
- Dart SDK constraint: `>=3.0.0 <4.0.0`.
- APK build: `flutter build apk --debug`
- APK output: `build/app/outputs/flutter-apk/app-debug.apk`
- APK build codespace: `smart-rental-scout-apk-build-*`

## Global singletons (main.dart)

```dart
final favoritesService = FavoritesService();    // toggle, isFavorite, add, remove
final formDataService = FormDataService();     // getData, save, saveField
final commuteService = CommuteService.instance; // singleton, calculateCommuteTimes
```

All are accessed directly from `main.dart` — import `../main.dart` to use them.

## Routing

All routes via `onGenerateRoute` in `app.dart`. Key paths:
- `/home` → HomeScreen
- `/search` → MapSearchScreen
- `/listing-details` → ListingDetailsScreen(propertyId: args)
- `/saved` → SavedSearchesScreen
- `/profile` → UserProfileScreen
- `/compare` → ComparePropertiesScreen
- `/commute-hub` → CommuteHubSettingsScreen
- `/virtual-tour` → VirtualTourScreen
- `/app-step1` through `/app-step4` → application flow
- `/submission-success` → SubmissionSuccessScreen

Default transition: `AppRouteTransitions.slideInFromRight`.

## Theme

- Light/dark/system theme controlled by `ThemeService.modeNotifier` (ValueNotifier).
- Wrapped in `ListenableBuilder` in `app.dart`.
- Colors and text styles defined in `app_theme.dart` as static consts.
- Use `AppTheme.containerMargin`, `AppTheme.gutter`, `AppTheme.spacingMd` etc. for layout.
- Use `AppTextStyle.*` for text, never raw text styles.

## Key dependencies

- `flutter_map` + `latlong2` for maps
- `geolocator` for GPS
- `cached_network_image` for image caching (use `CachedNetworkImage` not `Image.network`)
- `shared_preferences` for persistence

## Performance conventions

- Always use `CachedNetworkImage` with `memCacheWidth`/`memCacheHeight` (never bare `Image.network`).
- Wrap expensive subtrees (map, bottom sheets, image sections) in `RepaintBoundary`.
- Extract large widget subtrees into separate widget classes (`_ZoomControls`, `_PropertyListSheet`, etc.) for rebuild isolation.
- Pre-allocate shadow/color constants as `const Color` / `const List<BoxShadow>` — avoid `withOpacity` in build methods.
- Use `const` constructors wherever possible.
- Map has `resizeToAvoidBottomInset: false` to keep bottom nav in place when keyboard opens.
- PropertyCard uses `compact: true` to hide details when used in horizontal scroll strips.

## Convictions

- `FilterOptions` is a mutable model in `widgets/filter_bottom_sheet.dart` with `copyWith`.
- `showToast(context, message)` in `widgets/toast.dart`.
- `showAppAlert(context, title, message)` in `widgets/app_dialog.dart`.
- Sample data is in `PropertyListing.sampleProperties` (static const list).
- Back-press-to-exit is handled in HomeScreen (2-second double-press).
