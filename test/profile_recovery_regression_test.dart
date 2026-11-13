import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/app/inspector_app.dart';
import 'package:tax_inspector_mobile/application/profile_controller.dart';
import 'package:tax_inspector_mobile/data/profile_services.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';
import 'support/profile_preferences_fake.dart';
import 'support/widget_helpers.dart';

ProfileController profileFor(ProfilePreferencesFake preferences) =>
    ProfileController(
      store: LocalProfileStore(preferences),
      photoPicker: FakeProfilePicker(),
    );

void main() {
  setUpAll(loadCairo);
  final corruptSources = <String, String>{
    'invalid JSON': '{broken',
    'wrong object type': '[]',
    'null object': 'null',
    'non-string photo': '{"photo":42}',
    'invalid base64': '{"photo":"%%%"}',
    'non-numeric scale': '{"textScale":"large"}',
    'oversize photo': jsonEncode({'photo': base64Encode(Uint8List(524289))}),
  };
  for (final entry in corruptSources.entries) {
    test(
      '${entry.key} is recoverable without silently overwriting storage',
      () async {
        final preferences = ProfilePreferencesFake()
          ..values[LocalProfileStore.key] = entry.value;
        final profile = profileFor(preferences);
        await profile.initialize();
        expect(profile.error, 'corrupt');
        await profile.initialize();
        expect(profile.error, 'corrupt');
        expect(preferences.values[LocalProfileStore.key], entry.value);
        expect(preferences.values['inspection_demo_v1'], 'preserved draft');
      },
    );
  }

  testWidgets(
    'confirmed profile recovery unlocks editing and preserves drafts',
    (tester) async {
      setPhone(tester, size: const Size(360, 800));
      final preferences = ProfilePreferencesFake()
        ..values[LocalProfileStore.key] = '{broken';
      final profile = profileFor(preferences);
      await tester.pumpWidget(
        InspectorApp(controller: makeController(), profileController: profile),
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'open-profile');
      expect(find.byKey(const ValueKey('reset-profile')), findsOneWidget);
      await tapKey(tester, 'reset-profile');
      await tapKey(tester, 'cancel-profile-reset');
      expect(preferences.values[LocalProfileStore.key], '{broken');
      await tapKey(tester, 'reset-profile');
      await tapKey(tester, 'confirm-profile-reset');
      await tapKey(tester, 'profile-language-en');
      expect(profile.settings.language, 'en');
      expect(profile.error, isNull);
      expect(preferences.values['inspection_demo_v1'], 'preserved draft');
      final restored = profileFor(preferences);
      await restored.initialize();
      expect(restored.settings.language, 'en');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'failed recovery retains corrupt bytes and allows another reset',
    (tester) async {
      setPhone(tester);
      final preferences = ProfilePreferencesFake()
        ..values[LocalProfileStore.key] = '{broken'
        ..failures.write = true;
      final profile = profileFor(preferences);
      await tester.pumpWidget(
        InspectorApp(controller: makeController(), profileController: profile),
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'open-profile');
      expect(find.byKey(const ValueKey('reset-profile')), findsOneWidget);
      await tapKey(tester, 'reset-profile');
      await tapKey(tester, 'confirm-profile-reset');
      expect(profile.error, 'reset');
      expect(preferences.values[LocalProfileStore.key], '{broken');
      final choice = tester.widget<ChoiceChip>(
        find.byKey(const ValueKey('profile-language-en')),
      );
      expect(choice.onSelected, isNull);
      preferences.failures.write = false;
      await tapKey(tester, 'reset-profile');
      await tapKey(tester, 'confirm-profile-reset');
      expect(profile.error, isNull);
      expect(profile.settings.language, 'ar');
      expect(preferences.values['inspection_demo_v1'], 'preserved draft');
    },
  );

  testWidgets('I/O read failures offer retry without corrupt-data reset', (
    tester,
  ) async {
    setPhone(tester);
    final preferences = ProfilePreferencesFake()..failures.read = true;
    final profile = profileFor(preferences);
    await tester.pumpWidget(
      InspectorApp(controller: makeController(), profileController: profile),
    );
    await tester.pumpAndSettle();
    await tapKey(tester, 'open-profile');
    expect(profile.error, 'load');
    expect(find.byKey(const ValueKey('reset-profile')), findsNothing);
    expect(preferences.values['inspection_demo_v1'], 'preserved draft');
  });
}
