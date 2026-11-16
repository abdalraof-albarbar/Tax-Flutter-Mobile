# Direct dependencies

## Version 0.5.0

| Package | Exact constraint | Purpose | Platforms / setup |
|---|---|---|---|
| `animations` | `2.1.1` | Official ready-made OpenContainer and FadeThroughTransition | All Flutter targets; Dart ^3.8.0, Flutter >=3.32.0; no native setup |

Source is flutter/packages at tag animations-v2.1.1, BSD-3-Clause. See
[component sources](COMPONENT_SOURCES.md) for the pinned commit and adaptations.
The newer 3.0.0 requires a newer SDK than this project and is not selected.

## Version 0.4.0

No new direct, SDK or development dependency. Access forms use native Flutter
Form/TextFormField, navigation and semantics; support screens use Slivers.
Two original PNG illustrations were created with the built-in image_gen tool
and bundled as assets. That generation tool is not an app/runtime dependency.

Target toolchain: Flutter **3.35.4**, Dart **3.9.2**. `pubspec.lock` is committed.
Versions below are exact constraints from `pubspec.yaml`. Transitive versions are
recorded in the lockfile. Review this table whenever adding a package.

| Package | Constraint | Purpose / alternative | Setup and platforms |
|---|---|---|---|
| `flutter` | Flutter SDK | Material 3, navigation, animation, ChangeNotifier | Android, iOS, web; no external state/router library needed |
| `flutter_localizations` | Flutter SDK | Arabic RTL and English Material controls and dates | App locale toggle; SDK delegates |
| `cupertino_icons` | 1.0.8 | Native iOS navigation icon fallback referenced by Flutter | Bundled icon font; prevents missing-font warnings on build |
| `shared_preferences` | 2.5.3 | Local JSON drafts and separate profile preferences behind store contracts | Android/iOS/web; use `SharedPreferencesAsync`; not secure or critical-data storage |
| `image_picker` | 1.2.0 | Inspection attachments and inspector gallery photo behind picker contracts | Android 24+; iOS camera/photo usage strings in Info.plist; browser capture is device-dependent |
| `file_picker` | 10.3.3 | Read PDF attachments as bytes | Android/iOS/web native file selection; 2 MB per file, 6 attachments per report |
| `qr_flutter` | 4.1.0 | Real offline QR rendering for local demo report ID | Android/iOS/web; contains no personal data, URL or official verification endpoint |
| `url_launcher` | 6.3.2 | External Google Maps directions for sample coordinates | Android/iOS/web; requires a compatible external app/browser; failures shown to user |
| `flutter_test` | Flutter SDK (dev) | Unit and widget regression tests | No device required; device service contracts replaced by fakes |
| `flutter_lints` | ^5.0.0 (dev) | Dart lint rules | `flutter analyze --fatal-infos` |

No runtime font-fetching package is needed: Cairo is bundled for offline use.
Version 0.2.0 adds **no packages**: SliverAppBar, SliverList, Hero and
FadeTransition are built into Flutter. The profile photo uses the existing
gallery picker (640px request, quality 80, maximum 512 KB after selection).
Version 0.3.0 also adds **no packages**: AnimatedAlign and AnimatedScale,
native InkWell keyboard/focus feedback, Hero and a PageRouteBuilder subclass
implement the profile polish. Cairo remains bundled; no runtime font fetch,
new state-management package, animation asset or image dependency is introduced.
Browser QA uses the external `@playwright/cli` tool through `npx` and an installed
Chrome browser; it is not an app dependency or shipped in the APK. Python's
already-installed OpenCV was used once to decode the screenshot QR for evidence.
Vercel deployment uses the existing external `vercel` CLI **59.5.0** or the
connected Vercel app; neither is shipped in the APK. The Vercel builder uses Bash and Git
to obtain the pinned official Flutter SDK. No new Flutter package is added.
The preview mirror workflow uses `actions/checkout` v6 pinned to
`d23441a48e516b6c34aea4fa41551a30e30af803`; it needs no Vercel token in GitHub.
No geolocation, networking API, authentication or official submission package is
installed. Opening Maps is explicit user action. The illustrative map uses Canvas.

## References and licenses

- [Flutter architecture](https://docs.flutter.dev/app-architecture/guide)
- [shared_preferences](https://pub.dev/packages/shared_preferences/versions/2.5.3):
  preferences may not persist critical writes; this is a bounded local demo store.
- [image_picker](https://pub.dev/packages/image_picker/versions/1.2.0): camera
  permissions and native lifecycle handling require real-device verification.
- [file_picker](https://pub.dev/packages/file_picker/versions/10.3.3)
- [qr_flutter](https://pub.dev/packages/qr_flutter/versions/4.1.0)
- [url_launcher](https://pub.dev/packages/url_launcher/versions/6.3.2)
- [Cairo source](https://github.com/google/fonts/tree/main/ofl/cairo): OFL 1.1,
  license included at `assets/fonts/OFL.txt`.

Plugin permissions are requested by native pickers when the user invokes an
action. Android uses scoped selection; no blanket external-storage permission
or GPS permission is requested. iOS host files are generated but unbuilt here.
