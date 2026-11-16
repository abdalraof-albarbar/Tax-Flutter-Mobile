import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/presentation/access/access_field.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets('external form labels name the editable accessibility node', (
    tester,
  ) async {
    setPhone(tester);
    final semantics = tester.ensureSemantics();
    final text = TextEditingController();
    addTearDown(text.dispose);
    try {
      await pumpScreen(
        tester,
        makeController(),
        Scaffold(
          body: AccessField(
            fieldKey: 'email',
            label: 'البريد الإلكتروني',
            controller: text,
            email: true,
            validator: (_) => null,
          ),
        ),
      );
      final node = tester.getSemantics(find.byType(EditableText));
      expect(node.flagsCollection.isTextField, isTrue);
      expect(node.label, contains('البريد الإلكتروني'));
    } finally {
      semantics.dispose();
    }
  });
}
