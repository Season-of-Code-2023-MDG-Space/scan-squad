import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureData {
  Future<String> encryptData(String inputData) async {
    final ekey = Key.fromSecureRandom(16);
    final iv = IV.fromUtf8(ekey.base64.substring(0, 16));
    final encrypter = Encrypter(AES(ekey, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(inputData, iv: iv);
    const storage = FlutterSecureStorage();
    await storage.write(key: encrypted.base64, value: ekey.base64);
    return encrypted.base64;
  }

  Future<String?> decryptData(String encryptedData) async {
    Encrypted stringToDecrypt = Encrypted.fromBase64(encryptedData);
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: encryptedData);
    if (value != null) {
      final dkey = Key.fromBase64(value);
      final iv = IV.fromUtf8(dkey.base64.substring(0, 16));
      final encrypter = Encrypter(AES(dkey, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt(stringToDecrypt, iv: iv);
      return decrypted;
    } else {
      return null;
    }
  }
}
