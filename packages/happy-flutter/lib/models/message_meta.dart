/// Message metadata shared across wire protocol and app types.
///
/// Ported from packages/happy-wire/src/messageMeta.ts
/// and packages/happy-app/sources/sync/typesMessageMeta.ts
class MessageMeta {
  const MessageMeta({
    this.sentFrom,
    this.permissionMode,
    this.model,
    this.fallbackModel,
    this.customSystemPrompt,
    this.appendSystemPrompt,
    this.allowedTools,
    this.disallowedTools,
    this.displayText,
  });

  final String? sentFrom;
  final String? permissionMode;
  final String? model;
  final String? fallbackModel;
  final String? customSystemPrompt;
  final String? appendSystemPrompt;
  final List<String>? allowedTools;
  final List<String>? disallowedTools;
  final String? displayText;

  factory MessageMeta.fromJson(Map<String, dynamic> json) {
    return MessageMeta(
      sentFrom: json['sentFrom'] as String?,
      permissionMode: json['permissionMode'] as String?,
      model: json['model'] as String?,
      fallbackModel: json['fallbackModel'] as String?,
      customSystemPrompt: json['customSystemPrompt'] as String?,
      appendSystemPrompt: json['appendSystemPrompt'] as String?,
      allowedTools: (json['allowedTools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      disallowedTools: (json['disallowedTools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      displayText: json['displayText'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (sentFrom != null) 'sentFrom': sentFrom,
      if (permissionMode != null) 'permissionMode': permissionMode,
      if (model != null) 'model': model,
      if (fallbackModel != null) 'fallbackModel': fallbackModel,
      if (customSystemPrompt != null) 'customSystemPrompt': customSystemPrompt,
      if (appendSystemPrompt != null) 'appendSystemPrompt': appendSystemPrompt,
      if (allowedTools != null) 'allowedTools': allowedTools,
      if (disallowedTools != null) 'disallowedTools': disallowedTools,
      if (displayText != null) 'displayText': displayText,
    };
  }
}
