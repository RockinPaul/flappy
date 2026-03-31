/// Session, Machine, and related domain types.
///
/// Ported from packages/happy-app/sources/sync/storageTypes.ts
library;

// ---------------------------------------------------------------------------
// Helpers used by Metadata
// ---------------------------------------------------------------------------

class ModelOption {
  const ModelOption({
    required this.code,
    required this.value,
    this.description,
  });

  final String code;
  final String value;
  final String? description;

  factory ModelOption.fromJson(Map<String, dynamic> json) {
    return ModelOption(
      code: json['code'] as String,
      value: json['value'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'value': value,
        if (description != null) 'description': description,
      };
}

class SessionSummary {
  const SessionSummary({required this.text, required this.updatedAt});

  final String text;
  final int updatedAt;

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    return SessionSummary(
      text: json['text'] as String,
      updatedAt: (json['updatedAt'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'text': text, 'updatedAt': updatedAt};
}

// ---------------------------------------------------------------------------
// Metadata (ported from MetadataSchema)
// ---------------------------------------------------------------------------

class Metadata {
  const Metadata({
    this.models,
    this.currentModelCode,
    this.operatingModes,
    this.currentOperatingModeCode,
    this.thoughtLevels,
    this.currentThoughtLevelCode,
    required this.path,
    required this.host,
    this.version,
    this.name,
    this.os,
    this.summary,
    this.machineId,
    this.claudeSessionId,
    this.codexThreadId,
    this.tools,
    this.slashCommands,
    this.homeDir,
    this.happyHomeDir,
    this.hostPid,
    this.flavor,
    this.sandbox,
    this.dangerouslySkipPermissions,
    this.lifecycleState,
    this.lifecycleStateSince,
    this.archivedBy,
    this.archiveReason,
  });

  final List<ModelOption>? models;
  final String? currentModelCode;
  final List<ModelOption>? operatingModes;
  final String? currentOperatingModeCode;
  final List<ModelOption>? thoughtLevels;
  final String? currentThoughtLevelCode;
  final String path;
  final String host;
  final String? version;
  final String? name;
  final String? os;
  final SessionSummary? summary;
  final String? machineId;
  final String? claudeSessionId;
  final String? codexThreadId;
  final List<String>? tools;
  final List<String>? slashCommands;
  final String? homeDir;
  final String? happyHomeDir;
  final int? hostPid;
  final String? flavor;
  final dynamic sandbox;
  final bool? dangerouslySkipPermissions;
  final String? lifecycleState;
  final int? lifecycleStateSince;
  final String? archivedBy;
  final String? archiveReason;

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      models: (json['models'] as List<dynamic>?)
          ?.map((e) => ModelOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentModelCode: json['currentModelCode'] as String?,
      operatingModes: (json['operatingModes'] as List<dynamic>?)
          ?.map((e) => ModelOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentOperatingModeCode: json['currentOperatingModeCode'] as String?,
      thoughtLevels: (json['thoughtLevels'] as List<dynamic>?)
          ?.map((e) => ModelOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentThoughtLevelCode: json['currentThoughtLevelCode'] as String?,
      path: json['path'] as String,
      host: json['host'] as String,
      version: json['version'] as String?,
      name: json['name'] as String?,
      os: json['os'] as String?,
      summary: json['summary'] != null
          ? SessionSummary.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
      machineId: json['machineId'] as String?,
      claudeSessionId: json['claudeSessionId'] as String?,
      codexThreadId: json['codexThreadId'] as String?,
      tools: (json['tools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      slashCommands: (json['slashCommands'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      homeDir: json['homeDir'] as String?,
      happyHomeDir: json['happyHomeDir'] as String?,
      hostPid: (json['hostPid'] as num?)?.toInt(),
      flavor: json['flavor'] as String?,
      sandbox: json['sandbox'],
      dangerouslySkipPermissions: json['dangerouslySkipPermissions'] as bool?,
      lifecycleState: json['lifecycleState'] as String?,
      lifecycleStateSince: (json['lifecycleStateSince'] as num?)?.toInt(),
      archivedBy: json['archivedBy'] as String?,
      archiveReason: json['archiveReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (models != null)
          'models': models!.map((e) => e.toJson()).toList(),
        if (currentModelCode != null) 'currentModelCode': currentModelCode,
        if (operatingModes != null)
          'operatingModes': operatingModes!.map((e) => e.toJson()).toList(),
        if (currentOperatingModeCode != null)
          'currentOperatingModeCode': currentOperatingModeCode,
        if (thoughtLevels != null)
          'thoughtLevels': thoughtLevels!.map((e) => e.toJson()).toList(),
        if (currentThoughtLevelCode != null)
          'currentThoughtLevelCode': currentThoughtLevelCode,
        'path': path,
        'host': host,
        if (version != null) 'version': version,
        if (name != null) 'name': name,
        if (os != null) 'os': os,
        if (summary != null) 'summary': summary!.toJson(),
        if (machineId != null) 'machineId': machineId,
        if (claudeSessionId != null) 'claudeSessionId': claudeSessionId,
        if (codexThreadId != null) 'codexThreadId': codexThreadId,
        if (tools != null) 'tools': tools,
        if (slashCommands != null) 'slashCommands': slashCommands,
        if (homeDir != null) 'homeDir': homeDir,
        if (happyHomeDir != null) 'happyHomeDir': happyHomeDir,
        if (hostPid != null) 'hostPid': hostPid,
        if (flavor != null) 'flavor': flavor,
        if (sandbox != null) 'sandbox': sandbox,
        if (dangerouslySkipPermissions != null)
          'dangerouslySkipPermissions': dangerouslySkipPermissions,
        if (lifecycleState != null) 'lifecycleState': lifecycleState,
        if (lifecycleStateSince != null)
          'lifecycleStateSince': lifecycleStateSince,
        if (archivedBy != null) 'archivedBy': archivedBy,
        if (archiveReason != null) 'archiveReason': archiveReason,
      };
}

// ---------------------------------------------------------------------------
// AgentState (ported from AgentStateSchema)
// ---------------------------------------------------------------------------

class PermissionRequest {
  const PermissionRequest({
    required this.tool,
    this.arguments,
    this.createdAt,
  });

  final String tool;
  final dynamic arguments;
  final int? createdAt;

  factory PermissionRequest.fromJson(Map<String, dynamic> json) {
    return PermissionRequest(
      tool: json['tool'] as String,
      arguments: json['arguments'],
      createdAt: (json['createdAt'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'tool': tool,
        if (arguments != null) 'arguments': arguments,
        if (createdAt != null) 'createdAt': createdAt,
      };
}

class CompletedRequest {
  const CompletedRequest({
    required this.tool,
    this.arguments,
    this.createdAt,
    this.completedAt,
    required this.status,
    this.reason,
    this.mode,
    this.allowedTools,
    this.decision,
  });

  final String tool;
  final dynamic arguments;
  final int? createdAt;
  final int? completedAt;
  final String status; // 'canceled' | 'denied' | 'approved'
  final String? reason;
  final String? mode;
  final List<String>? allowedTools;
  final String? decision; // 'approved' | 'approved_for_session' | 'denied' | 'abort'

  factory CompletedRequest.fromJson(Map<String, dynamic> json) {
    return CompletedRequest(
      tool: json['tool'] as String,
      arguments: json['arguments'],
      createdAt: (json['createdAt'] as num?)?.toInt(),
      completedAt: (json['completedAt'] as num?)?.toInt(),
      status: json['status'] as String,
      reason: json['reason'] as String?,
      mode: json['mode'] as String?,
      allowedTools: (json['allowedTools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      decision: json['decision'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'tool': tool,
        if (arguments != null) 'arguments': arguments,
        if (createdAt != null) 'createdAt': createdAt,
        if (completedAt != null) 'completedAt': completedAt,
        'status': status,
        if (reason != null) 'reason': reason,
        if (mode != null) 'mode': mode,
        if (allowedTools != null) 'allowedTools': allowedTools,
        if (decision != null) 'decision': decision,
      };
}

class AgentState {
  const AgentState({
    this.controlledByUser,
    this.requests,
    this.completedRequests,
  });

  final bool? controlledByUser;
  final Map<String, PermissionRequest>? requests;
  final Map<String, CompletedRequest>? completedRequests;

  factory AgentState.fromJson(Map<String, dynamic> json) {
    return AgentState(
      controlledByUser: json['controlledByUser'] as bool?,
      requests: (json['requests'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(
          k,
          PermissionRequest.fromJson(v as Map<String, dynamic>),
        ),
      ),
      completedRequests: (json['completedRequests'] as Map<String, dynamic>?)
          ?.map(
        (k, v) => MapEntry(
          k,
          CompletedRequest.fromJson(v as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        if (controlledByUser != null) 'controlledByUser': controlledByUser,
        if (requests != null)
          'requests':
              requests!.map((k, v) => MapEntry(k, v.toJson())),
        if (completedRequests != null)
          'completedRequests':
              completedRequests!.map((k, v) => MapEntry(k, v.toJson())),
      };
}

// ---------------------------------------------------------------------------
// MachineMetadata (ported from MachineMetadataSchema)
// ---------------------------------------------------------------------------

class CliAvailability {
  const CliAvailability({
    required this.claude,
    required this.codex,
    required this.gemini,
    required this.openclaw,
    required this.detectedAt,
  });

  final bool claude;
  final bool codex;
  final bool gemini;
  final bool openclaw;
  final int detectedAt;

  factory CliAvailability.fromJson(Map<String, dynamic> json) {
    return CliAvailability(
      claude: json['claude'] as bool,
      codex: json['codex'] as bool,
      gemini: json['gemini'] as bool,
      openclaw: json['openclaw'] as bool,
      detectedAt: (json['detectedAt'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'claude': claude,
        'codex': codex,
        'gemini': gemini,
        'openclaw': openclaw,
        'detectedAt': detectedAt,
      };
}

class ResumeSupport {
  const ResumeSupport({
    required this.rpcAvailable,
    required this.requiresSameMachine,
    required this.requiresHappyAgentAuth,
    required this.happyAgentAuthenticated,
    required this.detectedAt,
  });

  final bool rpcAvailable;
  final bool requiresSameMachine;
  final bool requiresHappyAgentAuth;
  final bool happyAgentAuthenticated;
  final int detectedAt;

  factory ResumeSupport.fromJson(Map<String, dynamic> json) {
    return ResumeSupport(
      rpcAvailable: json['rpcAvailable'] as bool,
      requiresSameMachine: json['requiresSameMachine'] as bool,
      requiresHappyAgentAuth: json['requiresHappyAgentAuth'] as bool,
      happyAgentAuthenticated: json['happyAgentAuthenticated'] as bool,
      detectedAt: (json['detectedAt'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'rpcAvailable': rpcAvailable,
        'requiresSameMachine': requiresSameMachine,
        'requiresHappyAgentAuth': requiresHappyAgentAuth,
        'happyAgentAuthenticated': happyAgentAuthenticated,
        'detectedAt': detectedAt,
      };
}

class MachineMetadata {
  const MachineMetadata({
    required this.host,
    required this.platform,
    required this.happyCliVersion,
    required this.happyHomeDir,
    required this.homeDir,
    this.username,
    this.arch,
    this.displayName,
    this.daemonLastKnownStatus,
    this.daemonLastKnownPid,
    this.shutdownRequestedAt,
    this.shutdownSource,
    this.cliAvailability,
    this.resumeSupport,
  });

  final String host;
  final String platform;
  final String happyCliVersion;
  final String happyHomeDir;
  final String homeDir;
  final String? username;
  final String? arch;
  final String? displayName;
  final String? daemonLastKnownStatus; // 'running' | 'shutting-down'
  final int? daemonLastKnownPid;
  final int? shutdownRequestedAt;
  final String? shutdownSource; // 'happy-app' | 'happy-cli' | 'os-signal' | 'unknown'
  final CliAvailability? cliAvailability;
  final ResumeSupport? resumeSupport;

  factory MachineMetadata.fromJson(Map<String, dynamic> json) {
    return MachineMetadata(
      host: json['host'] as String,
      platform: json['platform'] as String,
      happyCliVersion: json['happyCliVersion'] as String,
      happyHomeDir: json['happyHomeDir'] as String,
      homeDir: json['homeDir'] as String,
      username: json['username'] as String?,
      arch: json['arch'] as String?,
      displayName: json['displayName'] as String?,
      daemonLastKnownStatus: json['daemonLastKnownStatus'] as String?,
      daemonLastKnownPid: (json['daemonLastKnownPid'] as num?)?.toInt(),
      shutdownRequestedAt: (json['shutdownRequestedAt'] as num?)?.toInt(),
      shutdownSource: json['shutdownSource'] as String?,
      cliAvailability: json['cliAvailability'] != null
          ? CliAvailability.fromJson(
              json['cliAvailability'] as Map<String, dynamic>)
          : null,
      resumeSupport: json['resumeSupport'] != null
          ? ResumeSupport.fromJson(
              json['resumeSupport'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'host': host,
        'platform': platform,
        'happyCliVersion': happyCliVersion,
        'happyHomeDir': happyHomeDir,
        'homeDir': homeDir,
        if (username != null) 'username': username,
        if (arch != null) 'arch': arch,
        if (displayName != null) 'displayName': displayName,
        if (daemonLastKnownStatus != null)
          'daemonLastKnownStatus': daemonLastKnownStatus,
        if (daemonLastKnownPid != null)
          'daemonLastKnownPid': daemonLastKnownPid,
        if (shutdownRequestedAt != null)
          'shutdownRequestedAt': shutdownRequestedAt,
        if (shutdownSource != null) 'shutdownSource': shutdownSource,
        if (cliAvailability != null)
          'cliAvailability': cliAvailability!.toJson(),
        if (resumeSupport != null) 'resumeSupport': resumeSupport!.toJson(),
      };
}

// ---------------------------------------------------------------------------
// LatestUsage
// ---------------------------------------------------------------------------

class LatestUsage {
  const LatestUsage({
    required this.inputTokens,
    required this.outputTokens,
    required this.cacheCreation,
    required this.cacheRead,
    required this.contextSize,
    required this.timestamp,
  });

  final int inputTokens;
  final int outputTokens;
  final int cacheCreation;
  final int cacheRead;
  final int contextSize;
  final int timestamp;

  factory LatestUsage.fromJson(Map<String, dynamic> json) {
    return LatestUsage(
      inputTokens: (json['inputTokens'] as num).toInt(),
      outputTokens: (json['outputTokens'] as num).toInt(),
      cacheCreation: (json['cacheCreation'] as num).toInt(),
      cacheRead: (json['cacheRead'] as num).toInt(),
      contextSize: (json['contextSize'] as num).toInt(),
      timestamp: (json['timestamp'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'inputTokens': inputTokens,
        'outputTokens': outputTokens,
        'cacheCreation': cacheCreation,
        'cacheRead': cacheRead,
        'contextSize': contextSize,
        'timestamp': timestamp,
      };
}

// ---------------------------------------------------------------------------
// TodoItem
// ---------------------------------------------------------------------------

class TodoItem {
  const TodoItem({
    required this.id,
    required this.content,
    required this.status,
    required this.priority,
  });

  final String id;
  final String content;
  final String status; // 'pending' | 'in_progress' | 'completed'
  final String priority; // 'high' | 'medium' | 'low'

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      content: json['content'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'status': status,
        'priority': priority,
      };
}

// ---------------------------------------------------------------------------
// Session
// ---------------------------------------------------------------------------

/// Represents a synced session with its metadata and agent state.
///
/// The [presence] field is either the string "online" or a timestamp (int)
/// indicating when the session was last seen. We model this as [Object] and
/// provide the helper getters [isOnline] and [lastSeenAt].
class Session {
  const Session({
    required this.id,
    required this.seq,
    required this.createdAt,
    required this.updatedAt,
    required this.active,
    required this.activeAt,
    this.metadata,
    required this.metadataVersion,
    this.agentState,
    required this.agentStateVersion,
    required this.thinking,
    required this.thinkingAt,
    required this.presence,
    this.todos,
    this.draft,
    this.permissionMode,
    this.modelMode,
    this.latestUsage,
  });

  final String id;
  final int seq;
  final int createdAt;
  final int updatedAt;
  final bool active;
  final int activeAt;
  final Metadata? metadata;
  final int metadataVersion;
  final AgentState? agentState;
  final int agentStateVersion;
  final bool thinking;
  final int thinkingAt;

  /// Either the string "online" or an [int] timestamp.
  final Object presence;

  final List<TodoItem>? todos;
  final String? draft;
  final String? permissionMode;
  final String? modelMode;
  final LatestUsage? latestUsage;

  bool get isOnline => presence == 'online';

  int? get lastSeenAt => presence is int ? presence as int : null;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      seq: (json['seq'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      active: json['active'] as bool,
      activeAt: (json['activeAt'] as num).toInt(),
      metadata: json['metadata'] != null
          ? Metadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
      metadataVersion: (json['metadataVersion'] as num).toInt(),
      agentState: json['agentState'] != null
          ? AgentState.fromJson(json['agentState'] as Map<String, dynamic>)
          : null,
      agentStateVersion: (json['agentStateVersion'] as num).toInt(),
      thinking: json['thinking'] as bool,
      thinkingAt: (json['thinkingAt'] as num).toInt(),
      presence: json['presence'] is String
          ? json['presence'] as String
          : (json['presence'] as num).toInt(),
      todos: (json['todos'] as List<dynamic>?)
          ?.map((e) => TodoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      draft: json['draft'] as String?,
      permissionMode: json['permissionMode'] as String?,
      modelMode: json['modelMode'] as String?,
      latestUsage: json['latestUsage'] != null
          ? LatestUsage.fromJson(json['latestUsage'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'seq': seq,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'active': active,
        'activeAt': activeAt,
        if (metadata != null) 'metadata': metadata!.toJson(),
        'metadataVersion': metadataVersion,
        if (agentState != null) 'agentState': agentState!.toJson(),
        'agentStateVersion': agentStateVersion,
        'thinking': thinking,
        'thinkingAt': thinkingAt,
        'presence': presence,
        if (todos != null)
          'todos': todos!.map((e) => e.toJson()).toList(),
        if (draft != null) 'draft': draft,
        if (permissionMode != null) 'permissionMode': permissionMode,
        if (modelMode != null) 'modelMode': modelMode,
        if (latestUsage != null) 'latestUsage': latestUsage!.toJson(),
      };
}

// ---------------------------------------------------------------------------
// Machine
// ---------------------------------------------------------------------------

class Machine {
  const Machine({
    required this.id,
    required this.seq,
    required this.createdAt,
    required this.updatedAt,
    required this.active,
    required this.activeAt,
    this.metadata,
    required this.metadataVersion,
    this.daemonState,
    required this.daemonStateVersion,
  });

  final String id;
  final int seq;
  final int createdAt;
  final int updatedAt;
  final bool active;
  final int activeAt;
  final MachineMetadata? metadata;
  final int metadataVersion;
  final dynamic daemonState;
  final int daemonStateVersion;

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'] as String,
      seq: (json['seq'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      active: json['active'] as bool,
      activeAt: (json['activeAt'] as num).toInt(),
      metadata: json['metadata'] != null
          ? MachineMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
      metadataVersion: (json['metadataVersion'] as num).toInt(),
      daemonState: json['daemonState'],
      daemonStateVersion: (json['daemonStateVersion'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'seq': seq,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'active': active,
        'activeAt': activeAt,
        if (metadata != null) 'metadata': metadata!.toJson(),
        'metadataVersion': metadataVersion,
        if (daemonState != null) 'daemonState': daemonState,
        'daemonStateVersion': daemonStateVersion,
      };
}

// ---------------------------------------------------------------------------
// DecryptedMessage
// ---------------------------------------------------------------------------

class DecryptedMessage {
  const DecryptedMessage({
    required this.id,
    this.seq,
    this.localId,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final int? seq;
  final String? localId;
  final dynamic content;
  final int createdAt;

  factory DecryptedMessage.fromJson(Map<String, dynamic> json) {
    return DecryptedMessage(
      id: json['id'] as String,
      seq: (json['seq'] as num?)?.toInt(),
      localId: json['localId'] as String?,
      content: json['content'],
      createdAt: (json['createdAt'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (seq != null) 'seq': seq,
        if (localId != null) 'localId': localId,
        'content': content,
        'createdAt': createdAt,
      };
}

// ---------------------------------------------------------------------------
// GitStatus
// ---------------------------------------------------------------------------

class GitStatus {
  const GitStatus({
    this.branch,
    required this.isDirty,
    required this.modifiedCount,
    required this.untrackedCount,
    required this.stagedCount,
    required this.lastUpdatedAt,
    required this.stagedLinesAdded,
    required this.stagedLinesRemoved,
    required this.unstagedLinesAdded,
    required this.unstagedLinesRemoved,
    required this.linesAdded,
    required this.linesRemoved,
    required this.linesChanged,
    this.upstreamBranch,
    this.aheadCount,
    this.behindCount,
    this.stashCount,
  });

  final String? branch;
  final bool isDirty;
  final int modifiedCount;
  final int untrackedCount;
  final int stagedCount;
  final int lastUpdatedAt;
  final int stagedLinesAdded;
  final int stagedLinesRemoved;
  final int unstagedLinesAdded;
  final int unstagedLinesRemoved;
  final int linesAdded;
  final int linesRemoved;
  final int linesChanged;
  final String? upstreamBranch;
  final int? aheadCount;
  final int? behindCount;
  final int? stashCount;

  factory GitStatus.fromJson(Map<String, dynamic> json) {
    return GitStatus(
      branch: json['branch'] as String?,
      isDirty: json['isDirty'] as bool,
      modifiedCount: (json['modifiedCount'] as num).toInt(),
      untrackedCount: (json['untrackedCount'] as num).toInt(),
      stagedCount: (json['stagedCount'] as num).toInt(),
      lastUpdatedAt: (json['lastUpdatedAt'] as num).toInt(),
      stagedLinesAdded: (json['stagedLinesAdded'] as num).toInt(),
      stagedLinesRemoved: (json['stagedLinesRemoved'] as num).toInt(),
      unstagedLinesAdded: (json['unstagedLinesAdded'] as num).toInt(),
      unstagedLinesRemoved: (json['unstagedLinesRemoved'] as num).toInt(),
      linesAdded: (json['linesAdded'] as num).toInt(),
      linesRemoved: (json['linesRemoved'] as num).toInt(),
      linesChanged: (json['linesChanged'] as num).toInt(),
      upstreamBranch: json['upstreamBranch'] as String?,
      aheadCount: (json['aheadCount'] as num?)?.toInt(),
      behindCount: (json['behindCount'] as num?)?.toInt(),
      stashCount: (json['stashCount'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'branch': branch,
        'isDirty': isDirty,
        'modifiedCount': modifiedCount,
        'untrackedCount': untrackedCount,
        'stagedCount': stagedCount,
        'lastUpdatedAt': lastUpdatedAt,
        'stagedLinesAdded': stagedLinesAdded,
        'stagedLinesRemoved': stagedLinesRemoved,
        'unstagedLinesAdded': unstagedLinesAdded,
        'unstagedLinesRemoved': unstagedLinesRemoved,
        'linesAdded': linesAdded,
        'linesRemoved': linesRemoved,
        'linesChanged': linesChanged,
        if (upstreamBranch != null) 'upstreamBranch': upstreamBranch,
        if (aheadCount != null) 'aheadCount': aheadCount,
        if (behindCount != null) 'behindCount': behindCount,
        if (stashCount != null) 'stashCount': stashCount,
      };
}
