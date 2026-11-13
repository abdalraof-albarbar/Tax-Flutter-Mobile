# Verification — 13 November 2026

Toolchain: Flutter 3.35.4 / Dart 3.9.2 on Windows. CI uses the same Flutter version.

## Passed locally

- `dart run tool/check_project.dart`: all hand-authored files <=300 lines and
  all direct packages documented. Largest Dart source file: 211 lines.
- `dart format --output=none --set-exit-if-changed lib test tool`: clean.
- `flutter analyze --fatal-infos`: no issues.
- `flutter test --coverage --concurrency=1`: **20 tests passed**.
- `flutter build web --no-web-resources-cdn --no-wasm-dry-run`: successful.
- Actual release web app served on loopback and operated in Chrome at 430x932.
- Visually reviewed screenshots of all seven requested screens.
- Browser flow: start, check all items, enter Arabic notes, choose result, pick a
  PNG fixture, save draft, reload page, reopen report, confirm checklist/notes
  and photo survived, preview and submit locally.
- QR decoded from the rendered screenshot using OpenCV: `DEMO-V-0241`.
- Browser console after the full flow: no errors or warnings.
- Confirmed the report footer returns to the reports tab in the final build.
- Fixed a Chrome semantics hit-target regression caused by HTML-root `dir=rtl`.
  Flutter owns application direction; removing the host override restored normal
  language-button clicks. A web-host invariant test guards against recurrence.

Regression tests exercise 360x800 and 900x850 viewports with 1.3 text scale in
Arabic and English, plus navigation, language toggle, empty search, save-on-back,
save failure, return-to-reports navigation, filtering and submission rollback.
These are Flutter widget tests, not physical-device tests.

## Screenshots

The attachment screen includes an uploaded Flutter favicon as a **test fixture**
to demonstrate the picker and persistence. No demo photos are silently seeded.
Screenshots are viewport captures; lower sections can require scrolling.

| Reference | Runtime evidence |
|---|---|
| Home | [01-home.png](screenshots/01-home.png) |
| Visits | [02-visits.png](screenshots/02-visits.png) |
| Visit details | [03-visit-details.png](screenshots/03-visit-details.png) |
| Checklist | [04-checklist.png](screenshots/04-checklist.png) |
| Attachments | [05-attachments.png](screenshots/05-attachments.png) |
| Report preview | [06-report-preview.png](screenshots/06-report-preview.png) |
| Report details | [07-report-details.png](screenshots/07-report-details.png) |

## Environment failures resolved or bounded

- Windows shader/font tools failed when the build path contained Arabic
  characters (`Could not write file` / `Failed to open output file`). An ASCII
  junction `D:\Bussnis_projects\tax-flutter-build` points to this same checkout;
  the successful web build ran through that alias. The project was not moved.
- Building and testing concurrently exhausted host memory (`Could not start
  thread DartWorker`, `Out of memory`, `VirtualAlloc failed 1455`). Re-running
  sequentially, with one test worker and no Wasm dry run, succeeded. Do not
  run heavyweight jobs concurrently on this host.
- A later test run filled the host C: temporary directory (`errno = 112`).
  Pointing the test process's `TEMP` and `TMP` to this project's ignored
  `output/tmp` folder on D: allowed all 20 tests to pass.
- Two browser checkbox checks reported an immediate semantics-state mismatch;
  the subsequent screen and post-reload snapshot confirmed all three were
  checked. Flutter's accessibility placeholder required a DOM activation because
  its standard click target is deliberately outside the viewport.

## Not verified / not implemented

- Native Android camera permission, lifecycle recovery and real-device behavior.
  Local Android build was skipped: host Android licenses are incomplete and C:
  has little free space. GitHub Actions successfully built the debug APK on
  Linux; this proves compilation, not real-device behavior.
- iOS build, signing, device permissions, TalkBack/VoiceOver and performance.
- PDF rendering inside the app, production launcher artwork, secure transactional
  storage, authentication, API, real GPS and official submission/review.
- CD public demo prerelease delivery is configured following the owner's
  2026-11-13 visibility request, but has not been invoked; no release tag,
  store upload or hosted deployment was created.

See the PR's current [Actions results](https://github.com/abdalraof-albarbar/Tax-Flutter-Mobile/actions)
for CI status. Workflow configuration alone is not proof of a successful run.
