import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EncryptionService {
  static const _keyName = 'flo_hive_encryption_key';
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Returns a HiveCipher backed by AES-256.
  /// Key is generated once, then persisted in Android Keystore / iOS Keychain.
  static Future<HiveCipher> getEncryptionCipher() async {
    String? existingKey = await _secureStorage.read(key: _keyName);

    if (existingKey == null) {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _keyName,
        value: base64UrlEncode(key),
      );
      return HiveAesCipher(key);
    }

    final key = base64Url.decode(existingKey);
    return HiveAesCipher(key);
  }
}
