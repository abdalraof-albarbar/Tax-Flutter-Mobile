import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/presentation/visits/visit_filters.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  for (final atEnd in [false, true]) {
    testWidgets(
      'calendar rejects dates outside its picker range at end=$atEnd',
      (tester) async {
        setPhone(tester);
        final date = atEnd ? DateTime(2027, 12, 31) : DateTime(2026, 1, 1);
        DateTime? selected;
        final controller = makeController();
        await controller.initialize();
        await pumpScreen(
          tester,
          controller,
          Scaffold(
            body: DateStrip(date: date, onChanged: (value) => selected = value),
          ),
        );
        final outside = find.text(atEnd ? '1' : '28');
        if (outside.evaluate().isEmpty) {
          await tester.scrollUntilVisible(
            outside,
            120,
            scrollable: find.byType(Scrollable).first,
          );
        }
        await tester.ensureVisible(outside);
        await tester.pumpAndSettle();
        await tester.tap(outside, warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(selected, isNull);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
