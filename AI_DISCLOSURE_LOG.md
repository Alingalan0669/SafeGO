# AI Disclosure Log — SafeGo MVP

## Summary

SafeGo was built and migrated with AI assistance. The Figma file was read first and every frame was mapped to an app route. The original Flutter MVP was then ported to Expo Go / React Native + TypeScript. Implementation, token extraction, copy adaptation, tests and documentation were generated with an AI coding agent and verified locally with `tsc --noEmit`, `npx expo install --check` and an Expo dev-server startup check.

## AI-assisted work (Flutter MVP)

- Extracted colours, spacing, radii and the Inter type scale from the Figma design-system frame into the Flutter theme.
- Created the Flutter project structure (models, providers, services, router, screens, widgets).
- Implemented offline persistence and bundled mock evacuation data.
- Implemented personalised go-bag rules, readiness calculation and checklist persistence.
- Built onboarding, household setup, Home, Prepare, Pack, Evacuate, emergency mode, safe, settings, large-text, offline, error and empty screens.
- Added unit tests, an app-flow widget test and a 115% text layout smoke test.

## AI-assisted work (Expo migration)

- Scaffolded Expo SDK 58 with expo-router and installed Expo Go–safe dependencies via `npx expo install`.
- Ported every design token to `src/theme/tokens.ts`; screens use tokens and the themed text component for the Large text setting.
- Rebuilt all Figma frames as expo-router screens with tab + stack navigation.
- Ported the Flutter checklist factory, readiness formula, demo evacuation data and AsyncStorage behaviour.
- Downloaded Figma SVG icons and recreated them with `react-native-svg` so no temporary URLs or hardcoded colours remain.
- Added full Filipino translations for the language setting, plus the requested preview screens and demo-call flow.
- Rewrote README with install, Expo Go/LAN/tunnel instructions, SDG 13, team placeholders and EAS APK steps; added `eas.json`.
- Removed the Flutter sources and host folders only after the Expo app started successfully.

## Continuation after interrupted session

- Re-checked the workspace (`git status`, folder tree, file sizes) for half-written files; none were found and `npx tsc --noEmit` passed.
- Verified Expo dependencies with `npx expo install --check` and confirmed a full Android Metro bundle exports successfully (`npx expo export --platform android`).
- Cleared stale Metro caches and orphaned Expo dev-server processes, then confirmed `npx expo start --clear` runs cleanly on port 8081 and serves the bundle (HTTP 200).
- Removed the remaining Flutter sources and host folders only after the Expo app was verified running: `.dart_tool/`, `android/`, `build/`, `ios/`, `lib/`, `test/`, `web/`, `.flutter-plugins-dependencies`, `.metadata`, `analysis_options.yaml`, `pubspec.yaml`, `pubspec.lock`, `assets/data/evacuation_data.json`, plus the temporary `dist/` export output.
- Fixed two small logic issues found during the final audit: onboarding **Skip** now opens household setup instead of looping back to splash, and the offline badge only appears when connectivity is known to be unavailable.

## Human review checklist

- Confirm evacuation centers, contact names and phone numbers are clearly labelled demo data (they are fictional).
- Confirm the readiness formula and personalisation counts match the intended grading criteria.
- Test the `tel:` flow on a physical device; emulators and web may not have a dialer.
- Verify visual fidelity against Figma on a 390×844 device. The AI could not view Figma screenshots, so layout was implemented from design-context metadata and tokens; two decorative vectors are approximations.
- Confirm Expo Go on the target phones supports SDK 58 before distribution.

## Safety and secrets

- No API keys, tokens, passwords or private endpoints are present in the repository.
- The app makes no network requests in this MVP and requires no account.
- Phone calling opens the system dialer and never requests direct-call permissions.
- `node_modules`, build output and local env files are excluded by `.gitignore`.
