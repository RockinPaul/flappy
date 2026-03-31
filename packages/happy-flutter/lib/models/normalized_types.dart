/// Normalized types for agent content and messages.
///
/// Ported from packages/happy-app/sources/sync/typesRaw.ts
library;

import 'message_meta.dart';

// ---------------------------------------------------------------------------
// AgentEvent — discriminated union on 'type'
// ---------------------------------------------------------------------------

sealed class AgentEvent {
  const AgentEvent();

  String get type;

  factory AgentEvent.fromJson(Map<String, dynamic> json) {
    return switch (json['type'] as String) {
      'switch' => AgentEventSwitch.fromJson(json),
      'message' => AgentEventMessage.fromJson(json),
      'limit-reached' => AgentEventLimitReached.fromJson(json),
      'ready' => const AgentEventReady(),
      _ => throw ArgumentError('Unknown AgentEvent type: ${json['type']}'),
    };
  }

  Map<String, dynamic> toJson();
}

class AgentEventSwitch extends AgentEvent {
  const AgentEventSwitch({required this.mode});

  @override
  String get type => 'switch';

  final String mode; // 'local' | 'remote'

  factory AgentEventSwitch.fromJson(Map<String, dynamic> json) {
    return AgentEventSwitch(mode: json['mode'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'mode': mode};
}

class AgentEventMessage extends AgentEvent {
  const AgentEventMessage({required this.message});

  @override
  String get type => 'message';

  final String message;

  factory AgentEventMessage.fromJson(Map<String, dynamic> json) {
    return AgentEventMessage(message: json['message'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'message': message};
}

class AgentEventLimitReached extends AgentEvent {
  const AgentEventLimitReached({required this.endsAt});

  @override
  String get type => 'limit-reached';

  final int endsAt;

  factory AgentEventLimitReached.fromJson(Map<String, dynamic> json) {
    return AgentEventLimitReached(endsAt: (json['endsAt'] as num).toInt());
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'endsAt': endsAt};
}

class AgentEventReady extends AgentEvent {
  const AgentEventReady();

  @override
  String get type => 'ready';

  @override
  Map<String, dynamic> toJson() => {'type': type};
}

// ---------------------------------------------------------------------------
// UsageData
// ---------------------------------------------------------------------------

class UsageData {
  const UsageData({
    required this.inputTokens,
    this.cacheCreationInputTokens,
    this.cacheReadInputTokens,
    required this.outputTokens,
    this.serviceTier,
  });

  final int inputTokens;
  final int? cacheCreationInputTokens;
  final int? cacheReadInputTokens;
  final int outputTokens;
  final String? serviceTier;

  factory UsageData.fromJson(Map<String, dynamic> json) {
    return UsageData(
      inputTokens: (json['input_tokens'] as num).toInt(),
      cacheCreationInputTokens:
          (json['cache_creation_input_tokens'] as num?)?.toInt(),
      cacheReadInputTokens:
          (json['cache_read_input_tokens'] as num?)?.toInt(),
      outputTokens: (json['output_tokens'] as num).toInt(),
      serviceTier: json['service_tier'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'input_tokens': inputTokens,
        if (cacheCreationInputTokens != null)
          'cache_creation_input_tokens': cacheCreationInputTokens,
        if (cacheReadInputTokens != null)
          'cache_read_input_tokens': cacheReadInputTokens,
        'output_tokens': outputTokens,
        if (serviceTier != null) 'service_tier': serviceTier,
      };
}

// ---------------------------------------------------------------------------
// NormalizedAgentContent — sealed class
// ---------------------------------------------------------------------------

sealed class NormalizedAgentContent {
  const NormalizedAgentContent();

  String get type;

  factory NormalizedAgentContent.fromJson(Map<String, dynamic> json) {
    return switch (json['type'] as String) {
      'text' => NormalizedTextContent.fromJson(json),
      'thinking' => NormalizedThinkingContent.fromJson(json),
      'tool-call' => NormalizedToolCallContent.fromJson(json),
      'tool-result' => NormalizedToolResultContent.fromJson(json),
      'summary' => NormalizedSummaryContent.fromJson(json),
      'sidechain' => NormalizedSidechainContent.fromJson(json),
      _ => throw ArgumentError(
          'Unknown NormalizedAgentContent type: ${json['type']}'),
    };
  }

  Map<String, dynamic> toJson();
}

class NormalizedTextContent extends NormalizedAgentContent {
  const NormalizedTextContent({
    required this.text,
    required this.uuid,
    this.parentUUID,
  });

  @override
  String get type => 'text';

  final String text;
  final String uuid;
  final String? parentUUID;

  factory NormalizedTextContent.fromJson(Map<String, dynamic> json) {
    return NormalizedTextContent(
      text: json['text'] as String,
      uuid: json['uuid'] as String,
      parentUUID: json['parentUUID'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'text': text,
        'uuid': uuid,
        'parentUUID': parentUUID,
      };
}

class NormalizedThinkingContent extends NormalizedAgentContent {
  const NormalizedThinkingContent({
    required this.thinking,
    required this.uuid,
    this.parentUUID,
  });

  @override
  String get type => 'thinking';

  final String thinking;
  final String uuid;
  final String? parentUUID;

  factory NormalizedThinkingContent.fromJson(Map<String, dynamic> json) {
    return NormalizedThinkingContent(
      thinking: json['thinking'] as String,
      uuid: json['uuid'] as String,
      parentUUID: json['parentUUID'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'thinking': thinking,
        'uuid': uuid,
        'parentUUID': parentUUID,
      };
}

class NormalizedToolCallContent extends NormalizedAgentContent {
  const NormalizedToolCallContent({
    required this.id,
    required this.name,
    required this.input,
    this.description,
    required this.uuid,
    this.parentUUID,
  });

  @override
  String get type => 'tool-call';

  final String id;
  final String name;
  final dynamic input;
  final String? description;
  final String uuid;
  final String? parentUUID;

  factory NormalizedToolCallContent.fromJson(Map<String, dynamic> json) {
    return NormalizedToolCallContent(
      id: json['id'] as String,
      name: json['name'] as String,
      input: json['input'],
      description: json['description'] as String?,
      uuid: json['uuid'] as String,
      parentUUID: json['parentUUID'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'name': name,
        'input': input,
        'description': description,
        'uuid': uuid,
        'parentUUID': parentUUID,
      };
}

class ToolResultPermissions {
  const ToolResultPermissions({
    required this.date,
    required this.result,
    this.mode,
    this.allowedTools,
    this.decision,
  });

  final int date;
  final String result; // 'approved' | 'denied'
  final String? mode;
  final List<String>? allowedTools;
  final String? decision; // 'approved' | 'approved_for_session' | 'denied' | 'abort'

  factory ToolResultPermissions.fromJson(Map<String, dynamic> json) {
    return ToolResultPermissions(
      date: (json['date'] as num).toInt(),
      result: json['result'] as String,
      mode: json['mode'] as String?,
      allowedTools: (json['allowedTools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      decision: json['decision'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'result': result,
        if (mode != null) 'mode': mode,
        if (allowedTools != null) 'allowedTools': allowedTools,
        if (decision != null) 'decision': decision,
      };
}

class NormalizedToolResultContent extends NormalizedAgentContent {
  const NormalizedToolResultContent({
    required this.toolUseId,
    required this.content,
    required this.isError,
    required this.uuid,
    this.parentUUID,
    this.permissions,
  });

  @override
  String get type => 'tool-result';

  final String toolUseId;
  final dynamic content;
  final bool isError;
  final String uuid;
  final String? parentUUID;
  final ToolResultPermissions? permissions;

  factory NormalizedToolResultContent.fromJson(Map<String, dynamic> json) {
    return NormalizedToolResultContent(
      toolUseId: json['tool_use_id'] as String,
      content: json['content'],
      isError: json['is_error'] as bool,
      uuid: json['uuid'] as String,
      parentUUID: json['parentUUID'] as String?,
      permissions: json['permissions'] != null
          ? ToolResultPermissions.fromJson(
              json['permissions'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'tool_use_id': toolUseId,
        'content': content,
        'is_error': isError,
        'uuid': uuid,
        'parentUUID': parentUUID,
        if (permissions != null) 'permissions': permissions!.toJson(),
      };
}

class NormalizedSummaryContent extends NormalizedAgentContent {
  const NormalizedSummaryContent({required this.summary});

  @override
  String get type => 'summary';

  final String summary;

  factory NormalizedSummaryContent.fromJson(Map<String, dynamic> json) {
    return NormalizedSummaryContent(summary: json['summary'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'summary': summary};
}

class NormalizedSidechainContent extends NormalizedAgentContent {
  const NormalizedSidechainContent({
    required this.uuid,
    required this.prompt,
  });

  @override
  String get type => 'sidechain';

  final String uuid;
  final String prompt;

  factory NormalizedSidechainContent.fromJson(Map<String, dynamic> json) {
    return NormalizedSidechainContent(
      uuid: json['uuid'] as String,
      prompt: json['prompt'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'uuid': uuid,
        'prompt': prompt,
      };
}

// ---------------------------------------------------------------------------
// NormalizedMessage — sealed class with role variants
// ---------------------------------------------------------------------------

sealed class NormalizedMessage {
  const NormalizedMessage();

  String get role;
  String get id;
  String? get localId;
  int get createdAt;
  bool get isSidechain;
  MessageMeta? get meta;
  UsageData? get usage;

  factory NormalizedMessage.fromJson(Map<String, dynamic> json) {
    return switch (json['role'] as String) {
      'user' => NormalizedUserMessage.fromJson(json),
      'agent' => NormalizedAgentMessage.fromJson(json),
      'event' => NormalizedEventMessage.fromJson(json),
      _ => throw ArgumentError(
          'Unknown NormalizedMessage role: ${json['role']}'),
    };
  }

  Map<String, dynamic> toJson();
}

class NormalizedUserMessage extends NormalizedMessage {
  const NormalizedUserMessage({
    required this.id,
    this.localId,
    required this.createdAt,
    required this.isSidechain,
    required this.content,
    this.meta,
    this.usage,
  });

  @override
  String get role => 'user';

  @override
  final String id;
  @override
  final String? localId;
  @override
  final int createdAt;
  @override
  final bool isSidechain;
  final NormalizedUserContent content;
  @override
  final MessageMeta? meta;
  @override
  final UsageData? usage;

  factory NormalizedUserMessage.fromJson(Map<String, dynamic> json) {
    return NormalizedUserMessage(
      id: json['id'] as String,
      localId: json['localId'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      isSidechain: json['isSidechain'] as bool,
      content: NormalizedUserContent.fromJson(
          json['content'] as Map<String, dynamic>),
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      usage: json['usage'] != null
          ? UsageData.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'role': role,
        'id': id,
        if (localId != null) 'localId': localId,
        'createdAt': createdAt,
        'isSidechain': isSidechain,
        'content': content.toJson(),
        if (meta != null) 'meta': meta!.toJson(),
        if (usage != null) 'usage': usage!.toJson(),
      };
}

class NormalizedUserContent {
  const NormalizedUserContent({required this.text});

  final String text;

  String get type => 'text';

  factory NormalizedUserContent.fromJson(Map<String, dynamic> json) {
    return NormalizedUserContent(text: json['text'] as String);
  }

  Map<String, dynamic> toJson() => {'type': type, 'text': text};
}

class NormalizedAgentMessage extends NormalizedMessage {
  const NormalizedAgentMessage({
    required this.id,
    this.localId,
    required this.createdAt,
    required this.isSidechain,
    required this.content,
    this.meta,
    this.usage,
  });

  @override
  String get role => 'agent';

  @override
  final String id;
  @override
  final String? localId;
  @override
  final int createdAt;
  @override
  final bool isSidechain;
  final List<NormalizedAgentContent> content;
  @override
  final MessageMeta? meta;
  @override
  final UsageData? usage;

  factory NormalizedAgentMessage.fromJson(Map<String, dynamic> json) {
    return NormalizedAgentMessage(
      id: json['id'] as String,
      localId: json['localId'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      isSidechain: json['isSidechain'] as bool,
      content: (json['content'] as List<dynamic>)
          .map((e) =>
              NormalizedAgentContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      usage: json['usage'] != null
          ? UsageData.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'role': role,
        'id': id,
        if (localId != null) 'localId': localId,
        'createdAt': createdAt,
        'isSidechain': isSidechain,
        'content': content.map((e) => e.toJson()).toList(),
        if (meta != null) 'meta': meta!.toJson(),
        if (usage != null) 'usage': usage!.toJson(),
      };
}

class NormalizedEventMessage extends NormalizedMessage {
  const NormalizedEventMessage({
    required this.id,
    this.localId,
    required this.createdAt,
    required this.isSidechain,
    required this.content,
    this.meta,
    this.usage,
  });

  @override
  String get role => 'event';

  @override
  final String id;
  @override
  final String? localId;
  @override
  final int createdAt;
  @override
  final bool isSidechain;
  final AgentEvent content;
  @override
  final MessageMeta? meta;
  @override
  final UsageData? usage;

  factory NormalizedEventMessage.fromJson(Map<String, dynamic> json) {
    return NormalizedEventMessage(
      id: json['id'] as String,
      localId: json['localId'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      isSidechain: json['isSidechain'] as bool,
      content: AgentEvent.fromJson(json['content'] as Map<String, dynamic>),
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      usage: json['usage'] != null
          ? UsageData.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'role': role,
        'id': id,
        if (localId != null) 'localId': localId,
        'createdAt': createdAt,
        'isSidechain': isSidechain,
        'content': content.toJson(),
        if (meta != null) 'meta': meta!.toJson(),
        if (usage != null) 'usage': usage!.toJson(),
      };
}
