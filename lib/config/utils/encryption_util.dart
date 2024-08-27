import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionUtil {
  final _secureStorage = FlutterSecureStorage();
  final _keyStorageKey = 'encryption_key';

  Future<Encrypter> _getEncrypter() async {
    String? storedKey = await _secureStorage.read(key: _keyStorageKey);
    if (storedKey == null) {
      final key = Key.fromSecureRandom(32); // Clave de 256 bits
      await _secureStorage.write(key: _keyStorageKey, value: key.base64);
      storedKey = key.base64;
    }

    final key = Key.fromBase64(storedKey);
    final encrypter = Encrypter(AES(key));
    return encrypter;
  }

  Future<String> encrypt(String text) async {
    final encrypter = await _getEncrypter();
    final encrypted = encrypter.encrypt(text, iv: IV.fromLength(16));
    return encrypted.base64;
  }

  Future<String> decrypt(String encryptedText) async {
    final encrypter = await _getEncrypter();
    final decrypted = encrypter.decrypt64(encryptedText, iv: IV.fromLength(16));
    return decrypted;
  }
}
