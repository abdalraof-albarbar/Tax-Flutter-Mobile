import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/contracts.dart';
import '../domain/inspection.dart';

class LocalDraftStore implements DraftStore {
  LocalDraftStore(this.preferences);
  final SharedPreferencesAsync preferences;
  static const key = 'inspection_demo_v1';
  @override
  Future<List<Inspection>> load() async {
    final source = await preferences.getString(key);
    if (source == null) return [];
    final decoded = jsonDecode(source) as List;
    return decoded
        .map(
          (row) => Inspection.fromJson(Map<String, dynamic>.from(row as Map)),
        )
        .toList();
  }

  @override
  Future<void> save(List<Inspection> inspections) => preferences.setString(
    key,
    jsonEncode(inspections.map((i) => i.toJson()).toList()),
  );
}
