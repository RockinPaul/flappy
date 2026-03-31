/// Flattened message types for UI rendering.
///
/// Ported from packages/happy-app/sources/sync/typesMessage.ts
library;

import 'message_meta.dart';
import 'normalized_types.dart';

// ---------------------------------------------------------------------------
// ToolCall permission
// ---------------------------------------------------------------------------

class ToolCallPermission {
  const ToolCallPermission({
    required this.id,
    required this.status,
    this.reason,
    this.mode,
    this.allowedTools,
    this.decision,
    this.date,
  });

  final String id;
  final String status; // 'pending' | 'approved' | 'denied' | 'canceled'
  final String? reason;
  final String? mode;
  final List<String>? allowedTools;
  final String? decision; // 'approved' | 'approved_for_session' | 'denied' | 'abort'
  final int? date;

  factory ToolCallPermission.fromJson(Map<String, dynamic> json) {
    return ToolCallPermission(
      id: json['id'] as String,
      status: json['status'] as String,
      reason: json['reason'] as String?,
      mode: json['mode'] as String?,
      allowedTools: (json['allowedTools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      decision: json['decision'] as String?,
      date: (json['date'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        if (reason != null) 'reason': reason,
        if (mode != null) 'mode': mode,
        if (allowedTools != null) 'allowedTools': allowedTools,
        if (decision != null) 'decision': decision,
        if (date != null) 'date': date,
      };
}

// ---------------------------------------------------------------------------
// ToolCall
// ---------------------------------------------------------------------------

class ToolCall {
  const ToolCall({
    required this.name,
    required this.state,
    required this.input,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.description,
    this.result,
    this.permission,
  });

  final String name;
  final String state; // 'running' | 'completed' | 'error'
  final dynamic input;
  final int createdAt;
  final int? startedAt;
  final int? completedAt;
  final String? description;
  final dynamic result;
  final ToolCallPermission? permission;

  factory ToolCall.fromJson(Map<String, dynamic> json) {
    return ToolCall(
      name: json['name'] as String,
      state: json['state'] as String,
      input: json['input'],
      createdAt: (json['createdAt'] as num).toInt(),
      startedAt: (json['startedAt'] as num?)?.toInt(),
      completedAt: (json['completedAt'] as num?)?.toInt(),
      description: json['description'] as String?,
      result: json['result'],
      permission: json['permission'] != null
          ? ToolCallPermission.fromJson(
              json['permission'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'state': state,
        'input': input,
        'createdAt': createdAt,
        if (startedAt != null) 'startedAt': startedAt,
        if (completedAt != null) 'completedAt': completedAt,
        if (description != null) 'description': description,
        if (result != null) 'result': result,
        if (permission != null) 'permission': permission!.toJson(),
      };
}

// ---------------------------------------------------------------------------
// Message — sealed class with 4 variants
// ---------------------------------------------------------------------------

sealed class Message {
  const Message();

  String get kind;
  String get id;
  int get createdAt;
  MessageMeta? get meta;

  factory Message.fromJson(Map<String, dynamic> json) {
    return switch (json['kind'] as String) {
      'user-text' => UserTextMessage.fromJson(json),
      'agent-text' => AgentTextMessage.fromJson(json),
      'tool-call' => ToolCallMessage.fromJson(json),
      'agent-event' => ModeSwitchMessage.fromJson(json),
      _ => throw ArgumentError('Unknown Message kind: ${json['kind']}'),
    };
  }

  Map<String, dynamic> toJson();
}

class UserTextMessage extends Message {
  const UserTextMessage({
    required this.id,
    this.localId,
    required this.createdAt,
    required this.text,
    this.displayText,
    this.meta,
  });

  @override
  String get kind => 'user-text';

  @override
  final String id;
  final String? localId;
  @override
  final int createdAt;
  final String text;
  final String? displayText;
  @override
  final MessageMeta? meta;

  factory UserTextMessage.fromJson(Map<String, dynamic> json) {
    return UserTextMessage(
      id: json['id'] as String,
      localId: json['localId'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      text: json['text'] as String,
      displayText: json['displayText'] as String?,
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'kind': kind,
        'id': id,
        if (localId != null) 'localId': localId,
        'createdAt': createdAt,
        'text': text,
        if (displayText != null) 'displayText': displayText,
        if (meta != null) 'meta': meta!.toJson(),
      };
}

class AgentTextMessage extends Message {
  const AgentTextMessage({
    required this.id,
    this.localId,
    required this.createdAt,
    required this.text,
    this.isThinking,
    this.meta,
  });

  @override
  String get kind => 'agent-text';

  @override
  final String id;
  final String? localId;
  @override
  final int createdAt;
  final String text;
  final bool? isThinking;
  @override
  final MessageMeta? meta;

  factory AgentTextMessage.fromJson(Map<String, dynamic> json) {
    return AgentTextMessage(
      id: json['id'] as String,
      localId: json['localId'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      text: json['text'] as String,
      isThinking: json['isThinking'] as bool?,
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'kind': kind,
        'id': id,
        if (localId != null) 'localId': localId,
        'createdAt': createdAt,
        'text': text,
        if (isThinking != null) 'isThinking': isThinking,
        if (meta != null) 'meta': meta!.toJson(),
      };
}

class ToolCallMessage extends Message {
  const ToolCallMessage({
    required this.id,
    this.localId,
    required this.createdAt,
    required this.tool,
    required this.children,
    this.meta,
  });

  @override
  String get kind => 'tool-call';

  @override
  final String id;
  final String? localId;
  @override
  final int createdAt;
  final ToolCall tool;
  final List<Message> children;
  @override
  final MessageMeta? meta;

  factory ToolCallMessage.fromJson(Map<String, dynamic> json) {
    return ToolCallMessage(
      id: json['id'] as String,
      localId: json['localId'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      tool: ToolCall.fromJson(json['tool'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'kind': kind,
        'id': id,
        if (localId != null) 'localId': localId,
        'createdAt': createdAt,
        'tool': tool.toJson(),
        'children': children.map((e) => e.toJson()).toList(),
        if (meta != null) 'meta': meta!.toJson(),
      };
}

class ModeSwitchMessage extends Message {
  const ModeSwitchMessage({
    required this.id,
    required this.createdAt,
    required this.event,
    this.meta,
  });

  @override
  String get kind => 'agent-event';

  @override
  final String id;
  @override
  final int createdAt;
  final AgentEvent event;
  @override
  final MessageMeta? meta;

  factory ModeSwitchMessage.fromJson(Map<String, dynamic> json) {
    return ModeSwitchMessage(
      id: json['id'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      event: AgentEvent.fromJson(json['event'] as Map<String, dynamic>),
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'kind': kind,
        'id': id,
        'createdAt': createdAt,
        'event': event.toJson(),
        if (meta != null) 'meta': meta!.toJson(),
      };
}
