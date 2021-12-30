import 'dart:io';

import 'package:device_info/device_info.dart';

Future<String> getOSVersionAndModel() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    return 'Android $release (SDK $sdkInt), $manufacturer $model';
  }

  if (Platform.isIOS) {
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    var systemName = iosInfo.systemName;
    var version = iosInfo.systemVersion;
    var name = iosInfo.name;
    var model = iosInfo.model;
    return '$systemName $version, $name $model';
  }

  return 'An error has occured.';
}
