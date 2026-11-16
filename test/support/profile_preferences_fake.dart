import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Replace only device I/O; exercise LocalProfileStore's real JSON codec/key.
class ProfilePreferencesFake extends Fake implements SharedPreferencesAsync {
  final values = <String, String>{'inspection_demo_v1': 'preserved draft'};
  final failures = PreferenceFailures();
  @override
  Future<String?> getString(String key) async {
    if (failures.read) throw StateError('simulated I/O failure');
    return values[key];
  }

  @override
  Future<void> setString(String key, String value) async {
    if (failures.write) throw StateError('simulated disk full');
    values[key] = value;
  }
}

class PreferenceFailures {
  bool read = false, write = false;
}
