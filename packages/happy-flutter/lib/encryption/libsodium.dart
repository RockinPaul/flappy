import 'package:pinenacl/tweetnacl.dart';
import 'package:pinenacl/x25519.dart';

/// NaCl constants.
const int _publicKeyBytes = 32;
const int _nonceBytes = 24;

/// Generate a random nonce of [length] bytes.
Uint8List _randomBytes(int length) {
  return Uint8List.fromList(TweetNaCl.randombytes(length));
}

/// Get the public key for a Box keypair derived from [secretKey] (seed).
Uint8List getPublicKeyForBox(Uint8List secretKey) {
  final privateKey = PrivateKey.fromSeed(secretKey);
  return Uint8List.fromList(privateKey.publicKey);
}

/// Generate an ephemeral keypair for Box encryption.
PrivateKey _generateEphemeralKey() {
  final seed = _randomBytes(32);
  return PrivateKey.fromSeed(seed);
}

/// Encrypt [data] to [recipientPublicKey] using NaCl Box (asymmetric).
///
/// Returns: ephemeralPublicKey(32) + nonce(24) + ciphertext
/// This format is byte-compatible with the TypeScript implementation.
Uint8List encryptBox(Uint8List data, Uint8List recipientPublicKey) {
  final ephemeralKey = _generateEphemeralKey();
  final nonce = _randomBytes(_nonceBytes);

  final box = Box(
    myPrivateKey: ephemeralKey,
    theirPublicKey: PublicKey(recipientPublicKey),
  );

  final encrypted = box.encrypt(data, nonce: nonce);
  // encrypted.cipherText includes the MAC + ciphertext (no nonce prefix from pinenacl
  // when we pass our own nonce via the encrypt call)
  final ciphertext = Uint8List.fromList(encrypted.cipherText);

  // Bundle: ephemeralPubKey(32) + nonce(24) + ciphertext
  final result =
      Uint8List(ephemeralKey.publicKey.length + nonce.length + ciphertext.length);
  result.setRange(0, _publicKeyBytes, ephemeralKey.publicKey);
  result.setRange(_publicKeyBytes, _publicKeyBytes + _nonceBytes, nonce);
  result.setRange(
    _publicKeyBytes + _nonceBytes,
    result.length,
    ciphertext,
  );

  return result;
}

/// Decrypt a box bundle encrypted with [encryptBox] using [recipientSecretKey].
///
/// Bundle format: ephemeralPublicKey(32) + nonce(24) + ciphertext
/// Returns the plaintext or null on failure.
Uint8List? decryptBox(Uint8List encryptedBundle, Uint8List recipientSecretKey) {
  if (encryptedBundle.length < _publicKeyBytes + _nonceBytes + 1) {
    return null;
  }

  try {
    final ephemeralPublicKey =
        Uint8List.sublistView(encryptedBundle, 0, _publicKeyBytes);
    final nonce = Uint8List.sublistView(
      encryptedBundle,
      _publicKeyBytes,
      _publicKeyBytes + _nonceBytes,
    );
    final ciphertext = Uint8List.sublistView(
      encryptedBundle,
      _publicKeyBytes + _nonceBytes,
    );

    final privateKey = PrivateKey.fromSeed(recipientSecretKey);
    final box = Box(
      myPrivateKey: privateKey,
      theirPublicKey: PublicKey(ephemeralPublicKey),
    );

    final decrypted = box.decrypt(
      ByteList(ciphertext),
      nonce: nonce,
    );
    return Uint8List.fromList(decrypted);
  } catch (_) {
    return null;
  }
}

/// Encrypt [data] using NaCl SecretBox (symmetric).
///
/// [data] is JSON-serialized first, matching the TypeScript implementation.
/// Returns: nonce(24) + ciphertext
Uint8List encryptSecretBox(Uint8List jsonData, Uint8List secret) {
  final nonce = _randomBytes(_nonceBytes);
  final secretBox = SecretBox(secret);
  final encrypted = secretBox.encrypt(jsonData, nonce: nonce);
  final ciphertext = Uint8List.fromList(encrypted.cipherText);

  // Bundle: nonce(24) + ciphertext
  final result = Uint8List(nonce.length + ciphertext.length);
  result.setRange(0, _nonceBytes, nonce);
  result.setRange(_nonceBytes, result.length, ciphertext);
  return result;
}

/// Decrypt a SecretBox bundle encrypted with [encryptSecretBox].
///
/// Bundle format: nonce(24) + ciphertext
/// Returns the decrypted bytes or null on failure.
Uint8List? decryptSecretBox(Uint8List data, Uint8List secret) {
  if (data.length < _nonceBytes + 1) {
    return null;
  }

  try {
    final nonce = Uint8List.sublistView(data, 0, _nonceBytes);
    final ciphertext = Uint8List.sublistView(data, _nonceBytes);

    final secretBox = SecretBox(secret);
    final decrypted = secretBox.decrypt(
      ByteList(ciphertext),
      nonce: nonce,
    );
    return Uint8List.fromList(decrypted);
  } catch (_) {
    return null;
  }
}

/// A keypair holder for Box operations (matches sodium.KeyPair).
class BoxKeyPair {
  final Uint8List publicKey;
  final Uint8List privateKey;

  const BoxKeyPair({required this.publicKey, required this.privateKey});
}

/// Generate a Box keypair from a seed (matches crypto_box_seed_keypair).
BoxKeyPair boxSeedKeypair(Uint8List seed) {
  final privateKey = PrivateKey.fromSeed(seed);
  return BoxKeyPair(
    publicKey: Uint8List.fromList(privateKey.publicKey),
    privateKey: seed,
  );
}
