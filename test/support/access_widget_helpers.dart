import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/application/access_controller.dart';
import 'access_fakes.dart';
import 'fakes.dart';
import 'widget_helpers.dart';

Future<AccessController> pumpAccess(
  WidgetTester tester, {
  FakeAccessService? service,
  MemoryStore? store,
}) async {
  setPhone(tester);
  final access = AccessController(service: service ?? FakeAccessService());
  await tester.pumpWidget(
    InspectorApp(
      controller: makeController(store: store),
      accessController: access,
    ),
  );
  await tester.pumpAndSettle();
  return access;
}

Future<void> enter(WidgetTester tester, String key, String value) async {
  final field = find.byKey(ValueKey(key));
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, value);
  await tester.pump();
}
