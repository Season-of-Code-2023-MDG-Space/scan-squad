import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:scan/scan.dart';
import 'package:scansquad/api/modal/secureData.dart';
import 'package:scansquad/api/modal/verify_data.dart';

class PdfToImage {
  Future<Map<String, dynamic>> convertToImageAndScan(
      FilePickerResult result) async {
    Map<String, dynamic> qrDataWithVerificationDetails;
    List<String?> allQrdatalist = [];
    final pdfFile = File(result.files.single.path!);
    final pdfFileName = result.files.single.name;
    final lastModifiedSync = pdfFile.lastModifiedSync();
    final document = await PdfDocument.openFile(pdfFile.path);
    for (int pageNumber = 1; pageNumber <= document.pagesCount; pageNumber++) {
      final page = await document.getPage(pageNumber);
      final pdfPageImage = await page.render(
          width: page.width,
          height: page.height,
          format: PdfPageImageFormat.jpeg);
      final output = await getExternalStorageDirectory();

      if (output != null) {
        File imageFile = File('${output.path}/$pdfFileName-$pageNumber.png');
        await imageFile.writeAsBytes(pdfPageImage!.bytes);
        String? barcode = await Scan.parse(imageFile.path);
        if (barcode != null) {
          final decryptedString = await SecureData().decryptData(barcode);
          allQrdatalist.add(decryptedString);
        }
        final file = File(imageFile.path);
        file.deleteSync();
      }
      await page.close();
    }
    print('======Total QRS identified=${allQrdatalist.length}');
    qrDataWithVerificationDetails = verifyData(allQrdatalist, lastModifiedSync);
    await document.close();
    return qrDataWithVerificationDetails;
  }
}
