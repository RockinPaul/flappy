/// Wire protocol types ported from packages/happy-wire.
///
/// Covers session messages, encrypted values, core update containers,
/// voice token responses, and legacy user/agent message formats.
library;

import 'message_meta.dart';

// ---------------------------------------------------------------------------
// Session message content & messages
// ---------------------------------------------------------------------------

class SessionMessageContent {
  const SessionMessageContent({required this.c, this.t = 'encrypted'});

  final String c;
  final String t;

  factory SessionMessageContent.fromJson(Map<String, dynamic> json) {
    return SessionMessageContent(
      c: json['c'] as String,
      t: json['t'] as String? ?? 'encrypted',
    );
  }

  Map<String, dynamic> toJson() => {'c': c, 't': t};
}

class SessionMessage {
  const SessionMessage({
    required this.id,
    required this.seq,
    this.localId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final int seq;
  final String? localId;
  final SessionMessageContent content;
  final int createdAt;
  final int updatedAt;

  factory SessionMessage.fromJson(Map<String, dynamic> json) {
    return SessionMessage(
      id: json['id'] as String,
      seq: (json['seq'] as num).toInt(),
      localId: json['localId'] as String?,
      content: SessionMessageContent.fromJson(
        json['content'] as Map<String, dynamic>,
      ),
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'seq': seq,
        if (localId != null) 'localId': localId,
        'content': content.toJson(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

// ---------------------------------------------------------------------------
// Versioned encrypted values
// ---------------------------------------------------------------------------

class VersionedEncryptedValue {
  const VersionedEncryptedValue({
    required this.version,
    required this.value,
  });

  final int version;
  final String value;

  factory VersionedEncryptedValue.fromJson(Map<String, dynamic> json) {
    return VersionedEncryptedValue(
      version: (json['version'] as num).toInt(),
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'version': version, 'value': value};
}

class VersionedNullableEncryptedValue {
  const VersionedNullableEncryptedValue({
    required this.version,
    this.value,
  });

  final int version;
  final String? value;

  factory VersionedNullableEncryptedValue.fromJson(Map<String, dynamic> json) {
    return VersionedNullableEncryptedValue(
      version: (json['version'] as num).toInt(),
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'version': version, 'value': value};
}

// ---------------------------------------------------------------------------
// Core update body — discriminated union on 't'
// ---------------------------------------------------------------------------

sealed class CoreUpdateBody {
  const CoreUpdateBody();

  String get t;

  factory CoreUpdateBody.fromJson(Map<String, dynamic> json) {
    return switch (json['t'] as String) {
      'new-message' => UpdateNewMessageBody.fromJson(json),
      'update-session' => UpdateSessionBody.fromJson(json),
      'update-machine' => UpdateMachineBody.fromJson(json),
      _ => throw ArgumentError('Unknown CoreUpdateBody type: ${json['t']}'),
    };
  }

  Map<String, dynamic> toJson();
}

class UpdateNewMessageBody extends CoreUpdateBody {
  const UpdateNewMessageBody({
    required this.sid,
    required this.message,
  });

  @override
  String get t => 'new-message';

  final String sid;
  final SessionMessage message;

  factory UpdateNewMessageBody.fromJson(Map<String, dynamic> json) {
    return UpdateNewMessageBody(
      sid: json['sid'] as String,
      message: SessionMessage.fromJson(
        json['message'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        't': t,
        'sid': sid,
        'message': message.toJson(),
      };
}

class UpdateSessionBody extends CoreUpdateBody {
  const UpdateSessionBody({
    required this.id,
    this.metadata,
    this.agentState,
  });

  @override
  String get t => 'update-session';

  final String id;
  final VersionedEncryptedValue? metadata;
  final VersionedNullableEncryptedValue? agentState;

  factory UpdateSessionBody.fromJson(Map<String, dynamic> json) {
    return UpdateSessionBody(
      id: json['id'] as String,
      metadata: json['metadata'] != null
          ? VersionedEncryptedValue.fromJson(
              json['metadata'] as Map<String, dynamic>,
            )
          : null,
      agentState: json['agentState'] != null
          ? VersionedNullableEncryptedValue.fromJson(
              json['agentState'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        't': t,
        'id': id,
        if (metadata != null) 'metadata': metadata!.toJson(),
        if (agentState != null) 'agentState': agentState!.toJson(),
      };
}

class UpdateMachineBody extends CoreUpdateBody {
  const UpdateMachineBody({
    required this.machineId,
    this.metadata,
    this.daemonState,
    this.active,
    this.activeAt,
  });

  @override
  String get t => 'update-machine';

  final String machineId;
  final VersionedEncryptedValue? metadata;
  final VersionedEncryptedValue? daemonState;
  final bool? active;
  final int? activeAt;

  factory UpdateMachineBody.fromJson(Map<String, dynamic> json) {
    return UpdateMachineBody(
      machineId: json['machineId'] as String,
      metadata: json['metadata'] != null
          ? VersionedEncryptedValue.fromJson(
              json['metadata'] as Map<String, dynamic>,
            )
          : null,
      daemonState: json['daemonState'] != null
          ? VersionedEncryptedValue.fromJson(
              json['daemonState'] as Map<String, dynamic>,
            )
          : null,
      active: json['active'] as bool?,
      activeAt: (json['activeAt'] as num?)?.toInt(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        't': t,
        'machineId': machineId,
        if (metadata != null) 'metadata': metadata!.toJson(),
        if (daemonState != null) 'daemonState': daemonState!.toJson(),
        if (active != null) 'active': active,
        if (activeAt != null) 'activeAt': activeAt,
      };
}

// ---------------------------------------------------------------------------
// Core update container
// ---------------------------------------------------------------------------

class CoreUpdateContainer {
  const CoreUpdateContainer({
    required this.id,
    required this.seq,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final int seq;
  final CoreUpdateBody body;
  final int createdAt;

  factory CoreUpdateContainer.fromJson(Map<String, dynamic> json) {
    return CoreUpdateContainer(
      id: json['id'] as String,
      seq: (json['seq'] as num).toInt(),
      body: CoreUpdateBody.fromJson(json['body'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'seq': seq,
        'body': body.toJson(),
        'createdAt': createdAt,
      };
}

// ---------------------------------------------------------------------------
// Voice token response — discriminated union on 'allowed'
// ---------------------------------------------------------------------------

sealed class VoiceTokenResponse {
  const VoiceTokenResponse();

  bool get allowed;
  double get usedSeconds;
  double get limitSeconds;
  String get agentId;

  factory VoiceTokenResponse.fromJson(Map<String, dynamic> json) {
    final allowed = json['allowed'] as bool;
    if (allowed) {
      return VoiceTokenAllowed.fromJson(json);
    }
    return VoiceTokenDenied.fromJson(json);
  }

  Map<String, dynamic> toJson();
}

class VoiceTokenAllowed extends VoiceTokenResponse {
  const VoiceTokenAllowed({
    required this.token,
    required this.agentId,
    required this.elevenUserId,
    required this.usedSeconds,
    required this.limitSeconds,
  });

  @override
  bool get allowed => true;

  final String token;
  @override
  final String agentId;
  final String elevenUserId;
  @override
  final double usedSeconds;
  @override
  final double limitSeconds;

  factory VoiceTokenAllowed.fromJson(Map<String, dynamic> json) {
    return VoiceTokenAllowed(
      token: json['token'] as String,
      agentId: json['agentId'] as String,
      elevenUserId: json['elevenUserId'] as String,
      usedSeconds: (json['usedSeconds'] as num).toDouble(),
      limitSeconds: (json['limitSeconds'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'allowed': true,
        'token': token,
        'agentId': agentId,
        'elevenUserId': elevenUserId,
        'usedSeconds': usedSeconds,
        'limitSeconds': limitSeconds,
      };
}

class VoiceTokenDenied extends VoiceTokenResponse {
  const VoiceTokenDenied({
    required this.reason,
    required this.usedSeconds,
    required this.limitSeconds,
    required this.agentId,
  });

  @override
  bool get allowed => false;

  final String reason;
  @override
  final double usedSeconds;
  @override
  final double limitSeconds;
  @override
  final String agentId;

  factory VoiceTokenDenied.fromJson(Map<String, dynamic> json) {
    return VoiceTokenDenied(
      reason: json['reason'] as String,
      usedSeconds: (json['usedSeconds'] as num).toDouble(),
      limitSeconds: (json['limitSeconds'] as num).toDouble(),
      agentId: json['agentId'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'allowed': false,
        'reason': reason,
        'usedSeconds': usedSeconds,
        'limitSeconds': limitSeconds,
        'agentId': agentId,
      };
}

// ---------------------------------------------------------------------------
// Legacy protocol — User & Agent messages
// ---------------------------------------------------------------------------

class UserMessageContent {
  const UserMessageContent({required this.text, this.type = 'text'});

  final String type;
  final String text;

  factory UserMessageContent.fromJson(Map<String, dynamic> json) {
    return UserMessageContent(
      type: json['type'] as String? ?? 'text',
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'text': text};
}

class UserMessage {
  const UserMessage({
    required this.content,
    this.localKey,
    this.meta,
  });

  String get role => 'user';

  final UserMessageContent content;
  final String? localKey;
  final MessageMeta? meta;

  factory UserMessage.fromJson(Map<String, dynamic> json) {
    return UserMessage(
      content: UserMessageContent.fromJson(
        json['content'] as Map<String, dynamic>,
      ),
      localKey: json['localKey'] as String?,
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content.toJson(),
        if (localKey != null) 'localKey': localKey,
        if (meta != null) 'meta': meta!.toJson(),
      };
}

class AgentMessage {
  const AgentMessage({
    required this.content,
    this.meta,
  });

  String get role => 'agent';

  final Map<String, dynamic> content;
  final MessageMeta? meta;

  factory AgentMessage.fromJson(Map<String, dynamic> json) {
    return AgentMessage(
      content: Map<String, dynamic>.from(json['content'] as Map),
      meta: json['meta'] != null
          ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
        if (meta != null) 'meta': meta!.toJson(),
      };
}
