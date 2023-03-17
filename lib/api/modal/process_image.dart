import 'dart:typed_data';
import 'package:barcode_image/barcode_image.dart';
import 'package:image/image.dart' as img;
import 'package:scansquad/api/modal/secureData.dart';
import 'package:scansquad/routes/common_functions.dart';

class ImageProcess {
  Future<Uint8List> writeExifData(Uint8List imagepicked,
      {required String userName}) async {
    final userLoc = await getUserLocation();
    DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    String hours = formatTimeStamp(timeStamp).values.first;
    String minute = formatTimeStamp(timeStamp).values.last;
    String encryptedQRData =
        await SecureData().encryptData(userName + hours + minute);
    img.Image mImageWithDate = img.drawString(
      img.decodeImage(imagepicked)!,
      img.arial_24,
      10,
      40,
      'Time: $hours: $minute',
    );
    img.Image mImageWithDateAndLoc = img.drawString(
      mImageWithDate,
      img.arial_24,
      10,
      70,
      'Position:(${userLoc.latitude} , ${userLoc.longitude})',
    );
    img.Image mImage = img.drawString(
      mImageWithDateAndLoc,
      img.arial_24,
      10,
      10,
      'Username:$userName',
    );
    final newImage = drawQRCodes(mImage, encryptedQRData);
    List<int> wmImage = img.encodePng(newImage);
    Uint8List uint8list = Uint8List.fromList(wmImage);
    return uint8list;
  }

  img.Image drawQRCodes(img.Image mImage, String encryptedQRData) {
    int qrSize = 150, qrPadding = 20, wd = 70, qrOpacity = 150;
    img.Image wImage = img.Image.rgb(1690, 2140);
    img.fill(wImage, img.Color.fromRgba(255, 255, 255, 255));
    img.Image newImage = img.drawImage(wImage, mImage,
        dstX: qrSize + qrPadding * 2,
        dstY: qrSize + qrPadding * 2,
        dstW: wImage.width - 2 * (qrSize + 2 * qrPadding),
        dstH: wImage.height - 2 * (qrSize + 2 * qrPadding));
    int remw = ((wImage.width - qrSize - qrPadding * 2) % (qrSize + wd)) ~/
        ((wImage.width - qrSize - qrPadding * 2) / (qrSize + wd));
    int remh =
        (qrSize + (wImage.height - (qrSize + qrPadding) * 2) % (qrSize + wd)) ~/
            ((wImage.height - (qrSize + qrPadding) * 2) / (qrSize + wd));
    for (int i = qrPadding;
        i < wImage.width - qrSize * 2;
        i += qrSize + wd + remw) {
      drawBarcode(newImage, Barcode.qrCode(), encryptedQRData,
          x: i,
          y: qrPadding,
          width: qrSize,
          height: qrSize,
          color: img.Color.fromRgba(0, 0, 0, qrOpacity));
    }
    drawBarcode(newImage, Barcode.qrCode(), encryptedQRData,
        x: wImage.width - qrSize - qrPadding,
        y: qrPadding,
        width: qrSize,
        height: qrSize,
        color: img.Color.fromRgba(0, 0, 0, qrOpacity));
    for (int i = qrPadding;
        i < wImage.width - qrSize * 2 - wd;
        i += qrSize + wd + remw) {
      drawBarcode(newImage, Barcode.qrCode(), encryptedQRData,
          x: i,
          y: wImage.height - qrSize - qrPadding,
          width: qrSize,
          height: qrSize,
          color: img.Color.fromRgba(0, 0, 0, qrOpacity));
    }
    drawBarcode(newImage, Barcode.qrCode(), encryptedQRData,
        x: wImage.width - qrSize - qrPadding,
        y: wImage.height - qrSize - qrPadding,
        width: qrSize,
        height: qrSize,
        color: img.Color.fromRgba(0, 0, 0, qrOpacity));
    for (int i = qrSize + qrPadding + wd;
        i < wImage.height - qrSize * 2 - wd;
        i += qrSize + wd + remh) {
      drawBarcode(newImage, Barcode.qrCode(), encryptedQRData,
          x: qrPadding,
          y: i,
          width: qrSize,
          height: qrSize,
          color: img.Color.fromRgba(0, 0, 0, qrOpacity));
      drawBarcode(newImage, Barcode.qrCode(), encryptedQRData,
          x: wImage.width - qrSize - qrPadding,
          y: i,
          width: qrSize,
          height: qrSize,
          color: img.Color.fromRgba(0, 0, 0, qrOpacity));
    }
    return newImage;
  }
}
