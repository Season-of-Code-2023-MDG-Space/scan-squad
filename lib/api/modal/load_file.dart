import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<List<FileSystemEntity>> getDir() async {
  List<FileSystemEntity> folders;
  final docDir = await AndroidPathProvider.documentsPath;
  // final directory = await getExternalStorageDirectory();
  // final dir = directory?.path;
  final myDir = Directory(docDir);
  folders = myDir.listSync(recursive: true, followLinks: false);
  return folders;
}

Future<void> openPdfFile(String fileName) async {
  // final directory = await getExternalStorageDirectory();
  // final dir = directory?.path;
  // OpenFilex.open('$dir/$fileName');
  final docDir = await AndroidPathProvider.documentsPath;
  print('======pathIn=$docDir/$fileName');
  OpenFilex.open('$docDir/$fileName');
}
