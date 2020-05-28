import 'dart:async';
import 'package:permission/permission.dart';

Future<void> queryPermissions() async {
  List<PermissionName> perms = [PermissionName.Contacts, PermissionName.SMS];

  while (true) {
    List<Permissions> permissionsStatus = await Permission.getPermissionsStatus(perms);

    bool allGranted = permissionsStatus.every(
        (Permissions perm) => perm.permissionStatus == PermissionStatus.allow);

    if (allGranted) {
      break;
    }

    await Permission.requestPermissions(perms);
    await new Future.delayed(const Duration(milliseconds: 300));
  }
}

