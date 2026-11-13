import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/application/essentials_controller.dart';
import 'package:tax_inspector_mobile/data/essential_samples.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';
import 'support/profile_fakes.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets('in-app reduced motion opens FAQ answers immediately', (
    tester,
  ) async {
    setPhone(tester);
    final profile = makeProfile();
    await profile.initialize();
    await profile.update(profile.settings.copyWith(reduceMotion: true));
    await tester.pumpWidget(
      InspectorApp(controller: makeController(), profileController: profile),
    );
    await tester.pumpAndSettle();
    await tapKey(tester, 'open-profile');
    await tapKey(tester, 'profile-help');
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pump();
    expect(
      find.text(EssentialSamples.help.first.answer.arabic).hitTestable(),
      findsOneWidget,
    );
  });
  testWidgets(
    'help searches answers, expands results and recovers from no matches',
    (tester) async {
      setPhone(tester);
      await tester.pumpWidget(InspectorApp(controller: makeController()));
      await tester.pumpAndSettle();
      await tapKey(tester, 'open-profile');
      await tapKey(tester, 'profile-help');
      final field = find.byKey(const ValueKey('help-search'));
      await tester.enterText(field, 'حساب حقيقي');
      await tester.pumpAndSettle();
      await tester.tap(find.text('هل يمكن إنشاء حساب حقيقي؟'));
      await tester.pumpAndSettle();
      expect(find.textContaining('لا تُنشأ حسابات'), findsOneWidget);
      await tester.enterText(field, 'no-matching-answer');
      await tester.pumpAndSettle();
      expect(find.text('ما لقيناش إجابة مطابقة'), findsOneWidget);
      await tapKey(tester, 'help-reset');
      expect(find.text('كيف أحفظ مسودة الزيارة؟'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'notifications filter unread, mark all and remove the shell badge',
    (tester) async {
      setPhone(tester);
      final controller = EssentialsController(
        notifications: EssentialSamples.notifications,
      );
      await tester.pumpWidget(
        InspectorApp(
          controller: makeController(),
          essentialsController: controller,
        ),
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'open-notifications');
      await tapKey(tester, 'notification-read-schedule');
      expect(controller.unreadCount, 2);
      await tapKey(tester, 'notifications-unread');
      expect(find.text('جدول زياراتك جاهز'), findsNothing);
      await tapKey(tester, 'notifications-read-all');
      expect(find.text('كل شيء مقروء'), findsOneWidget);
      await tapKey(tester, 'notifications-show-all');
      expect(find.text('جدول زياراتك جاهز'), findsOneWidget);
      await tapKey(tester, 'essentials-back');
      final badge = tester.widget<Badge>(
        find.descendant(
          of: find.byKey(const ValueKey('open-notifications')),
          matching: find.byType(Badge),
        ),
      );
      expect(badge.isLabelVisible, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}
