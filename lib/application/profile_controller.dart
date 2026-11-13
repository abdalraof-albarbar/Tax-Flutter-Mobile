import 'package:flutter/foundation.dart';
import '../domain/profile_settings.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({required this.store, required this.photoPicker});
  final ProfileStore store;
  final ProfilePhotoPicker photoPicker;
  ProfileSettings settings = const ProfileSettings();
  bool loading = true, busy = false;
  bool _restored = false;
  String? error;

  Future<void> initialize() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      settings = await store.load();
      _restored = true;
    } catch (_) {
      error = 'load';
      _restored = false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> _persist(ProfileSettings next) async {
    try {
      await store.save(next);
      settings = next;
      return true;
    } catch (_) {
      error = 'save';
      return false;
    }
  }

  Future<bool> update(ProfileSettings next) async {
    if (!_restored || busy || loading) return false;
    if (!['ar', 'en'].contains(next.language) ||
        ![1.0, 1.15, 1.3].contains(next.textScale) ||
        (next.photo?.length ?? 0) > ProfileSettings.maxPhotoBytes) {
      return false;
    }
    busy = true;
    error = null;
    notifyListeners();
    try {
      return await _persist(next);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<bool> choosePhoto() async {
    if (!_restored || busy || loading) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      final bytes = await photoPicker.pick();
      if (bytes == null) return false;
      if (bytes.length > ProfileSettings.maxPhotoBytes) {
        error = 'photo_size';
        return false;
      }
      return await _persist(settings.copyWith(photo: bytes));
    } catch (exception) {
      error = exception.toString().contains('photo_size')
          ? 'photo_size'
          : 'picker';
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}
