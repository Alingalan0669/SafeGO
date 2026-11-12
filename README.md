<<<<<<< HEAD
# SafeGo — Run Guide

**Prepare. Pack. Evacuate.**

SafeGo is an offline-first disaster preparedness app for Philippine households, built with Flutter. This README explains how to run the system on every supported platform, how to reset the demo, and how to hand it to someone else.

> Demo data only. Evacuation centers and phone numbers are sample records. Confirm them with your barangay before an emergency.

---

## 1. Choose how you want to run it

| Platform | Works today? | Best for | Requirements |
| --- | --- | --- | --- |
| **Chrome / Edge (web)** | **Yes — recommended** | Fastest demo, panel presentation, screen sharing | Flutter + a browser |
| **Android phone** | Yes, after installing Android SDK | Real mobile demo and phone calls | Flutter + Android Studio / SDK + USB debugging |
| **Android emulator** | Yes, after installing Android SDK | Testing without a phone | Flutter + Android Studio + an AVD |
| **iPhone / iPad** | Yes, but only on macOS | iOS demo | macOS + Xcode |
| **Web release build** | **Yes — verified** | Sharing with others or hosting online | Flutter to build, any static file server to run |
| **Windows desktop** | Optional, host files not included | Desktop demo | Flutter + Visual Studio Build Tools |

**Fastest option on this machine:**

```powershell
cd "D:\Alphz Alingalan\SafeGO"
& "D:\sdk\flutter\bin\flutter.bat" pub get
& "D:\sdk\flutter\bin\flutter.bat" run -d chrome
```

---

## 2. One-time setup

### 2.1 Check Flutter

Flutter is installed here at `D:\sdk\flutter`, but it is **not on the PATH**. Use the full path:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" --version
```

Expected: Flutter stable `3.47.x` and Dart `3.13.x`.

To make `flutter` work everywhere, add it to PATH for the current terminal:

```powershell
$env:Path += ";D:\sdk\flutter\bin"
flutter --version
```

To make it permanent for your Windows user:

```powershell
[Environment]::SetEnvironmentVariable(
  "Path",
  [Environment]::GetEnvironmentVariable("Path", "User") + ";D:\sdk\flutter\bin",
  "User"
)
```

Close and reopen the terminal afterwards.

### 2.2 Install dependencies

Run this once after cloning or copying the project:

```powershell
cd "D:\Alphz Alingalan\SafeGO"
& "D:\sdk\flutter\bin\flutter.bat" pub get
```

SafeGo uses only these packages:

- `provider` — state management
- `go_router` — navigation
- `shared_preferences` — offline storage
- `url_launcher` — opens the phone dialer

### 2.3 Check devices

```powershell
& "D:\sdk\flutter\bin\flutter.bat" devices
```

On this machine, the available targets are currently **Windows, Chrome and Edge**. Android requires the Android SDK, which is not installed yet.

---

## 3. Run in Chrome (recommended)

```powershell
cd "D:\Alphz Alingalan\SafeGO"
& "D:\sdk\flutter\bin\flutter.bat" pub get
& "D:\sdk\flutter\bin\flutter.bat" run -d chrome
```

Chrome opens automatically with SafeGo.

Use Edge instead:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" run -d edge
```

While the app is running:

| Key | Action |
| --- | --- |
| `r` | Hot reload |
| `R` | Restart the app |
| `q` | Stop the app |

If port 8080 is busy:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" run -d chrome --web-port 8090
```

### Web limitations

- The system dialer is not available in a browser, so **Call** shows a friendly dialog with the phone number instead of placing a call.
- Data is stored in browser storage. Clearing site data resets the app.
- The app still works with no internet after it has loaded.

---

## 4. Run on Android

Android needs the Android SDK, an emulator or a physical phone, and USB debugging.

### 4.1 Install the Android toolchain

1. Install [Android Studio](https://developer.android.com/studio).
2. In Android Studio, install the **Android SDK**, **SDK Platform-Tools** and an **emulator image**.
3. Accept the licences:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" doctor --android-licenses
```

4. Confirm Flutter can see Android:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" doctor
```

`Android toolchain` must show a green check.

### 4.2 Use an emulator

List available emulators:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" emulators
```

Start one:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" emulators --launch <emulator_id>
```

Then run:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" run
```

### 4.3 Use a physical Android phone

1. On the phone, enable **Developer options**.
2. Enable **USB debugging**.
3. Connect the phone by USB and tap **Allow** on the debugging prompt.
4. Confirm the device is visible:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" devices
```

5. Run SafeGo:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" run -d <device_id>
```

### 4.4 Build an installable APK

```powershell
& "D:\sdk\flutter\bin\flutter.bat" build apk --release
```

The APK is created at:

```text
build\app\outputs\flutter-apk\app-release.apk
```

Install it with ADB:

```powershell
adb install -r build\app\outputs\flutter-apk\app-release.apk
```

Or copy the APK to the phone and open it (allow installation from unknown sources).

### Android calling

SafeGo opens the system dialer with a `tel:` link. The Android manifest already declares the required dialer query. The app does **not** request the `CALL_PHONE` permission, so the user still confirms each call.

---

## 5. Run on iPhone / iPad (macOS only)

iPhone builds cannot be produced on Windows. Use a Mac with Xcode:

1. Install Xcode from the App Store.
2. Install CocoaPods if needed:

```bash
sudo gem install cocoapods
```

3. Accept Xcode tools:

```bash
sudo xcode-select --install
sudo xcodebuild -license accept
```

4. Get dependencies and run:

```bash
cd /path/to/SafeGO
flutter pub get
open -a Simulator
flutter run
```

5. For a real iPhone, open `ios/Runner.xcworkspace` in Xcode, choose your Apple team under **Signing & Capabilities**, then run from Xcode or:

```bash
flutter run -d <iphone_device_id>
```

The iOS `Info.plist` already declares the `tel` scheme, so the call button works on a real iPhone.

---

## 6. Build and share the web version

This is the easiest way to let someone else use the system without installing Flutter.

### 6.1 Build

```powershell
cd "D:\Alphz Alingalan\SafeGO"
& "D:\sdk\flutter\bin\flutter.bat" build web --release
```

Output folder:

```text
build\web
```

### 6.2 Run it locally with Python

If Python is installed:

```powershell
python -m http.server 8000 --directory build\web
```

Open:

```text
http://localhost:8000
```

### 6.3 Run it locally with Node

```powershell
npx serve build\web
```

### 6.4 Deploy it for everyone

Upload the contents of `build\web` to any static host:

- GitHub Pages
- Netlify
- Vercel
- Firebase Hosting
- Any school or personal web server

For GitHub Pages, build with the repository base path:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" build web --release --base-href "/your-repo-name/"
```

No backend, database, account or API key is required. It is a static, offline-first app.

> Open `build\web\index.html` through a local server, not by double-clicking the file. Browsers block some features on `file://` URLs.

---

## 7. Optional: Windows desktop

The repository currently contains Android, iOS and web host folders. To add Windows desktop support:

```powershell
cd "D:\Alphz Alingalan\SafeGO"
& "D:\sdk\flutter\bin\flutter.bat" create --platforms=windows .
& "D:\sdk\flutter\bin\flutter.bat" run -d windows
```

This requires Visual Studio with the **Desktop development with C++** workload. Review generated files before committing them. Windows desktop is optional and was not part of the verified build.

---

## 8. Run from VS Code (any platform)

1. Install the **Flutter** and **Dart** extensions.
2. Open the `D:\Alphz Alingalan\SafeGO` folder.
3. Select a device in the bottom-right status bar (Chrome, Edge, Android, etc.).
4. Press `F5`, or run **Flutter: Launch Emulator** first if needed.

The included `.vscode` configuration is not required; the Flutter extension detects `lib/main.dart` automatically.

---

## 9. First-run walkthrough

The app starts with no saved household, so it guides you through setup:

1. **Splash** — waits briefly, then opens onboarding.
2. **Onboarding** — Prepare → Pack → Evacuate. Tap **Skip** or **Get started**.
3. **Household setup** — defaults are Maria, 5 people, children, flood. Change anything you need, then tap **Build my plan**.
4. **Home** — readiness score, demo hazard alert, next unfinished step and nearest evacuation center.
5. **Prepare** — tick the four preparedness steps; the readiness score updates.
6. **Pack** — the go-bag is generated from the household. With 5 people and children it contains 15 items.
7. **Evacuate** — demo centers, route preview, 911 card and one-tap contacts.
8. **Evacuate Now** — high-contrast emergency mode. Use **I'm safe** to reach the safe screen.
9. **Settings** — edit the household, enable larger text, preview offline/error/empty states, clear saved data.

### Suggested 3-minute demo for a panel

1. Show the readiness score on Home.
2. Tick two Prepare items and show the score change.
3. Open Pack and show that children added an item and the water amount scales with family size.
4. Open Evacuate → Evacuate Now → I'm safe.
5. Open Settings, turn on **Larger text**, and show the text preview.
6. Open **Offline mode** to show the offline-first message.

---

## 10. Reset the demo

SafeGo has no login. To start from onboarding again:

### In the app

**Settings → Clear saved data → Clear everything**

This removes the household, checklist ticks and preferences from the phone.

### Per platform

| Platform | Reset method |
| --- | --- |
| Chrome / Edge | DevTools → Application → Local Storage → delete the SafeGo site data, or use Settings → Clear saved data |
| Android | Settings → Apps → SafeGo → Storage → Clear data, or uninstall the app |
| iPhone | Delete and reinstall, or use Settings → Clear saved data |
| Web deployment | Clear the site data in the browser |

`flutter clean` removes build output, **not** app data.

---

## 11. Verify the project

Run these from the project folder:

```powershell
& "D:\sdk\flutter\bin\flutter.bat" analyze
& "D:\sdk\flutter\bin\flutter.bat" test
& "D:\sdk\flutter\bin\flutter.bat" build web --release
```

Verified on this machine:

| Check | Result |
| --- | --- |
| `flutter analyze` | No issues found |
| `flutter test` | 25 tests passed |
| `flutter build web --release` | Built successfully |

The tests cover:

- helpers and phone-number sanitising
- checklist generation (14 base items, 15 with children, 19 with all needs)
- readiness calculation and tick persistence
- household JSON fallback for corrupt data
- first-run flow through onboarding → setup → Home → Prepare → Pack
- layout smoke tests for every non-flow screen at 390×844 and 115% text

---

## 12. Troubleshooting

| Problem | Fix |
| --- | --- |
| `flutter` is not recognized | Use `& "D:\sdk\flutter\bin\flutter.bat"`, or add `D:\sdk\flutter\bin` to PATH |
| `No devices found` | Run `flutter devices`; start an emulator or connect a phone with USB debugging |
| Android toolchain not found | Install Android Studio + SDK, then `flutter doctor --android-licenses` |
| Android build/Gradle error | Install a compatible JDK through Android Studio, then `flutter clean` and retry |
| Chrome does not open | Run `flutter config --enable-web`, update Chrome, then `flutter devices` |
| Blank page in the browser | Serve `build\web` over HTTP; do not open `index.html` directly |
| Port already in use | Add `--web-port 8090` to `flutter run` |
| Call button shows a dialog | Expected on web/emulator/desktop; a real phone with a dialer opens the dialer |
| Data disappears after restart | Check that browser storage / app storage is not being cleared automatically |
| App opens on Home instead of onboarding | That means a profile is already saved. Use Settings → Clear saved data |
| Layout looks crowded | Settings → Larger text is a preview; try a 390×844 phone viewport |
| Fonts look different | The bundled Inter files are in `assets/fonts`; run `flutter pub get` after cloning |

---

## 13. What is offline and what is demo data

SafeGo is offline-first:

- **Saved locally:** household profile, checklist ticks, language and text-size preferences.
- **Bundled:** evacuation centers, contacts and the route illustration.
- **No network calls:** no weather API, no live alerts, no account, no analytics.
- **Demo data:** center names, addresses, distances and phone numbers are fictional.
- **No API keys or secrets** are stored anywhere in this repository.

The **Evacuate** screen and the Home advisory are demonstrations of the flow, not live emergency information.

---

## 14. Project structure

```text
lib/
  core/           theme tokens, constants, routes, helpers
  models/         household, checklist item, contact, center
  providers/      household, checklist, settings, evacuation state
  services/       SharedPreferences, bundled JSON, tel: launcher
  router/         GoRouter and the four-tab shell
  screens/        Splash, onboarding, setup, Home, Prepare, Pack,
                  Evacuate, Evacuate Now, Safe, Settings, previews
  widgets/        reusable buttons, cards, checklist rows, nav, map preview
assets/
  data/           evacuation_data.json
  fonts/          bundled Inter 400/500/600/700
test/             unit, provider, flow and layout smoke tests
android/          Android host
ios/              iOS host (build on macOS)
web/              Web host
```

### Readiness formula

```text
readiness = (completed Prepare steps + packed go-bag items)
            / (4 Prepare steps + current go-bag item count)
```

### Go-bag personalisation

| Household need | Items added |
| --- | --- |
| Base | 14 |
| Children | +1 |
| Seniors | +1 |
| Disability support | +1 |
| Pets | +2 |

Water quantity scales with the number of family members. Ticks are keyed by item ID and survive household edits.

---

## 15. Figma frame map

Figma file: `cshN70xVVLgJAGARdjPA20` — page `Page 1` (`0:1`)

| Frame | Node | Screen |
| --- | --- | --- |
| 00 Splash | `2:249` | `SplashScreen` |
| 01 Onboarding • Prepare | `2:252` | `OnboardingScreen` page 1 |
| 02 Onboarding • Pack | `2:255` | `OnboardingScreen` page 2 |
| 03 Onboarding • Evacuate | `2:258` | `OnboardingScreen` page 3 |
| 04 Household setup | `2:261` | `HouseholdSetupScreen` |
| 05 Home | `2:264` | `HomeScreen` |
| 06 Prepare | `2:267` | `PrepareScreen` |
| 07 Pack | `2:270` | `PackScreen` |
| 08 Evacuation plan | `2:273` | `EvacuateScreen` |
| 09 Evacuate now | `2:276` | `EvacuateNowScreen` |
| 10 You are safe | `2:279` | `SafeScreen` |
| 11 Empty state | `2:282` | `EmptyStateScreen` + Pack empty state |
| 12 Error state | `2:285` | `ErrorScreen` |
| 13 Offline state | `2:288` | `OfflineScreen` |
| 14 Profile & settings | `2:291` | `SettingsScreen` |
| 15 Large text preview | `2:294` | `TextPreviewScreen` |
| 16 Demo call • Ana | `2:967` | One-tap call flow in `EvacuateScreen` |
| 20 Filipino language preview | `2:1390` | Language preference in Settings |
| Design system | `2:28` | `lib/core/theme/app_theme.dart` |

---

## 16. Known scope notes

- **English UI:** Filipino is stored as a preference, but translated copy is deferred to a later update. The app states this honestly in Settings.
- **No live alerts:** Home shows a demo hazard advisory based on the selected hazard.
- **Route preview is illustrative:** it is drawn locally with a `CustomPainter`, not a real map.
- **Calling uses the system dialer:** no direct-call permission is requested.
- **No accounts or cloud sync:** everything stays on the device.
- **Visual fidelity:** the app was implemented from the Figma design context and tokens. Compare it against the frames on a 390×844 phone for final sign-off.

---

## 17. Quick command reference

```powershell
# Project folder
cd "D:\Alphz Alingalan\SafeGO"

# One-time setup
& "D:\sdk\flutter\bin\flutter.bat" pub get

# Chrome / Edge
& "D:\sdk\flutter\bin\flutter.bat" run -d chrome
& "D:\sdk\flutter\bin\flutter.bat" run -d edge

# Android emulator/device
& "D:\sdk\flutter\bin\flutter.bat" emulators
& "D:\sdk\flutter\bin\flutter.bat" run

# Release APK
& "D:\sdk\flutter\bin\flutter.bat" build apk --release

# Web build and local server
& "D:\sdk\flutter\bin\flutter.bat" build web --release
python -m http.server 8000 --directory build\web

# Checks
& "D:\sdk\flutter\bin\flutter.bat" analyze
& "D:\sdk\flutter\bin\flutter.bat" test
```

For the safest live demo, use **Chrome or Edge**. For a mobile demo with working phone calls, use an **Android phone** with the SDK installed.
=======
# SafeGO
>>>>>>> d72e8bbab305467c778330d145c36d73db609c3d
