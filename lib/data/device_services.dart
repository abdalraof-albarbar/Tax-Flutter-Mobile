import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/contracts.dart';
import '../domain/inspection.dart';
import '../domain/visit.dart';

class DeviceAttachmentService implements AttachmentService {
  DeviceAttachmentService(this.picker);
  final ImagePicker picker;
  static const maxBytes = 2 * 1024 * 1024;
  @override
  Future<InspectionAttachment?> pickPhoto({required bool camera}) async {
    final file = await picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 75,
    );
    if (file == null) return null;
    if (await file.length() > maxBytes) {
      throw StateError('attachment_too_large');
    }
    return InspectionAttachment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: file.name,
      bytes: await file.readAsBytes(),
      isImage: true,
    );
  }

  @override
  Future<InspectionAttachment?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null) return null;
    final file = result.files.single;
    if (file.size > maxBytes) throw StateError('attachment_too_large');
    if (file.bytes == null) throw StateError('attachment_unreadable');
    return InspectionAttachment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: file.name,
      bytes: file.bytes!,
      isImage: false,
    );
  }
}

class BrowserDirectionsService implements DirectionsService {
  @override
  Future<bool> open(Visit visit) => launchUrl(
    Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${visit.latitude},${visit.longitude}',
    }),
    mode: LaunchMode.externalApplication,
  );
}
