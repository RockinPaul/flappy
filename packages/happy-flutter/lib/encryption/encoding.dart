import 'dart:convert' as convert;
import 'dart:typed_data';

/// Decode a base64 or base64url encoded string to bytes.
Uint8List decodeBase64(String base64, {bool urlSafe = false}) {
  String normalized = base64;

  if (urlSafe) {
    normalized = normalized.replaceAll('-', '+').replaceAll('_', '/');
    final padding = normalized.length % 4;
    if (padding != 0) {
      normalized += '=' * (4 - padding);
    }
  }

  return convert.base64.decode(normalized);
}

/// Encode bytes to a base64 or base64url string.
String encodeBase64(Uint8List buffer, {bool urlSafe = false}) {
  if (urlSafe) {
    return convert.base64Url.encode(buffer).replaceAll('=', '');
  }
  return convert.base64.encode(buffer);
}

/// Decode a hex string to bytes.
Uint8List decodeHex(String hexString) {
  final hex = hexString.replaceAll(':', '');
  if (hex.length % 2 != 0) {
    throw ArgumentError('Hex string must have even length');
  }
  final result = Uint8List(hex.length ~/ 2);
  for (int i = 0; i < result.length; i++) {
    result[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return result;
}

/// Encode bytes to a lowercase hex string.
String encodeHex(Uint8List buffer) {
  return buffer.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

/// Encode a UTF-8 string to bytes.
Uint8List encodeUtf8(String value) {
  return Uint8List.fromList(convert.utf8.encode(value));
}

/// Decode bytes to a UTF-8 string.
String decodeUtf8(Uint8List value) {
  return convert.utf8.decode(value);
}
