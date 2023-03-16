import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> saveFile(List<int> bytes, String fileName) async {
  final docDir = await AndroidPathProvider.documentsPath;
  final file = File('$docDir/$fileName.pdf');
  print('======saved at path=$docDir/$fileName.pdf');
  await file.writeAsBytes(bytes, mode: FileMode.write);
}

Future<void> convertToPdf(List<Uint8List> uint8list, String fileName) async {
  PdfDocument document = PdfDocument();
  document.pageSettings.margins.all = 0;
  for (final imageFile in uint8list) {
    final PdfImage image = PdfBitmap(imageFile);
    PdfPage page = document.pages.add();
    Size clientSize = page.getClientSize();
    page.graphics.drawImage(
        image, Rect.fromLTWH(0, 0, clientSize.width, clientSize.height));
  }
  await saveFile(await document.save(), fileName);
}
