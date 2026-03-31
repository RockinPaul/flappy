import 'dart:typed_data';

import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/api.dart';

/// Compute HMAC-SHA512 of [data] with the given [key].
Future<Uint8List> hmacSha512(Uint8List key, Uint8List data) async {
  final hmac = HMac(SHA512Digest(), 128);
  hmac.init(KeyParameter(key));
  return hmac.process(data);
}
