import 'dart:convert';
import 'dart:typed_data';

class InspectionAttachment {
  const InspectionAttachment({
    required this.id,
    required this.name,
    required this.bytes,
    required this.isImage,
  });
  final String id, name;
  final Uint8List bytes;
  final bool isImage;
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'bytes': base64Encode(bytes),
    'isImage': isImage,
  };
  factory InspectionAttachment.fromJson(Map<String, dynamic> json) =>
      InspectionAttachment(
        id: json['id'] as String,
        name: json['name'] as String,
        bytes: base64Decode(json['bytes'] as String),
        isImage: json['isImage'] as bool,
      );
}

class Inspection {
  Inspection({required this.visitId, required this.reportNumber});
  final String visitId, reportNumber;
  final Set<String> checkedIds = {};
  final List<InspectionAttachment> attachments = [];
  String notes = '', attachmentNotes = '';
  String? violationId;
  bool? hasFindings;
  DateTime? startedAt, submittedAt, savedAt;
  bool get submitted => submittedAt != null;
  int get photoCount => attachments.where((a) => a.isImage).length;
  int get documentCount => attachments.where((a) => !a.isImage).length;
  Map<String, dynamic> toJson() => {
    'visitId': visitId,
    'reportNumber': reportNumber,
    'checkedIds': checkedIds.toList(),
    'notes': notes,
    'attachmentNotes': attachmentNotes,
    'violationId': violationId,
    'hasFindings': hasFindings,
    'startedAt': startedAt?.toIso8601String(),
    'submittedAt': submittedAt?.toIso8601String(),
    'savedAt': savedAt?.toIso8601String(),
    'attachments': attachments.map((a) => a.toJson()).toList(),
  };
  factory Inspection.fromJson(Map<String, dynamic> json) {
    final result = Inspection(
      visitId: json['visitId'] as String,
      reportNumber: json['reportNumber'] as String,
    );
    result.checkedIds.addAll((json['checkedIds'] as List).cast<String>());
    result.notes = json['notes'] as String;
    result.attachmentNotes = json['attachmentNotes'] as String;
    result.violationId = json['violationId'] as String?;
    result.hasFindings = json['hasFindings'] as bool?;
    result.startedAt = DateTime.tryParse(json['startedAt'] as String? ?? '');
    result.submittedAt = DateTime.tryParse(
      json['submittedAt'] as String? ?? '',
    );
    result.savedAt = DateTime.tryParse(json['savedAt'] as String? ?? '');
    result.attachments.addAll(
      (json['attachments'] as List).map(
        (a) =>
            InspectionAttachment.fromJson(Map<String, dynamic>.from(a as Map)),
      ),
    );
    return result;
  }
}
