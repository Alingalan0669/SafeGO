# AI Disclosure Log — SafeGo MVP

## Summary

SafeGo was built with AI assistance from the supplied Figma design. The Figma file was read first; all top-level frames and node IDs are recorded in `README.md`. The implementation, design-token extraction, copy adaptation, tests and documentation were generated with an AI coding agent, then verified locally with `flutter analyze` (zero issues), `flutter test` (25 passing tests) and `flutter build web --release`.

## AI-assisted work

- Extracted colours, spacing, radii and the Inter type scale from the Figma design-system frame into `lib/core/theme/app_theme.dart`.
- Created the Flutter project structure (models, providers, services, router, screens, widgets).
- Implemented offline persistence with `shared_preferences` and bundled mock evacuation data in `assets/data/evacuation_data.json`.
- Implemented the personalised go-bag rules, readiness calculation and checklist persistence.
- Built the onboarding, household setup, Home, Prepare, Pack, Evacuate, emergency mode, safe, settings, large-text, offline, error and empty screens.
- Added unit tests, an app-flow widget test and a 115% text layout smoke test.

## Human review checklist

- Confirm the evacuation centers, contact names and phone numbers are clearly labelled demo data (they are fictional).
- Confirm the readiness formula and personalisation counts match the intended grading criteria.
- Test the `tel:` flow on a physical device; emulators and web may not have a dialer.
- Review the Filipino language decision: the preference is stored, but translated copy is deferred and disclosed in Settings.
- Verify visual fidelity against the Figma file on a 390×844 device; the AI did not have image viewing for the Figma screenshots, so layout was implemented from design-context metadata and tokens.

## Safety and secrets

- No API keys, tokens, passwords or private endpoints are present in the repository.
- The app makes no network requests in this MVP and requires no account.
- Phone calling opens the system dialer and never requests direct-call permissions.
