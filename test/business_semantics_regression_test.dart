import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/data/sample_data.dart';
import 'package:tax_inspector_mobile/domain/business.dart';
import 'package:tax_inspector_mobile/presentation/business/business_details_screen.dart';
import 'support/fakes.dart';
import 'support/widget_helpers.dart';

void main() {
  setUpAll(loadCairo);
  testWidgets('business tax number has a readable semantic label', (
    tester,
  ) async {
    setPhone(tester);
    final handle = tester.ensureSemantics();
    try {
      final controller = makeController();
      await controller.initialize();
      await pumpScreen(
        tester,
        controller,
        BusinessDetailsScreen(
          business: Business.fromVisits(SampleData.visits).first,
        ),
      );
      expect(find.bySemanticsLabel('الرقم الضريبي 10024581'), findsOneWidget);
    } finally {
      handle.dispose();
    }
  });
}
