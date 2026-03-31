import 'dart:typed_data';

import 'encoding.dart';
import 'hmac_sha512.dart';

/// Holds a derived key and chain code from the HD key tree.
class KeyTreeState {
  final Uint8List key;
  final Uint8List chainCode;

  const KeyTreeState({required this.key, required this.chainCode});
}

/// Derive the root of the secret key tree from a seed and usage string.
///
/// I = HMAC-SHA512(utf8(usage + " Master Seed"), seed)
/// key = I[0..32], chainCode = I[32..64]
Future<KeyTreeState> deriveSecretKeyTreeRoot(
  Uint8List seed,
  String usage,
) async {
  final hmacKey = encodeUtf8('$usage Master Seed');
  final i = await hmacSha512(hmacKey, seed);
  return KeyTreeState(
    key: Uint8List.sublistView(i, 0, 32),
    chainCode: Uint8List.sublistView(i, 32),
  );
}

/// Derive a child key from a parent chain code and an index string.
///
/// data = [0x00] + utf8(index)
/// I = HMAC-SHA512(chainCode, data)
/// key = I[0..32], chainCode = I[32..64]
Future<KeyTreeState> deriveSecretKeyTreeChild(
  Uint8List chainCode,
  String index,
) async {
  final indexBytes = encodeUtf8(index);
  final data = Uint8List(1 + indexBytes.length);
  data[0] = 0x00;
  data.setRange(1, data.length, indexBytes);

  final i = await hmacSha512(chainCode, data);
  return KeyTreeState(
    key: Uint8List.sublistView(i, 0, 32),
    chainCode: Uint8List.sublistView(i, 32),
  );
}

/// Walk the HD key tree: root -> child -> child -> ... and return the final key.
Future<Uint8List> deriveKey(
  Uint8List master,
  String usage,
  List<String> path,
) async {
  var state = await deriveSecretKeyTreeRoot(master, usage);
  for (final index in path) {
    state = await deriveSecretKeyTreeChild(state.chainCode, index);
  }
  return state.key;
}
