/// A single LRU cache entry with access time tracking.
class _CacheEntry<T> {
  T data;
  int accessTime;

  _CacheEntry({required this.data, required this.accessTime});
}

/// In-memory LRU cache for decrypted session/machine data to avoid
/// expensive re-decryption.
///
/// Uses sessionId + version (or machineId + version, messageId) as keys.
class EncryptionCache {
  final Map<String, _CacheEntry<Map<String, dynamic>>> _agentStateCache = {};
  final Map<String, _CacheEntry<Map<String, dynamic>>> _metadataCache = {};
  final Map<String, _CacheEntry<Map<String, dynamic>>> _messageCache = {};
  final Map<String, _CacheEntry<Map<String, dynamic>>> _machineMetadataCache =
      {};
  final Map<String, _CacheEntry<dynamic>> _daemonStateCache = {};

  // Configuration
  final int _maxAgentStates = 1000;
  final int _maxMetadata = 1000;
  final int _maxMessages = 1000;
  final int _maxMachineMetadata = 500;
  final int _maxDaemonStates = 500;

  // ---------- Agent state ----------

  Map<String, dynamic>? getCachedAgentState(String sessionId, int version) {
    final key = '$sessionId:$version';
    final entry = _agentStateCache[key];
    if (entry != null) {
      entry.accessTime = DateTime.now().millisecondsSinceEpoch;
      return entry.data;
    }
    return null;
  }

  void setCachedAgentState(
    String sessionId,
    int version,
    Map<String, dynamic> data,
  ) {
    final key = '$sessionId:$version';
    _agentStateCache[key] = _CacheEntry(
      data: data,
      accessTime: DateTime.now().millisecondsSinceEpoch,
    );
    _evictOldest(_agentStateCache, _maxAgentStates);
  }

  // ---------- Metadata ----------

  Map<String, dynamic>? getCachedMetadata(String sessionId, int version) {
    final key = '$sessionId:$version';
    final entry = _metadataCache[key];
    if (entry != null) {
      entry.accessTime = DateTime.now().millisecondsSinceEpoch;
      return entry.data;
    }
    return null;
  }

  void setCachedMetadata(
    String sessionId,
    int version,
    Map<String, dynamic> data,
  ) {
    final key = '$sessionId:$version';
    _metadataCache[key] = _CacheEntry(
      data: data,
      accessTime: DateTime.now().millisecondsSinceEpoch,
    );
    _evictOldest(_metadataCache, _maxMetadata);
  }

  // ---------- Messages ----------

  Map<String, dynamic>? getCachedMessage(String messageId) {
    final entry = _messageCache[messageId];
    if (entry != null) {
      entry.accessTime = DateTime.now().millisecondsSinceEpoch;
      return entry.data;
    }
    return null;
  }

  void setCachedMessage(String messageId, Map<String, dynamic> data) {
    _messageCache[messageId] = _CacheEntry(
      data: data,
      accessTime: DateTime.now().millisecondsSinceEpoch,
    );
    _evictOldest(_messageCache, _maxMessages);
  }

  // ---------- Machine metadata ----------

  Map<String, dynamic>? getCachedMachineMetadata(
    String machineId,
    int version,
  ) {
    final key = '$machineId:$version';
    final entry = _machineMetadataCache[key];
    if (entry != null) {
      entry.accessTime = DateTime.now().millisecondsSinceEpoch;
      return entry.data;
    }
    return null;
  }

  void setCachedMachineMetadata(
    String machineId,
    int version,
    Map<String, dynamic> data,
  ) {
    final key = '$machineId:$version';
    _machineMetadataCache[key] = _CacheEntry(
      data: data,
      accessTime: DateTime.now().millisecondsSinceEpoch,
    );
    _evictOldest(_machineMetadataCache, _maxMachineMetadata);
  }

  // ---------- Daemon state ----------

  /// Returns the cached value, or [_sentinel] if not found.
  /// Use [hasCachedDaemonState] to distinguish null values from missing entries.
  dynamic getCachedDaemonState(String machineId, int version) {
    final key = '$machineId:$version';
    final entry = _daemonStateCache[key];
    if (entry != null) {
      entry.accessTime = DateTime.now().millisecondsSinceEpoch;
      return entry.data;
    }
    return cacheSentinel;
  }

  void setCachedDaemonState(String machineId, int version, dynamic data) {
    final key = '$machineId:$version';
    _daemonStateCache[key] = _CacheEntry(
      data: data,
      accessTime: DateTime.now().millisecondsSinceEpoch,
    );
    _evictOldest(_daemonStateCache, _maxDaemonStates);
  }

  // ---------- Clear ----------

  /// Clear all cache entries for a specific session.
  void clearSessionCache(String sessionId) {
    _agentStateCache.removeWhere((key, _) => key.startsWith('$sessionId:'));
    _metadataCache.removeWhere((key, _) => key.startsWith('$sessionId:'));
    // Messages are immutable and session-agnostic, so not cleared here.
  }

  /// Clear all cache entries for a specific machine.
  void clearMachineCache(String machineId) {
    _machineMetadataCache
        .removeWhere((key, _) => key.startsWith('$machineId:'));
    _daemonStateCache.removeWhere((key, _) => key.startsWith('$machineId:'));
  }

  /// Clear all cached data.
  void clearAll() {
    _agentStateCache.clear();
    _metadataCache.clear();
    _messageCache.clear();
    _machineMetadataCache.clear();
    _daemonStateCache.clear();
  }

  /// Get cache statistics for debugging.
  Map<String, int> getStats() {
    return {
      'agentStates': _agentStateCache.length,
      'metadata': _metadataCache.length,
      'messages': _messageCache.length,
      'machineMetadata': _machineMetadataCache.length,
      'daemonStates': _daemonStateCache.length,
      'totalEntries': _agentStateCache.length +
          _metadataCache.length +
          _messageCache.length +
          _machineMetadataCache.length +
          _daemonStateCache.length,
    };
  }

  // ---------- Internal ----------

  /// Evict the oldest entry (by accessTime) when the cache exceeds [maxSize].
  void _evictOldest<T>(Map<String, _CacheEntry<T>> cache, int maxSize) {
    if (cache.length <= maxSize) return;

    String? oldestKey;
    int oldestTime = double.maxFinite.toInt();

    for (final entry in cache.entries) {
      if (entry.value.accessTime < oldestTime) {
        oldestTime = entry.value.accessTime;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      cache.remove(oldestKey);
    }
  }
}

/// Sentinel value to distinguish "not found" from "cached null".
const cacheSentinel = CacheSentinel();

class CacheSentinel {
  const CacheSentinel();
}
