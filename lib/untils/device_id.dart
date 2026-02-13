import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceId {
  static String? _id;

  static Future<String> get() async {
    if (_id != null) return _id!;
    final info = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      _id = (await info.androidInfo).id;
    } else {
      _id = (await info.iosInfo).identifierForVendor;
    }
    return _id!;
  }
}
