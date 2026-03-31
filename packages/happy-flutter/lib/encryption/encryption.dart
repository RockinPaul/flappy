import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import 'derive_key.dart';
import 'encoding.dart';
import 'encryption_cache.dart';
import 'encryptor.dart';
import 'libsodium.dart';

/// Main encryption manager.
///
/// Derives content keys from a master secret and manages per-session
/// and per-machine encryption instances. Must be byte-compatible with
/// the TypeScript implementation in packages/happy-app/sources/sync/encryption/.
class Encryption {
  /// Create an [Encryption] instance from a master secret.
  ///
  /// Derives:
  /// - contentDataKey (for opening session/machine records)
  /// - contentKeyPair (Box keypair from contentDataKey)
  /// - anonID (first 16 hex chars of a derived analytics key)
  static Future<Encryption> create(Uint8List masterSecret) async {
    // Derive content data key to open session and machine records
    final contentDataKey = await deriveKey(
      masterSecret,
      'Happy EnCoder',
      ['content'],
    );

    // Derive content data key keypair
    final contentKeyPair = boxSeedKeypair(contentDataKey);

    // Derive anonymous ID
    final analyticsKey = await deriveKey(
      masterSecret,
      'Happy Coder',
      ['analytics', 'id'],
    );
    final anonID = encodeHex(analyticsKey).substring(0, 16).toLowerCase();

    return Encryption._(anonID, masterSecret, contentKeyPair);
  }

  // Private fields
  final SecretBoxEncryption _legacyEncryption;
  final BoxKeyPair _contentKeyPair;
  final Map<String, SessionEncryptionEntry> _sessionEncryptions = {};
  final Map<String, MachineEncryptionEntry> _machineEncryptions = {};
  final EncryptionCache _cache;

  /// Anonymous analytics identifier (16 hex chars).
  final String anonID;

  /// The public key portion of the content keypair.
  final Uint8List contentDataKey;

  Encryption._(this.anonID, Uint8List masterSecret, this._contentKeyPair)
      : _legacyEncryption = SecretBoxEncryption(masterSecret),
        contentDataKey = _contentKeyPair.publicKey,
        _cache = EncryptionCache();

  // ---------------------------------------------------------------------------
  // Core encryption opening
  // ---------------------------------------------------------------------------

  /// Open an encryptor/decryptor for the given data encryption key.
  ///
  /// If [dataEncryptionKey] is null, falls back to legacy SecretBox encryption.
  /// Otherwise returns an AES-256-GCM encryptor.
  Future<EncryptorDecryptor> openEncryption(
    Uint8List? dataEncryptionKey,
  ) async {
    if (dataEncryptionKey == null) {
      return _legacyEncryption;
    }
    return AES256Encryption(dataEncryptionKey);
  }

  // ---------------------------------------------------------------------------
  // Session operations
  // ---------------------------------------------------------------------------

  /// Initialize sessions with their encryption keys.
  ///
  /// Should be called once when sessions are loaded. Sessions that are already
  /// initialized are skipped.
  Future<void> initializeSessions(Map<String, Uint8List?> sessions) async {
    for (final entry in sessions.entries) {
      final sessionId = entry.key;
      final dataKey = entry.value;

      // Skip if already initialized
      if (_sessionEncryptions.containsKey(sessionId)) {
        continue;
      }

      final encryptor = await openEncryption(dataKey);
      _sessionEncryptions[sessionId] = SessionEncryptionEntry(
        sessionId: sessionId,
        encryptor: encryptor,
        cache: _cache,
      );
    }
  }

  /// Get session encryption if it has been initialized.
  ///
  /// Returns null if not initialized (should never happen in normal flow).
  SessionEncryptionEntry? getSessionEncryption(String sessionId) {
    return _sessionEncryptions[sessionId];
  }

  /// Remove session encryption from memory when a session is deleted.
  void removeSessionEncryption(String sessionId) {
    _sessionEncryptions.remove(sessionId);
    _cache.clearSessionCache(sessionId);
  }

  // ---------------------------------------------------------------------------
  // Machine operations
  // ---------------------------------------------------------------------------

  /// Initialize machines with their encryption keys.
  ///
  /// Should be called once when machines are loaded. Machines that are already
  /// initialized are skipped.
  Future<void> initializeMachines(Map<String, Uint8List?> machines) async {
    for (final entry in machines.entries) {
      final machineId = entry.key;
      final dataKey = entry.value;

      // Skip if already initialized
      if (_machineEncryptions.containsKey(machineId)) {
        continue;
      }

      final encryptor = await openEncryption(dataKey);
      _machineEncryptions[machineId] = MachineEncryptionEntry(
        machineId: machineId,
        encryptor: encryptor,
        cache: _cache,
      );
    }
  }

  /// Get machine encryption if it has been initialized.
  ///
  /// Returns null if not initialized (should never happen in normal flow).
  MachineEncryptionEntry? getMachineEncryption(String machineId) {
    return _machineEncryptions[machineId];
  }

  // ---------------------------------------------------------------------------
  // Legacy raw encrypt/decrypt
  // ---------------------------------------------------------------------------

  /// Encrypt data using legacy SecretBox encryption. Returns base64.
  Future<String> encryptRaw(dynamic data) async {
    final encrypted = await _legacyEncryption.encrypt([data]);
    return encodeBase64(encrypted[0]);
  }

  /// Decrypt base64-encoded data using legacy SecretBox encryption.
  Future<dynamic> decryptRaw(String encrypted) async {
    try {
      final encryptedData = decodeBase64(encrypted);
      final decrypted = await _legacyEncryption.decrypt([encryptedData]);
      return decrypted[0];
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Data Encryption Key encrypt/decrypt
  // ---------------------------------------------------------------------------

  /// Decrypt an encryption key that was encrypted with our content public key.
  ///
  /// Expected format: [0x00 version byte] + Box-encrypted key.
  /// Returns the raw key bytes, or null on failure.
  Future<Uint8List?> decryptEncryptionKey(String encrypted) async {
    final encryptedKey = decodeBase64(encrypted);
    if (encryptedKey.isEmpty || encryptedKey[0] != 0) {
      return null;
    }

    final decrypted = decryptBox(
      Uint8List.sublistView(encryptedKey, 1),
      _contentKeyPair.privateKey,
    );
    return decrypted;
  }

  /// Encrypt a data encryption key using our content public key.
  ///
  /// Returns: [0x00 version byte] + Box-encrypted key.
  Future<Uint8List> encryptEncryptionKey(Uint8List key) async {
    final encrypted = encryptBox(key, _contentKeyPair.publicKey);
    final result = Uint8List(encrypted.length + 1);
    result[0] = 0x00; // Version byte
    result.setRange(1, result.length, encrypted);
    return result;
  }

  /// Generate a new random UUID.
  String generateId() {
    return const Uuid().v4();
  }
}

// ---------------------------------------------------------------------------
// Session encryption wrapper (mirrors SessionEncryption.ts)
// ---------------------------------------------------------------------------

class SessionEncryptionEntry {
  final String sessionId;
  final EncryptorDecryptor encryptor;
  final EncryptionCache cache;

  SessionEncryptionEntry({
    required this.sessionId,
    required this.encryptor,
    required this.cache,
  });

  /// Encrypt raw data and return base64.
  Future<String> encryptRaw(dynamic data) async {
    final encrypted = await encryptor.encrypt([data]);
    return encodeBase64(encrypted[0]);
  }

  /// Decrypt base64-encoded data.
  Future<dynamic> decryptRaw(String encrypted) async {
    try {
      final encryptedData = decodeBase64(encrypted);
      final decrypted = await encryptor.decrypt([encryptedData]);
      return decrypted[0];
    } catch (_) {
      return null;
    }
  }

  /// Encrypt metadata and return base64.
  Future<String> encryptMetadata(Map<String, dynamic> metadata) async {
    final encrypted = await encryptor.encrypt([metadata]);
    return encodeBase64(encrypted[0]);
  }

  /// Decrypt metadata with caching.
  Future<Map<String, dynamic>?> decryptMetadata(
    int version,
    String encrypted,
  ) async {
    // Check cache first
    final cached = cache.getCachedMetadata(sessionId, version);
    if (cached != null) {
      return cached;
    }

    final encryptedData = decodeBase64(encrypted);
    final decrypted = await encryptor.decrypt([encryptedData]);
    if (decrypted[0] == null) {
      return null;
    }
    final parsed = decrypted[0] as Map<String, dynamic>;

    cache.setCachedMetadata(sessionId, version, parsed);
    return parsed;
  }

  /// Encrypt agent state and return base64.
  Future<String> encryptAgentState(Map<String, dynamic> state) async {
    final encrypted = await encryptor.encrypt([state]);
    return encodeBase64(encrypted[0]);
  }

  /// Decrypt agent state with caching.
  Future<Map<String, dynamic>> decryptAgentState(
    int version,
    String? encrypted,
  ) async {
    if (encrypted == null) {
      return {};
    }

    // Check cache first
    final cached = cache.getCachedAgentState(sessionId, version);
    if (cached != null) {
      return cached;
    }

    final encryptedData = decodeBase64(encrypted);
    final decrypted = await encryptor.decrypt([encryptedData]);
    if (decrypted[0] == null) {
      return {};
    }
    final parsed = decrypted[0] as Map<String, dynamic>;

    cache.setCachedAgentState(sessionId, version, parsed);
    return parsed;
  }
}

// ---------------------------------------------------------------------------
// Machine encryption wrapper (mirrors MachineEncryption.ts)
// ---------------------------------------------------------------------------

class MachineEncryptionEntry {
  final String machineId;
  final EncryptorDecryptor encryptor;
  final EncryptionCache cache;

  MachineEncryptionEntry({
    required this.machineId,
    required this.encryptor,
    required this.cache,
  });

  /// Encrypt machine metadata and return base64.
  Future<String> encryptMetadata(Map<String, dynamic> metadata) async {
    final encrypted = await encryptor.encrypt([metadata]);
    return encodeBase64(encrypted[0]);
  }

  /// Decrypt machine metadata with caching.
  Future<Map<String, dynamic>?> decryptMetadata(
    int version,
    String encrypted,
  ) async {
    // Check cache first
    final cached = cache.getCachedMachineMetadata(machineId, version);
    if (cached != null) {
      return cached;
    }

    try {
      final encryptedData = decodeBase64(encrypted);
      final decrypted = await encryptor.decrypt([encryptedData]);
      if (decrypted[0] == null) {
        return null;
      }
      final parsed = decrypted[0] as Map<String, dynamic>;

      cache.setCachedMachineMetadata(machineId, version, parsed);
      return parsed;
    } catch (_) {
      return null;
    }
  }

  /// Encrypt daemon state and return base64.
  Future<String> encryptDaemonState(dynamic state) async {
    final encrypted = await encryptor.encrypt([state]);
    return encodeBase64(encrypted[0]);
  }

  /// Decrypt daemon state with caching.
  Future<dynamic> decryptDaemonState(int version, String? encrypted) async {
    if (encrypted == null) {
      return null;
    }

    // Check cache first
    final cached = cache.getCachedDaemonState(machineId, version);
    if (cached is! CacheSentinel) {
      return cached;
    }

    try {
      final encryptedData = decodeBase64(encrypted);
      final decrypted = await encryptor.decrypt([encryptedData]);
      final result = decrypted[0];

      // Cache the result (including null values)
      cache.setCachedDaemonState(machineId, version, result);
      return result;
    } catch (_) {
      // Cache null result to avoid repeated decryption attempts
      cache.setCachedDaemonState(machineId, version, null);
      return null;
    }
  }

  /// Encrypt raw data and return base64.
  Future<String> encryptRaw(dynamic data) async {
    final encrypted = await encryptor.encrypt([data]);
    return encodeBase64(encrypted[0]);
  }

  /// Decrypt base64-encoded raw data.
  Future<dynamic> decryptRaw(String encrypted) async {
    try {
      final encryptedData = decodeBase64(encrypted);
      final decrypted = await encryptor.decrypt([encryptedData]);
      return decrypted[0];
    } catch (_) {
      return null;
    }
  }
}

