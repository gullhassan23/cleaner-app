import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;

/// AES-256-CBC with random IV prepended to ciphertext.
abstract final class VaultCrypto {
  static const int _ivLength = 16;

  static Uint8List encryptUtf8(String plain, enc.Key key) {
    final plainBytes = utf8.encode(plain);
    return encryptBytes(plainBytes, key);
  }

  static Uint8List encryptBytes(List<int> plain, enc.Key key) {
    final iv = enc.IV.fromSecureRandom(_ivLength);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(Uint8List.fromList(plain), iv: iv);
    final out = BytesBuilder(copy: false);
    out.add(iv.bytes);
    out.add(encrypted.bytes);
    return out.takeBytes();
  }

  static String decryptToUtf8(Uint8List data, enc.Key key) {
    final bytes = decryptToBytes(data, key);
    return utf8.decode(bytes);
  }

  static Uint8List decryptToBytes(Uint8List data, enc.Key key) {
    if (data.length <= _ivLength) {
      throw const FormatException('Vault index too short');
    }
    final iv = enc.IV(Uint8List.sublistView(data, 0, _ivLength));
    final cipherBytes = Uint8List.sublistView(data, _ivLength);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    return Uint8List.fromList(
      encrypter.decryptBytes(enc.Encrypted(cipherBytes), iv: iv),
    );
  }

  static enc.Key keyFromBase64(String b64) => enc.Key.fromBase64(b64);

  static String keyToBase64(enc.Key key) => key.base64;

  static enc.Key newAesKey() => enc.Key.fromSecureRandom(32);
}
