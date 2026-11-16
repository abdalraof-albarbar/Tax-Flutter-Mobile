import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/presentation/profile/profile_screen.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets(
    'enabling reduced motion also removes the current route exit animation',
    (tester) async {
      setPhone(tester);
      final profile = makeProfile();
      await tester.pumpWidget(
        InspectorApp(controller: makeController(), profileController: profile),
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'open-profile');
      await tapKey(tester, 'profile-reduce-motion');
      await tester.tap(find.byKey(const ValueKey('profile-back')));
      await tester.pump();
      expect(find.byType(ProfileScreen), findsNothing);
    },
  );

  testWidgets(
    'language options expose selection and work with keyboard activation',
    (tester) async {
      setPhone(tester);
      final semantics = tester.ensureSemantics();
      try {
        final profile = makeProfile();
        await tester.pumpWidget(
          InspectorApp(
            controller: makeController(),
            profileController: profile,
          ),
        );
        await tester.pumpAndSettle();
        await tapKey(tester, 'open-profile');
        final arabic = find.byKey(const ValueKey('profile-language-ar'));
        expect(tester.getSemantics(arabic).flagsCollection.isSelected, isTrue);
        final english = find.byKey(const ValueKey('profile-language-en'));
        await tester.ensureVisible(english);
        // Tab through the actual controls rather than invoking their callbacks.
        for (var i = 0; i < 12; i++) {
          if (tester.getSemantics(english).flagsCollection.isFocused) {
            break;
          }
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
        }
        expect(tester.getSemantics(english).flagsCollection.isFocused, isTrue);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(profile.settings.language, 'en');
        expect(tester.getSemantics(english).flagsCollection.isSelected, isTrue);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'reduced-motion photo sheet is immediately usable and dismissible',
    (tester) async {
      setPhone(tester);
      final profile = makeProfile();
      await profile.initialize();
      await profile.update(profile.settings.copyWith(reduceMotion: true));
      await tester.pumpWidget(
        InspectorApp(controller: makeController(), profileController: profile),
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'open-profile');
      await tester.tap(find.byKey(const ValueKey('edit-profile-photo')));
      await tester.pump();
      expect(
        find.byKey(const ValueKey('choose-profile-photo')).hitTestable(),
        findsOneWidget,
      );
      await tester.tapAt(const Offset(5, 5));
      await tester.pump();
      expect(find.byKey(const ValueKey('choose-profile-photo')), findsNothing);
    },
  );

  for (final language in ['ar', 'en']) {
    for (final size in [const Size(360, 800), const Size(900, 850)]) {
      testWidgets('profile preserves large system text at $size in $language', (
        tester,
      ) async {
        setPhone(tester, size: size);
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
        final context = tester.element(find.byType(ProfileScreen));
        expect(MediaQuery.textScalerOf(context).scale(10), closeTo(20.8, .01));
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.byKey(const ValueKey('profile-scroll')),
          const Offset(0, -2200),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
