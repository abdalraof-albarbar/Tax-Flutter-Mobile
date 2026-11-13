import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/inspector_app.dart';
import 'application/inspection_controller.dart';
import 'data/device_services.dart';
import 'data/local_draft_store.dart';
import 'data/sample_data.dart';
import 'domain/inspection_policy.dart';
import 'application/profile_controller.dart';
import 'data/profile_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = InspectionController(
    repository: DemoVisitRepository(),
    store: LocalDraftStore(SharedPreferencesAsync()),
    attachments: DeviceAttachmentService(ImagePicker()),
    directions: BrowserDirectionsService(),
    scheduleDate: SampleData.date,
    policy: const InspectionPolicy(
      checklist: SampleData.checklist,
      violations: SampleData.violations,
    ),
  );
  runApp(
    InspectorApp(
      controller: controller,
      profileController: ProfileController(
        store: LocalProfileStore(SharedPreferencesAsync()),
        photoPicker: GalleryProfilePhotoPicker(ImagePicker()),
      ),
    ),
  );
}
