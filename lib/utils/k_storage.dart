import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '/utils/language_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_settings/app_settings.dart';

class KStorage {
  
  static Future<bool> determineStorage() async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print("success");
      return true;
    }
    var status = await Permission.storage.status;
    if (status.isDenied) { 
        // You can request multiple permissions at once.
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
        print(statuses[Permission.storage]); // it should print PermissionStatus.granted  
        //statuses[Permission.storage] == PermissionStatus.granted;
        return false;
    }
    if (await Permission.storage.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.  
      Fluttertoast.showToast(
        msg: Language.storagePermissionsAreDenied,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      AppSettings.openInternalStorageSettings();
      print(Future.error(Language.storagePermissionsAreDenied));
      return false;
    }
    return true;
  }
}