import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/presentation/profile/inspector_avatar.dart';
import 'package:tax_inspector_mobile/presentation/profile/profile_screen.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets(
    'avatar opens settings; photo, locale and motion affect the app',
    (tester) async {
      setPhone(tester);
      final picker = FakeProfilePicker()..bytes = fakePhoto().bytes;
      final profile = makeProfile(picker: picker);
      await tester.pumpWidget(
        InspectorApp(controller: makeController(), profileController: profile),
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'open-profile');
      expect(find.byType(ProfileScreen), findsOneWidget);
      await tapKey(tester, 'edit-profile-photo');
      await tapKey(tester, 'choose-profile-photo');
      expect(profile.settings.photo, isNotNull);
      await tapKey(tester, 'profile-language-en');
      expect(find.text('Your profile'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(ProfileScreen))),
        TextDirection.ltr,
      );
      await tapKey(tester, 'profile-reduce-motion');
      expect(profile.settings.reduceMotion, isTrue);
      expect(
        MediaQuery.disableAnimationsOf(
          tester.element(find.byType(ProfileScreen)),
        ),
        isTrue,
      );
      await tapKey(tester, 'profile-back');
      final avatar = tester.widget<InspectorAvatar>(
        find.byType(InspectorAvatar),
      );
      expect(avatar.photo, fakePhoto().bytes);
      expect(find.text('Home'), findsOneWidget);
    },
  );

  testWidgets('photo removal and save failure have honest UI feedback', (
    tester,
  ) async {
    setPhone(tester);
    final store = MemoryProfileStore();
    final profile = makeProfile(
      store: store,
      picker: FakeProfilePicker()..bytes = fakePhoto().bytes,
    );
    await tester.pumpWidget(
      InspectorApp(controller: makeController(), profileController: profile),
    );
    await tester.pumpAndSettle();
    await tapKey(tester, 'open-profile');
    await tapKey(tester, 'edit-profile-photo');
    await tapKey(tester, 'choose-profile-photo');
    await tester.drag(
      find.byKey(const ValueKey('profile-scroll')),
      const Offset(0, 900),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('edit-profile-photo')));
    await tester.pumpAndSettle();
    await tapKey(tester, 'remove-profile-photo');
    expect(profile.settings.photo, isNull);
    store.failSave = true;
    await tapKey(tester, 'profile-language-en');
    expect(profile.settings.language, 'ar');
    await tester.drag(
      find.byKey(const ValueKey('profile-scroll')),
      const Offset(0, 900),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('تعذر حفظ التغيير'), findsOneWidget);
  });

  for (final size in [const Size(360, 800), const Size(900, 850)]) {
    for (final language in ['ar', 'en']) {
      testWidgets('sliver profile fits $size $language at enlarged text', (
        tester,
      ) async {
        setPhone(tester, size: size);
        final profile = makeProfile();
        await profile.initialize();
        await profile.update(
          profile.settings.copyWith(language: language, textScale: 1.3),
        );
        await tester.pumpWidget(
          InspectorApp(
            controller: makeController(),
            profileController: profile,
          ),
        );
        await tester.pumpAndSettle();
        await tapKey(tester, 'open-profile');
        expect(tester.takeException(), isNull);
        expect(find.byType(SliverAppBar), findsOneWidget);
        await tester.drag(
          find.byKey(const ValueKey('profile-scroll')),
          const Offset(0, -1800),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final back = find.byKey(const ValueKey('profile-back'));
        expect(tester.getRect(back).top, greaterThanOrEqualTo(0));
        await tester.tap(back);
        await tester.pumpAndSettle();
        expect(find.byType(ProfileScreen), findsNothing);
      });
    }
  }
}
