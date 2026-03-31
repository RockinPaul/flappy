import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import 'encoding.dart';

/// AES-256-GCM IV size in bytes.
const int _ivLength = 12;

/// AES-256-GCM tag size in bytes.
const int _tagLength = 16;

final Random _secureRandom = Random.secure();

Uint8List _generateIv() {
  final iv = Uint8List(_ivLength);
  for (int i = 0; i < _ivLength; i++) {
    iv[i] = _secureRandom.nextInt(256);
  }
  return iv;
}

/// Encrypt [data] with AES-256-GCM using [key] (32 bytes).
///
/// Returns: IV(12) + ciphertext + tag(16)
Uint8List encryptAesGcm(Uint8List data, Uint8List key) {
  final iv = _generateIv();

  final cipher = GCMBlockCipher(AESEngine());
  cipher.init(
    true,
    AEADParameters(
      KeyParameter(key),
      _tagLength * 8,
      iv,
      Uint8List(0),
    ),
  );

  final output = Uint8List(cipher.getOutputSize(data.length));
  final len = cipher.processBytes(data, 0, data.length, output, 0);
  cipher.doFinal(output, len);

  // Bundle: IV + ciphertext + tag (pointycastle appends tag to output)
  final result = Uint8List(iv.length + output.length);
  result.setRange(0, _ivLength, iv);
  result.setRange(_ivLength, result.length, output);
  return result;
}

/// Decrypt [data] with AES-256-GCM using [key] (32 bytes).
///
/// [data] format: IV(12) + ciphertext + tag(16)
/// Returns the plaintext or null on failure.
Uint8List? decryptAesGcm(Uint8List data, Uint8List key) {
  if (data.length < _ivLength + _tagLength) {
    return null;
  }

  try {
    final iv = Uint8List.sublistView(data, 0, _ivLength);
    final ciphertextWithTag = Uint8List.sublistView(data, _ivLength);

    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      false,
      AEADParameters(
        KeyParameter(key),
        _tagLength * 8,
        iv,
        Uint8List(0),
      ),
    );

    final output = Uint8List(cipher.getOutputSize(ciphertextWithTag.length));
    final len = cipher.processBytes(
      ciphertextWithTag,
      0,
      ciphertextWithTag.length,
      output,
      0,
    );
    cipher.doFinal(output, len);

    // The output may be padded; trim to actual plaintext length
    final plaintextLength = output.length;
    return Uint8List.sublistView(output, 0, plaintextLength);
  } catch (_) {
    return null;
  }
}

/// Encrypt a string with AES-256-GCM. Key and result are base64-encoded.
String encryptAesGcmString(String data, String key64) {
  final key = decodeBase64(key64);
  final dataBytes = encodeUtf8(data);
  final encrypted = encryptAesGcm(dataBytes, key);
  return encodeBase64(encrypted);
}

/// Decrypt a base64-encoded AES-256-GCM ciphertext. Key is base64-encoded.
/// Returns the plaintext string or null on failure.
String? decryptAesGcmString(String data, String key64) {
  try {
    final key = decodeBase64(key64);
    final dataBytes = decodeBase64(data);
    final decrypted = decryptAesGcm(dataBytes, key);
    if (decrypted == null) return null;
    return decodeUtf8(decrypted);
  } catch (_) {
    return null;
  }
}
