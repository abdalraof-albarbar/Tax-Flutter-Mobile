# Development and delivery

Use PowerShell from the repository root. Toolchain is pinned in CI to Flutter
3.35.4 / Dart 3.9.2. Do not upgrade dependencies without tests and documentation.

```powershell
git switch main
git pull --ff-only
git switch -c feat/descriptive-name
flutter pub get --enforce-lockfile
dart run tool/check_project.dart
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze --fatal-infos
flutter test --coverage --concurrency=1
flutter build web --no-web-resources-cdn
```

Every new task uses a new branch and PR. Include validation evidence and known
limitations. Never push directly to main. Repository settings may require an
eligible GitHub plan to enforce private-branch protection; these documented
rules and CI do not by themselves lock main.

## CI

`.github/workflows/flutter.yml` runs policy checks, formatting, static analysis,
regression tests with coverage, a self-contained web build and Android debug APK.
Artifacts are private to repository access and expire after 14 days. iOS requires
macOS/Xcode and signing; it is not built by this workflow.

## CD

After an approved PR is merged, an explicitly requested `demo-v*` tag runs the
same validation/build workflow, checks repository privacy and main ancestry,
then creates a **private prerelease** with APK and web ZIP. This is internal demo
delivery. No Play Store, App Store, hosting deployment or production keys are
configured. No release tag is created as part of initial implementation.

## Regression coverage

Tests cover search/filter composition, visit identity and lifecycle, submission
validation, save rollback, local serialization, attachment cancellation/limits,
loading failures, screen navigation, language switching, back navigation and
small/large layouts with increased text scaling.

For a UI change, reproduce the failure with a meaningful test. Verify runtime
screenshots in addition to tests. Plugin fakes do not prove native permissions,
camera behavior, iOS operation or device performance.
