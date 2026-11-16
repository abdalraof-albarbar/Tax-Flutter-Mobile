import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/application/access_controller.dart';
import 'package:tax_inspector_mobile/application/essentials_controller.dart';
import 'package:tax_inspector_mobile/data/essential_samples.dart';
import 'package:tax_inspector_mobile/domain/access.dart';
import 'support/access_fakes.dart';

const request = AccessRequest(
  intent: AccessIntent.login,
  email: 'inspector@example.test',
  password: 'sample-only',
);

void main() {
  test(
    'validation supports Arabic names and bounds invalid or oversized inputs',
    () {
      expect(AccessValidation.name('أحمد الزروق'), isTrue);
      expect(AccessValidation.name('   '), isFalse);
      expect(AccessValidation.name('x' * 81), isFalse);
      expect(AccessValidation.email(' inspector@example.test '), isTrue);
      for (final value in [
        '',
        'a@',
        'a b@example.test',
        '${'a' * 250}@x.test',
      ]) {
        expect(AccessValidation.email(value), isFalse);
      }
      expect(AccessValidation.password('sample-only'), isTrue);
      expect(AccessValidation.password('short'), isFalse);
      expect(AccessValidation.password('a' * 129), isFalse);
    },
  );
  test('invalid forms never call the preview service', () async {
    final service = FakeAccessService();
    final controller = AccessController(service: service);
    expect(
      await controller.submit(
        const AccessRequest(
          intent: AccessIntent.login,
          email: 'invalid',
          password: 'sample-only',
        ),
      ),
      isFalse,
    );
    expect(
      await controller.submit(
        const AccessRequest(
          intent: AccessIntent.signup,
          email: 'x@example.test',
          password: 'sample-only',
        ),
      ),
      isFalse,
    );
    expect(service.calls, 0);
    expect(controller.exploring, isFalse);
  });
  test(
    'duplicate submissions are blocked and form completion is not a session',
    () async {
      final pending = Completer<void>();
      final service = FakeAccessService()..completion = () => pending.future;
      final controller = AccessController(service: service);
      final first = controller.submit(request);
      expect(controller.busy, isTrue);
      expect(await controller.submit(request), isFalse);
      expect(service.calls, 1);
      pending.complete();
      expect(await first, isTrue);
      expect(controller.busy, isFalse);
      expect(controller.exploring, isFalse);
      controller.startDemo();
      expect(controller.exploring, isTrue);
      controller.endDemo();
      expect(controller.exploring, isFalse);
    },
  );
  test('failed previews can retry and recovery needs no password', () async {
    final service = FakeAccessService()..fail = true;
    final controller = AccessController(service: service);
    expect(await controller.submit(request), isFalse);
    expect(controller.failed, isTrue);
    service.fail = false;
    expect(
      await controller.submit(
        const AccessRequest(
          intent: AccessIntent.recovery,
          email: 'x@example.test',
        ),
      ),
      isTrue,
    );
    expect(controller.failed, isFalse);
    expect(controller.busy, isFalse);
  });
  test(
    'disposing while a preview is pending does not notify or enter a session',
    () async {
      final pending = Completer<void>();
      final service = FakeAccessService()..completion = () => pending.future;
      final controller = AccessController(service: service);
      final work = controller.submit(request);
      controller.dispose();
      pending.complete();
      expect(await work, isFalse);
    },
  );
  test(
    'notification reads are idempotent and do not create unknown records',
    () {
      final controller = EssentialsController(
        notifications: EssentialSamples.notifications,
      );
      var changes = 0;
      controller.addListener(() => changes++);
      expect(controller.unreadCount, 3);
      controller.markRead('unknown');
      expect(changes, 0);
      controller.markRead('schedule');
      controller.markRead('schedule');
      expect(controller.unreadCount, 2);
      expect(changes, 1);
      controller.markAllRead();
      controller.markAllRead();
      expect(controller.unreadCount, 0);
      expect(changes, 2);
      expect(controller.notifications, hasLength(3));
    },
  );
}
