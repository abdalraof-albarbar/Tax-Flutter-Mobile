enum AccessIntent { login, signup, recovery }

/// Transient form data: never serialized, persisted or included in diagnostics.
class AccessRequest {
  const AccessRequest({
    required this.intent,
    required this.email,
    this.password = '',
    this.name = '',
  });
  final AccessIntent intent;
  final String email, password, name;
}

abstract interface class AccessPreviewService {
  Future<void> submit(AccessRequest request);
}

abstract final class AccessValidation {
  static bool email(String value) =>
      value.trim().length <= 254 &&
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim());
  static bool name(String value) =>
      value.trim().runes.length >= 2 && value.trim().runes.length <= 80;
  static bool password(String value) =>
      value.runes.length >= 8 && value.runes.length <= 128;
}
