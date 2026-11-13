import 'dart:convert';
import 'dart:typed_data';
import 'package:tax_inspector_mobile/application/profile_controller.dart';
import 'package:tax_inspector_mobile/domain/profile_settings.dart';

class MemoryProfileStore implements ProfileStore {
  String source = '{}';
  bool failLoad = false, failSave = false;
  int writes = 0;
  @override
  Future<ProfileSettings> load() async {
    if (failLoad) throw StateError('simulated read failure');
    return ProfileSettings.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  @override
  Future<void> save(ProfileSettings settings) async {
    if (failSave) throw StateError('simulated disk full');
    source = jsonEncode(settings.toJson());
    writes++;
  }
}

class FakeProfilePicker implements ProfilePhotoPicker {
  Uint8List? bytes;
  bool fail = false;
  @override
  Future<Uint8List?> pick() async {
    if (fail) throw StateError('simulated access denied');
    return bytes;
  }
}

ProfileController makeProfile({
  MemoryProfileStore? store,
  FakeProfilePicker? picker,
}) => ProfileController(
  store: store ?? MemoryProfileStore(),
  photoPicker: picker ?? FakeProfilePicker(),
);
