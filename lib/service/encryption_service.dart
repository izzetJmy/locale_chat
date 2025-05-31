import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const String _keyName = 'encryption_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late encrypt.Key _key;
  final encrypt.IV _iv = encrypt.IV.fromLength(16);

  Future<void> init() async {
    String? storedKey = await _secureStorage.read(key: _keyName);
    if (storedKey == null) {
      final newKey = encrypt.Key.fromSecureRandom(32);
      await _secureStorage.write(key: _keyName, value: newKey.base64);
      _key = newKey;
    } else {
      _key = encrypt.Key.fromBase64(storedKey);
    }
  }

  String encryptText(String text) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    return encrypter.encrypt(text, iv: _iv).base64;
  }

  String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    return encrypter.decrypt64(encryptedText, iv: _iv);
  }
}
