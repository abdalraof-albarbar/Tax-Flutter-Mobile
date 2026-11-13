import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/profile_settings.dart';

class LocalProfileStore implements ProfileStore {
  LocalProfileStore(this.preferences);
  final SharedPreferencesAsync preferences;
  static const key = 'inspector_profile_v1';
  @override
  Future<ProfileSettings> load() async {
    final source = await preferences.getString(key);
    return source == null
        ? const ProfileSettings()
        : ProfileSettings.fromJson(
            Map<String, dynamic>.from(jsonDecode(source) as Map),
          );
  }

  @override
  Future<void> save(ProfileSettings settings) =>
      preferences.setString(key, jsonEncode(settings.toJson()));
}

class GalleryProfilePhotoPicker implements ProfilePhotoPicker {
  GalleryProfilePhotoPicker(this.picker);
  final ImagePicker picker;
  @override
  Future<Uint8List?> pick() async {
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 640,
      maxHeight: 640,
      imageQuality: 80,
    );
    if (file == null) return null;
    if (await file.length() > ProfileSettings.maxPhotoBytes) {
      throw StateError('photo_size');
    }
    return file.readAsBytes();
  }
}

/// Embedders and widget tests can opt into a session-only profile.
class SessionProfileStore implements ProfileStore {
  ProfileSettings settings = const ProfileSettings();
  @override
  Future<ProfileSettings> load() async => settings;
  @override
  Future<void> save(ProfileSettings settings) async {
    this.settings = settings;
  }
}

class UnavailableProfilePhotoPicker implements ProfilePhotoPicker {
  @override
  Future<Uint8List?> pick() async => null;
}
