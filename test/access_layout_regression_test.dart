import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/application/access_controller.dart';
import 'support/access_fakes.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  for (final language in ['ar', 'en']) {
    for (final size in [
      const Size(240, 800),
      const Size(360, 740),
      const Size(1100, 850),
    ]) {
      for (final destination in ['welcome-login', 'welcome-signup']) {
        testWidgets(
          '$destination fits $size in $language with enlarged text/keyboard',
          (tester) async {
            setPhone(tester, size: size);
            tester.platformDispatcher.textScaleFactorTestValue =
                size.width == 360 ? 1.6 : 1;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );
            final profile = makeProfile();
            await profile.initialize();
            await profile.update(
              profile.settings.copyWith(
                language: language,
                textScale: size.width >= 900 ? 1 : 1.3,
              ),
            );
            await tester.pumpWidget(
              InspectorApp(
                controller: makeController(),
                profileController: profile,
                accessController: AccessController(
                  service: FakeAccessService(),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            await tapKey(tester, destination);
            expect(tester.takeException(), isNull);
            tester.view.viewInsets = FakeViewPadding(bottom: 280);
            addTearDown(tester.view.resetViewInsets);
            await tester.pumpAndSettle();
            await tapKey(tester, 'access-submit');
            expect(
              find.text(
                language == 'ar'
                    ? 'اكتب بريدًا إلكترونيًا صالحًا'
                    : 'Enter a valid email address',
              ),
              findsOneWidget,
            );
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
