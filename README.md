# SafeGo — Prepare. Pack. Evacuate.

SafeGo is an offline-first family disaster-preparedness MVP built with **Expo (SDK 58), React Native and TypeScript**. It turns a short household setup into a personalised emergency plan, a go-bag checklist, local evacuation information and a high-contrast "Evacuate Now" flow.

**Sustainable Development Goal:** SDG 13 — Climate Action. SafeGo helps households prepare for floods, typhoons and earthquakes, and supports timely, safer evacuation decisions.

> The bundled evacuation centers and phone numbers are **demo data only**. Confirm centers and hotlines with your barangay before an emergency.

## Figma fidelity

Design source: [SafeGo Figma file](https://www.figma.com/design/cshN70xVVLgJAGARdjPA20/Untitled?node-id=0-1&t=QCfS7ojSUbOqVhTk-1)

All tokens live in `src/theme/tokens.ts` (single re-export: `src/theme/index.ts`). Screens import tokens rather than raw colours. The 8pt grid, Inter type scale (H1 28/36, H2 22/28, subtitle 18/24, body 16/24, caption 14/20), radii (6/8/12/16), 48px minimum touch targets and Figma component sizes (56px button, 86px checklist tile, 8px progress bar, 64px top bar, 80px bottom nav) are preserved.

| Figma frame | Node | App route |
| --- | --- | --- |
| Splash | `2:249` | `/splash` |
| Onboarding 1–3 | `2:252`, `2:255`, `2:258` | `/onboarding` |
| Household setup | `2:261` | `/household-setup` |
| Home | `2:264` | `/(tabs)` |
| Prepare | `2:267` | `/(tabs)/prepare` |
| Pack | `2:270`, interactive `2:1682` | `/(tabs)/pack` |
| Evacuation plan | `2:273` | `/(tabs)/evacuate` |
| Evacuate now | `2:276` | `/evacuate-now` |
| Safe | `2:279` | `/safe` |
| Empty | `2:282` | `/empty` |
| Error | `2:285` | `/error` |
| Offline | `2:288` | `/offline` |
| Settings | `2:291` | `/settings` |
| Large text preview | `2:294` | `/large-text` |
| Demo call | `2:967` | `/demo-call` |
| Filipino preview | `2:1390` | `/filipino` |
| Design system | `2:28` | `src/theme/tokens.ts` |

The Figma Starter MCP tool call limit was reached before decorative safety-mark and route-preview vector URLs were captured; those two illustrations are approximated with token-based components. All functional icons were downloaded from Figma and recreated as `react-native-svg` paths in `src/components/Icon.tsx`.

## MVP features

- Household setup (members, children, seniors, disability, pets, main hazard).
- Readiness score derived from completed Prepare + Pack items.
- Personalised Pack checklist: base items plus extras for children, seniors, disability, pets and a paper contact list.
- Prepare checklist and progress bars; tick state persists offline in AsyncStorage.
- Evacuate tab with mock centers, addresses, distances and one-tap `tel:` contacts.
- Large, high-contrast Evacuate Now screen with numbered steps, offline badge and 911 dial action.
- Safe confirmation, empty/error/offline states, Settings with English/Filipino and standard/large text.
- No custom native modules, no API keys, no accounts and no network requests.

## Project structure

```text
app/                 expo-router routes (thin wrappers)
src/screens/         screen implementations
src/components/      reusable themed UI
src/theme/           Figma tokens
src/store/           AppContext (AsyncStorage-backed state)
src/services/        checklist, storage, phone and offline helpers
src/data/            translations, default checklists and evacuation demo data
src/types/           shared models
assets/icons/        Figma SVG sources
assets/fonts/        Inter
```

## Install and run

Requirements: Node.js 20+, npm and the **Expo Go** app from the iOS App Store or Google Play. Expo Go must be on a store version that supports SDK 58.

```bash
npm install
npx expo install --check
npm start
```

1. Open Expo Go on your phone.
2. Android: scan the QR code from the terminal (or from `http://localhost:8081`) in the Expo Go app.
3. iPhone: scan the QR code with the Camera app, then open the link in Expo Go.
4. Keep the computer and phone on the same Wi-Fi for LAN mode.

If your network blocks peer-to-peer LAN traffic, use tunnel mode:

```bash
npm run start:tunnel
```

Then scan the new QR code in Expo Go. Press `r` in the terminal to reload if needed.

TypeScript check:

```bash
npm run typecheck
```

Expo Go cannot open builds that use custom native modules; this project intentionally uses only Expo Go–safe libraries. A dialer is required for `tel:` links, so the call buttons should be tested on a physical phone.

## Build an APK with EAS

EAS builds are optional; Expo Go is the primary MVP target.

```bash
npm install -g eas-cli
eas login
eas build configure --platform android   # only if eas.json is missing
eas build -p android --profile apk
```

Download the signed APK from the link printed by EAS, or install it with `eas build:download --platform android`. The `apk` profile in `eas.json` uses `buildType: "apk"` so the result can be sideloaded directly.

## Team placeholders

- **Product owner / UX researcher:** _Add name_
- **UI designer (Figma source):** _Add name_
- **Frontend lead (Expo migration):** _Add name_
- **QA / device testing:** _Add name_

Replace these placeholders before submission.

## Migration note

The original Flutter implementation was kept until the Expo app was verified running, then removed. Removed: `lib/`, `test/`, `android/`, `ios/`, `web/`, `build/`, `.dart_tool/`, `assets/data/evacuation_data.json` (ported to `src/data/evacuation.json`), `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml` and Flutter-generated config files. The checklist rules, demo data and design copy were ported to the Expo app before removal.

See `AI_DISCLOSURE_LOG.md` for the AI assistance summary.

STEP 4 — Verification & finish
- npx tsc --noEmit → OK
- npx expo install --check → up to date
- npx expo export --platform android → bundled successfully (1,316 modules, fonts and assets included)
- npx expo start --clear on port 8081 → clean startup, and the dev bundle returned HTTP 200 (~4.65 MB)
- Verification server was stopped; port 8081 is free for normal use.
To run: npm install → npm start → scan the QR in Expo Go (or npm run start:tunnel if LAN is blocked). No API keys, tokens, or secrets were added.
Short summary for AI_DISCLOSURE_LOG.md
Continued the interrupted SafeGo Expo migration: audited all existing files, confirmed TypeScript and dependencies were clean, fixed onboarding Skip navigation and offline-status handling, removed the remaining Flutter/Android/iOS/web/test sources only after Expo was verified running, and confirmed npx expo start and a full Metro export work. No new secrets or native modules were introduced.