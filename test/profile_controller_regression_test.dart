import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:tax_inspector_mobile/domain/profile_settings.dart';
import 'support/fakes.dart';
import 'support/profile_fakes.dart';

void main() {
  test('photo and preferences restore through a serialized store', () async {
    final store = MemoryProfileStore();
    final picker = FakeProfilePicker()..bytes = fakePhoto().bytes;
    final profile = makeProfile(store: store, picker: picker);
    await profile.initialize();
    expect(await profile.choosePhoto(), isTrue);
    expect(
      await profile.update(
        profile.settings.copyWith(
          language: 'en',
          textScale: 1.3,
          reduceMotion: true,
        ),
      ),
      isTrue,
    );
    final restored = makeProfile(store: store);
    await restored.initialize();
    expect(restored.settings.language, 'en');
    expect(restored.settings.textScale, 1.3);
    expect(restored.settings.reduceMotion, isTrue);
    expect(restored.settings.photo, fakePhoto().bytes);
    expect(
      await restored.update(restored.settings.copyWith(removePhoto: true)),
      isTrue,
    );
    final removed = makeProfile(store: store);
    await removed.initialize();
    expect(removed.settings.photo, isNull);
  });

  test('failed writes retain the previous photo and preferences', () async {
    final store = MemoryProfileStore();
    final picker = FakeProfilePicker()..bytes = fakePhoto().bytes;
    final profile = makeProfile(store: store, picker: picker);
    await profile.initialize();
    store.failSave = true;
    expect(await profile.choosePhoto(), isFalse);
    expect(profile.settings.photo, isNull);
    expect(
      await profile.update(profile.settings.copyWith(language: 'en')),
      isFalse,
    );
    expect(profile.settings.language, 'ar');
    expect(profile.error, 'save');
    expect(profile.busy, isFalse);
    store.failSave = false;
    expect(await profile.choosePhoto(), isTrue);
    store.failSave = true;
    expect(
      await profile.update(profile.settings.copyWith(removePhoto: true)),
      isFalse,
    );
    expect(profile.settings.photo, isNotNull);
  });

  test(
    'restore failure blocks writes until retry; corrupt data is preserved',
    () async {
      final store = MemoryProfileStore()..source = '{broken JSON';
      final profile = makeProfile(store: store);
      await profile.initialize();
      expect(profile.error, 'load');
      expect(
        await profile.update(const ProfileSettings(language: 'en')),
        isFalse,
      );
      expect(await profile.choosePhoto(), isFalse);
      expect(store.source, '{broken JSON');
      expect(store.writes, 0);
      store.source = '{}';
      await profile.initialize();
      expect(
        await profile.update(const ProfileSettings(language: 'en')),
        isTrue,
      );
    },
  );

  test('photo cancellation, access failure and oversize are safe', () async {
    final store = MemoryProfileStore();
    final picker = FakeProfilePicker();
    final profile = makeProfile(store: store, picker: picker);
    await profile.initialize();
    expect(await profile.choosePhoto(), isFalse);
    expect(profile.error, isNull);
    picker.fail = true;
    expect(await profile.choosePhoto(), isFalse);
    expect(profile.error, 'picker');
    picker.fail = false;
    picker.bytes = Uint8List(ProfileSettings.maxPhotoBytes + 1);
    expect(await profile.choosePhoto(), isFalse);
    expect(profile.error, 'photo_size');
    expect(store.writes, 0);
  });

  test('unknown preference values cannot be written', () async {
    final profile = makeProfile();
    await profile.initialize();
    expect(
      await profile.update(const ProfileSettings(language: 'xx')),
      isFalse,
    );
    expect(await profile.update(const ProfileSettings(textScale: 10)), isFalse);
    expect(profile.settings.language, 'ar');
    expect(profile.settings.textScale, 1);
  });
}
