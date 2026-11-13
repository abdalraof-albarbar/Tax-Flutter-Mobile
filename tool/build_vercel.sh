#!/usr/bin/env bash
set -euo pipefail

# Vercel's Linux builder does not include Flutter. Reuse an exact SDK in CI,
# or clone the official pinned release into a task-specific temporary directory.
flutter_version='3.35.4'
flutter_revision='d693b4b9dbac2acd4477aea4555ca6dcbea44ba2'

if [[ -n "${FLUTTER_ROOT:-}" && -x "$FLUTTER_ROOT/bin/flutter" ]]; then
  sdk="$FLUTTER_ROOT"
elif command -v flutter >/dev/null 2>&1; then
  flutter_path="$(readlink -f "$(command -v flutter)")"
  sdk="$(cd "$(dirname "$flutter_path")/.." && pwd)"
else
  sdk="${TMPDIR:-/tmp}/tax-preview-flutter-$flutter_version"
  if [[ ! -d "$sdk/.git" ]]; then
    git clone --depth 1 --branch "$flutter_version" \
      https://github.com/flutter/flutter.git "$sdk"
  fi
fi

actual_revision="$(git -C "$sdk" rev-parse HEAD)"
if [[ "$actual_revision" != "$flutter_revision" ]]; then
  echo "Expected Flutter $flutter_version ($flutter_revision), found $actual_revision" >&2
  exit 1
fi
export PATH="$sdk/bin:$PATH"
export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true

flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze --fatal-infos
flutter test --coverage --concurrency=1
flutter build web --release --no-web-resources-cdn --no-wasm-dry-run \
  --pwa-strategy=none
dart run tool/write_preview_metadata.dart
