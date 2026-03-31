import 'dart:convert' as convert;
import 'dart:typed_data';

import 'aes.dart';
import 'encoding.dart';
import 'libsodium.dart';

/// Interface for encrypting a batch of values.
abstract class Encryptor {
  Future<List<Uint8List>> encrypt(List<dynamic> data);
}

/// Interface for decrypting a batch of encrypted values.
abstract class Decryptor {
  Future<List<dynamic>> decrypt(List<Uint8List> data);
}

/// A type that implements both [Encryptor] and [Decryptor].
abstract class EncryptorDecryptor implements Encryptor, Decryptor {}

/// SecretBox (NaCl symmetric) encryption/decryption.
///
/// Data is JSON-serialized before encryption.
/// Bundle format: nonce(24) + ciphertext (byte-compatible with TypeScript).
class SecretBoxEncryption implements EncryptorDecryptor {
  final Uint8List _secretKey;

  SecretBoxEncryption(this._secretKey);

  @override
  Future<List<Uint8List>> encrypt(List<dynamic> data) async {
    final results = <Uint8List>[];
    for (final item in data) {
      final jsonBytes = encodeUtf8(convert.jsonEncode(item));
      results.add(encryptSecretBox(jsonBytes, _secretKey));
    }
    return results;
  }

  @override
  Future<List<dynamic>> decrypt(List<Uint8List> data) async {
    final results = <dynamic>[];
    for (final item in data) {
      final decrypted = decryptSecretBox(item, _secretKey);
      if (decrypted == null) {
        results.add(null);
      } else {
        results.add(convert.jsonDecode(decodeUtf8(decrypted)));
      }
    }
    return results;
  }
}

/// Box (NaCl asymmetric) encryption/decryption.
///
/// Uses a seed to derive a keypair. Data is JSON-serialized before encryption.
/// Bundle format: ephemeralPubKey(32) + nonce(24) + ciphertext.
class BoxEncryption implements EncryptorDecryptor {
  final Uint8List _publicKey;
  final Uint8List _privateKey;

  BoxEncryption(Uint8List seed)
      : _publicKey = boxSeedKeypair(seed).publicKey,
        _privateKey = seed;

  @override
  Future<List<Uint8List>> encrypt(List<dynamic> data) async {
    final results = <Uint8List>[];
    for (final item in data) {
      final jsonBytes = encodeUtf8(convert.jsonEncode(item));
      results.add(encryptBox(jsonBytes, _publicKey));
    }
    return results;
  }

  @override
  Future<List<dynamic>> decrypt(List<Uint8List> data) async {
    final results = <dynamic>[];
    for (final item in data) {
      final decrypted = decryptBox(item, _privateKey);
      if (decrypted == null) {
        results.add(null);
      } else {
        results.add(convert.jsonDecode(decodeUtf8(decrypted)));
      }
    }
    return results;
  }
}

/// AES-256-GCM encryption/decryption.
///
/// Prepends a 0x00 version byte before the AES ciphertext.
/// encrypt: [0x00] + aesEncrypt(json)
/// decrypt: check first byte is 0x00, then aesDecrypt(rest)
class AES256Encryption implements EncryptorDecryptor {
  final Uint8List _secretKey; // ignore: unused_field
  final String _secretKeyB64;

  AES256Encryption(this._secretKey)
      : _secretKeyB64 = encodeBase64(_secretKey);

  @override
  Future<List<Uint8List>> encrypt(List<dynamic> data) async {
    final results = <Uint8List>[];
    for (final item in data) {
      final jsonString = convert.jsonEncode(item);
      final encrypted = encryptAesGcmString(jsonString, _secretKeyB64);
      final encryptedBytes = decodeBase64(encrypted);
      // Prepend version byte 0x00
      final output = Uint8List(encryptedBytes.length + 1);
      output[0] = 0x00;
      output.setRange(1, output.length, encryptedBytes);
      results.add(output);
    }
    return results;
  }

  @override
  Future<List<dynamic>> decrypt(List<Uint8List> data) async {
    final results = <dynamic>[];
    for (final item in data) {
      try {
        if (item[0] != 0x00) {
          results.add(null);
          continue;
        }
        final ciphertext = Uint8List.sublistView(item, 1);
        final decryptedString = decryptAesGcmString(
          encodeBase64(ciphertext),
          _secretKeyB64,
        );
        if (decryptedString == null) {
          results.add(null);
        } else {
          results.add(convert.jsonDecode(decryptedString));
        }
      } catch (_) {
        results.add(null);
      }
    }
    return results;
  }
}
