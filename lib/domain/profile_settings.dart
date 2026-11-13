import 'dart:convert';
import 'dart:typed_data';

class ProfileSettings {
  const ProfileSettings({
    this.language = 'ar',
    this.textScale = 1,
    this.reduceMotion = false,
    this.photo,
  });
  final String language;
  final double textScale;
  final bool reduceMotion;
  final Uint8List? photo;
  static const maxPhotoBytes = 512 * 1024;

  ProfileSettings copyWith({
    String? language,
    double? textScale,
    bool? reduceMotion,
    Uint8List? photo,
    bool removePhoto = false,
  }) => ProfileSettings(
    language: language ?? this.language,
    textScale: textScale ?? this.textScale,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    photo: removePhoto ? null : photo ?? this.photo,
  );

  Map<String, Object?> toJson() => {
    'schema': 1,
    'language': language,
    'textScale': textScale,
    'reduceMotion': reduceMotion,
    'photo': photo == null ? null : base64Encode(photo!),
  };

  factory ProfileSettings.fromJson(Map<String, dynamic> json) {
    final photo = json['photo'] == null
        ? null
        : base64Decode(json['photo'] as String);
    if (photo != null && photo.length > maxPhotoBytes) {
      throw const FormatException('Profile photo exceeds local storage limit');
    }
    final scale = (json['textScale'] as num?)?.toDouble() ?? 1;
    return ProfileSettings(
      language: json['language'] == 'en' ? 'en' : 'ar',
      textScale: [1.0, 1.15, 1.3].contains(scale) ? scale : 1,
      reduceMotion: json['reduceMotion'] == true,
      photo: photo,
    );
  }
}

/// Stored bytes were read successfully, but cannot be decoded as this profile.
class ProfileDataCorruption implements Exception {
  const ProfileDataCorruption();
}

abstract interface class ProfileStore {
  Future<ProfileSettings> load();
  Future<void> save(ProfileSettings settings);
}

abstract interface class ProfilePhotoPicker {
  Future<Uint8List?> pick();
}
