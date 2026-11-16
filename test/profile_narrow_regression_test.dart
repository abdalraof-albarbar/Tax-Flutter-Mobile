import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/presentation/profile/profile_screen.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  for (final language in ['ar', 'en']) {
    for (final width in [240.0, 280.0]) {
      testWidgets('identity reflows in a $width narrow $language window', (
        tester,
      ) async {
        setPhone(tester, size: Size(width, 800));
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
        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tapKey(tester, 'profile-text-1.0');
        expect(profile.settings.textScale, 1);
        await tester.drag(
          find.byKey(const ValueKey('profile-scroll')),
          const Offset(0, -1800),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
    testWidgets(
      'narrow $language profile preserves 2.08x system/preference text',
      (tester) async {
        setPhone(tester, size: const Size(240, 800));
        tester.platformDispatcher.textScaleFactorTestValue = 1.6;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
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
        final heading = find.text(
          language == 'ar' ? 'الملف الشخصي' : 'Your profile',
        );
        expect(
          MediaQuery.textScalerOf(tester.element(heading)).scale(10),
          closeTo(20.8, .01),
        );
        await tester.drag(
          find.byKey(const ValueKey('profile-scroll')),
          const Offset(0, -2400),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          MediaQuery.textScalerOf(
            tester.element(find.byType(ProfileScreen)),
          ).scale(10),
          closeTo(20.8, .01),
        );
      },
    );
  }
}
