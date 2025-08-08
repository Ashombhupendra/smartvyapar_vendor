import 'package:new_version_plus/new_version_plus.dart';

Future <void> checkAppVersion(context) async {
  final newVersion = NewVersionPlus(
    androidId: "com.dbvertex.vendorApp",
  );
  final status = await newVersion.getVersionStatus();
  if (status != null && status.canUpdate) {
    newVersion.showUpdateDialog(
     versionStatus: status,
      dialogTitle: 'Update Available',
      dismissButtonText: 'Later',
      updateButtonText: 'Update Now',
     context: context,
    );
  }
}
