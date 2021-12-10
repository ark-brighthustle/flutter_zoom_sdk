import 'dart:core';
import 'dart:io';
import 'package:archive/archive.dart';

void main(List<String> args) async {
  var location = Platform.script.toString();
  if (Platform.isWindows) {
    location = location.replaceFirst("file:///", "");
  } else {
    location = location.replaceFirst("file://", "");
  }
  location = location.replaceFirst("/bin/unzip_zoom_sdk.dart", "");

  await checkAndDownloadSDK(location);

  print('Complete');
}

Future<void> checkAndDownloadSDK(String location) async {
  // var iosSDKFile = location +
  //     '/ios/MobileRTC.xcframework/ios-arm64_armv7/MobileRTC.framework/MobileRTC';
  // bool exists = await File(iosSDKFile).exists();
  //
  // if (!exists) {
  //   await downloadFile(
  //       Uri.parse(''),
  //       iosSDKFile);
  // }
  //
  // var iosSimulateSDKFile = location +
  //     '/ios/MobileRTC.xcframework/ios-i386_x86_64-simulator/MobileRTC.framework/MobileRTC';
  // exists = await File(iosSimulateSDKFile).exists();
  //
  // if (!exists) {
  //   await downloadFile(
  //       Uri.parse(''),
  //       iosSimulateSDKFile);
  // }

  var androidCommonLibFile = location + '/android/libs/commonlib.aar';
  bool exists = await File(androidCommonLibFile).exists();
  if (!exists) {
    await downloadFile(
        Uri.parse(
            'https://www.dropbox.com/s/i5fww50elzrphra/commonlib.aar?dl=1'),
        androidCommonLibFile);
  }
  var androidRTCLibFile = location + '/android/libs/mobilertc.aar';
  exists = await File(androidRTCLibFile).exists();
  if (!exists) {
    await downloadFile(
        Uri.parse(
            'https://www.dropbox.com/s/ahh06pva216szc1/mobilertc.aar?dl=1'),
        androidRTCLibFile);
  }
}

Future<void> downloadFile(Uri uri, String savePath) async {
  print('Download ${uri.toString()} to $savePath');
  final request = await HttpClient().getUrl(uri);
  final response = await request.close();
  await response.pipe(File(savePath).openWrite());
}