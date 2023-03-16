import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';

Future<XFile> xFileToNewXFile(XFile pickedFile, Uint8List? uint8list) async {
  final file = File(pickedFile.path);
  await file.writeAsBytes(uint8list!);
  final xFile = XFile(file.path);
  return xFile;
}

File xFileToFile(XFile pickedFile, Uint8List? uint8list) {
  final newFile = File(pickedFile.path);
  newFile.writeAsBytesSync(uint8list!);
  return newFile;
}

Future<Position> getUserLocation() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return position;
}

Map<String, String> formatTimeStamp(DateTime timeStamp) {
  String hours = timeStamp.hour.toString(),
      minutes = timeStamp.minute.toString();
  if (timeStamp.hour.toString().length < 2) {
    hours = '0${timeStamp.hour}';
  }
  if (timeStamp.minute.toString().length < 2) {
    minutes = '0${timeStamp.minute}';
  }
  Map<String, String> time = {'hour': hours, 'minute': minutes};
  return time;
}

void sharePDF(String? path) {
  final xFile = XFile(path!);
  Share.shareXFiles([xFile], subject: 'Share PDF');
}
