import 'package:flutter/material.dart';

/// Shared spacing constants used by both light and dark themes.
class HappySpacing {
  const HappySpacing._();

  // Margins
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  // Border radii
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 10;
  static const double radiusXl = 12;
  static const double radiusXxl = 16;

  // Icon sizes
  static const double iconSmall = 12;
  static const double iconMedium = 16;
  static const double iconLarge = 20;
  static const double iconXlarge = 24;
}

/// Custom color properties that extend Material's ColorScheme.
@immutable
class HappyColors extends ThemeExtension<HappyColors> {
  const HappyColors({
    // Main
    required this.textDestructive,
    required this.textSecondary,
    required this.textLink,
    required this.deleteAction,
    required this.warningCritical,
    required this.warning,
    required this.success,
    required this.surfaceRipple,
    required this.surfacePressed,
    required this.surfaceSelected,
    required this.surfaceHigh,
    required this.surfaceHighest,
    required this.divider,
    // Header
    required this.headerBackground,
    required this.headerTint,
    // Switch
    required this.switchTrackActive,
    required this.switchTrackInactive,
    required this.switchThumbActive,
    required this.switchThumbInactive,
    // Grouped
    required this.grouppedBackground,
    required this.grouppedChevron,
    required this.grouppedSectionTitle,
    // FAB
    required this.fabBackground,
    required this.fabBackgroundPressed,
    required this.fabIcon,
    // Radio
    required this.radioActive,
    required this.radioInactive,
    required this.radioDot,
    // Button
    required this.buttonPrimaryBackground,
    required this.buttonPrimaryTint,
    required this.buttonPrimaryDisabled,
    required this.buttonSecondaryTint,
    // Input
    required this.inputBackground,
    required this.inputText,
    required this.inputPlaceholder,
    // Status
    required this.statusConnected,
    required this.statusConnecting,
    required this.statusDisconnected,
    required this.statusError,
    // Permission
    required this.permissionDefault,
    required this.permissionAcceptEdits,
    required this.permissionBypass,
    required this.permissionPlan,
    required this.permissionReadOnly,
    required this.permissionSafeYolo,
    required this.permissionYolo,
    // Permission buttons
    required this.permissionAllowBg,
    required this.permissionDenyBg,
    required this.permissionAllowAllBg,
    // Diff
    required this.diffAddedBg,
    required this.diffAddedText,
    required this.diffRemovedBg,
    required this.diffRemovedText,
    required this.diffContextBg,
    required this.diffContextText,
    required this.diffLineNumberBg,
    required this.diffLineNumberText,
    required this.diffHunkHeaderBg,
    required this.diffHunkHeaderText,
    // Messages
    required this.userMessageBackground,
    required this.userMessageText,
    required this.agentMessageText,
    required this.agentEventText,
    // Syntax
    required this.syntaxKeyword,
    required this.syntaxString,
    required this.syntaxComment,
    required this.syntaxNumber,
    required this.syntaxFunction,
    required this.syntaxDefault,
    // Git
    required this.gitBranchText,
    required this.gitAddedText,
    required this.gitRemovedText,
    // Terminal
    required this.terminalBackground,
    required this.terminalPrompt,
    required this.terminalCommand,
    required this.terminalStdout,
    required this.terminalStderr,
    required this.terminalError,
  });

  // Main
  final Color textDestructive;
  final Color textSecondary;
  final Color textLink;
  final Color deleteAction;
  final Color warningCritical;
  final Color warning;
  final Color success;
  final Color surfaceRipple;
  final Color surfacePressed;
  final Color surfaceSelected;
  final Color surfaceHigh;
  final Color surfaceHighest;
  final Color divider;
  // Header
  final Color headerBackground;
  final Color headerTint;
  // Switch
  final Color switchTrackActive;
  final Color switchTrackInactive;
  final Color switchThumbActive;
  final Color switchThumbInactive;
  // Grouped
  final Color grouppedBackground;
  final Color grouppedChevron;
  final Color grouppedSectionTitle;
  // FAB
  final Color fabBackground;
  final Color fabBackgroundPressed;
  final Color fabIcon;
  // Radio
  final Color radioActive;
  final Color radioInactive;
  final Color radioDot;
  // Button
  final Color buttonPrimaryBackground;
  final Color buttonPrimaryTint;
  final Color buttonPrimaryDisabled;
  final Color buttonSecondaryTint;
  // Input
  final Color inputBackground;
  final Color inputText;
  final Color inputPlaceholder;
  // Status
  final Color statusConnected;
  final Color statusConnecting;
  final Color statusDisconnected;
  final Color statusError;
  // Permission
  final Color permissionDefault;
  final Color permissionAcceptEdits;
  final Color permissionBypass;
  final Color permissionPlan;
  final Color permissionReadOnly;
  final Color permissionSafeYolo;
  final Color permissionYolo;
  // Permission buttons
  final Color permissionAllowBg;
  final Color permissionDenyBg;
  final Color permissionAllowAllBg;
  // Diff
  final Color diffAddedBg;
  final Color diffAddedText;
  final Color diffRemovedBg;
  final Color diffRemovedText;
  final Color diffContextBg;
  final Color diffContextText;
  final Color diffLineNumberBg;
  final Color diffLineNumberText;
  final Color diffHunkHeaderBg;
  final Color diffHunkHeaderText;
  // Messages
  final Color userMessageBackground;
  final Color userMessageText;
  final Color agentMessageText;
  final Color agentEventText;
  // Syntax
  final Color syntaxKeyword;
  final Color syntaxString;
  final Color syntaxComment;
  final Color syntaxNumber;
  final Color syntaxFunction;
  final Color syntaxDefault;
  // Git
  final Color gitBranchText;
  final Color gitAddedText;
  final Color gitRemovedText;
  // Terminal
  final Color terminalBackground;
  final Color terminalPrompt;
  final Color terminalCommand;
  final Color terminalStdout;
  final Color terminalStderr;
  final Color terminalError;

  @override
  HappyColors copyWith({
    Color? textDestructive,
    Color? textSecondary,
    Color? textLink,
    Color? deleteAction,
    Color? warningCritical,
    Color? warning,
    Color? success,
    Color? surfaceRipple,
    Color? surfacePressed,
    Color? surfaceSelected,
    Color? surfaceHigh,
    Color? surfaceHighest,
    Color? divider,
    Color? headerBackground,
    Color? headerTint,
    Color? switchTrackActive,
    Color? switchTrackInactive,
    Color? switchThumbActive,
    Color? switchThumbInactive,
    Color? grouppedBackground,
    Color? grouppedChevron,
    Color? grouppedSectionTitle,
    Color? fabBackground,
    Color? fabBackgroundPressed,
    Color? fabIcon,
    Color? radioActive,
    Color? radioInactive,
    Color? radioDot,
    Color? buttonPrimaryBackground,
    Color? buttonPrimaryTint,
    Color? buttonPrimaryDisabled,
    Color? buttonSecondaryTint,
    Color? inputBackground,
    Color? inputText,
    Color? inputPlaceholder,
    Color? statusConnected,
    Color? statusConnecting,
    Color? statusDisconnected,
    Color? statusError,
    Color? permissionDefault,
    Color? permissionAcceptEdits,
    Color? permissionBypass,
    Color? permissionPlan,
    Color? permissionReadOnly,
    Color? permissionSafeYolo,
    Color? permissionYolo,
    Color? permissionAllowBg,
    Color? permissionDenyBg,
    Color? permissionAllowAllBg,
    Color? diffAddedBg,
    Color? diffAddedText,
    Color? diffRemovedBg,
    Color? diffRemovedText,
    Color? diffContextBg,
    Color? diffContextText,
    Color? diffLineNumberBg,
    Color? diffLineNumberText,
    Color? diffHunkHeaderBg,
    Color? diffHunkHeaderText,
    Color? userMessageBackground,
    Color? userMessageText,
    Color? agentMessageText,
    Color? agentEventText,
    Color? syntaxKeyword,
    Color? syntaxString,
    Color? syntaxComment,
    Color? syntaxNumber,
    Color? syntaxFunction,
    Color? syntaxDefault,
    Color? gitBranchText,
    Color? gitAddedText,
    Color? gitRemovedText,
    Color? terminalBackground,
    Color? terminalPrompt,
    Color? terminalCommand,
    Color? terminalStdout,
    Color? terminalStderr,
    Color? terminalError,
  }) {
    return HappyColors(
      textDestructive: textDestructive ?? this.textDestructive,
      textSecondary: textSecondary ?? this.textSecondary,
      textLink: textLink ?? this.textLink,
      deleteAction: deleteAction ?? this.deleteAction,
      warningCritical: warningCritical ?? this.warningCritical,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      surfaceRipple: surfaceRipple ?? this.surfaceRipple,
      surfacePressed: surfacePressed ?? this.surfacePressed,
      surfaceSelected: surfaceSelected ?? this.surfaceSelected,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      surfaceHighest: surfaceHighest ?? this.surfaceHighest,
      divider: divider ?? this.divider,
      headerBackground: headerBackground ?? this.headerBackground,
      headerTint: headerTint ?? this.headerTint,
      switchTrackActive: switchTrackActive ?? this.switchTrackActive,
      switchTrackInactive: switchTrackInactive ?? this.switchTrackInactive,
      switchThumbActive: switchThumbActive ?? this.switchThumbActive,
      switchThumbInactive: switchThumbInactive ?? this.switchThumbInactive,
      grouppedBackground: grouppedBackground ?? this.grouppedBackground,
      grouppedChevron: grouppedChevron ?? this.grouppedChevron,
      grouppedSectionTitle: grouppedSectionTitle ?? this.grouppedSectionTitle,
      fabBackground: fabBackground ?? this.fabBackground,
      fabBackgroundPressed: fabBackgroundPressed ?? this.fabBackgroundPressed,
      fabIcon: fabIcon ?? this.fabIcon,
      radioActive: radioActive ?? this.radioActive,
      radioInactive: radioInactive ?? this.radioInactive,
      radioDot: radioDot ?? this.radioDot,
      buttonPrimaryBackground: buttonPrimaryBackground ?? this.buttonPrimaryBackground,
      buttonPrimaryTint: buttonPrimaryTint ?? this.buttonPrimaryTint,
      buttonPrimaryDisabled: buttonPrimaryDisabled ?? this.buttonPrimaryDisabled,
      buttonSecondaryTint: buttonSecondaryTint ?? this.buttonSecondaryTint,
      inputBackground: inputBackground ?? this.inputBackground,
      inputText: inputText ?? this.inputText,
      inputPlaceholder: inputPlaceholder ?? this.inputPlaceholder,
      statusConnected: statusConnected ?? this.statusConnected,
      statusConnecting: statusConnecting ?? this.statusConnecting,
      statusDisconnected: statusDisconnected ?? this.statusDisconnected,
      statusError: statusError ?? this.statusError,
      permissionDefault: permissionDefault ?? this.permissionDefault,
      permissionAcceptEdits: permissionAcceptEdits ?? this.permissionAcceptEdits,
      permissionBypass: permissionBypass ?? this.permissionBypass,
      permissionPlan: permissionPlan ?? this.permissionPlan,
      permissionReadOnly: permissionReadOnly ?? this.permissionReadOnly,
      permissionSafeYolo: permissionSafeYolo ?? this.permissionSafeYolo,
      permissionYolo: permissionYolo ?? this.permissionYolo,
      permissionAllowBg: permissionAllowBg ?? this.permissionAllowBg,
      permissionDenyBg: permissionDenyBg ?? this.permissionDenyBg,
      permissionAllowAllBg: permissionAllowAllBg ?? this.permissionAllowAllBg,
      diffAddedBg: diffAddedBg ?? this.diffAddedBg,
      diffAddedText: diffAddedText ?? this.diffAddedText,
      diffRemovedBg: diffRemovedBg ?? this.diffRemovedBg,
      diffRemovedText: diffRemovedText ?? this.diffRemovedText,
      diffContextBg: diffContextBg ?? this.diffContextBg,
      diffContextText: diffContextText ?? this.diffContextText,
      diffLineNumberBg: diffLineNumberBg ?? this.diffLineNumberBg,
      diffLineNumberText: diffLineNumberText ?? this.diffLineNumberText,
      diffHunkHeaderBg: diffHunkHeaderBg ?? this.diffHunkHeaderBg,
      diffHunkHeaderText: diffHunkHeaderText ?? this.diffHunkHeaderText,
      userMessageBackground: userMessageBackground ?? this.userMessageBackground,
      userMessageText: userMessageText ?? this.userMessageText,
      agentMessageText: agentMessageText ?? this.agentMessageText,
      agentEventText: agentEventText ?? this.agentEventText,
      syntaxKeyword: syntaxKeyword ?? this.syntaxKeyword,
      syntaxString: syntaxString ?? this.syntaxString,
      syntaxComment: syntaxComment ?? this.syntaxComment,
      syntaxNumber: syntaxNumber ?? this.syntaxNumber,
      syntaxFunction: syntaxFunction ?? this.syntaxFunction,
      syntaxDefault: syntaxDefault ?? this.syntaxDefault,
      gitBranchText: gitBranchText ?? this.gitBranchText,
      gitAddedText: gitAddedText ?? this.gitAddedText,
      gitRemovedText: gitRemovedText ?? this.gitRemovedText,
      terminalBackground: terminalBackground ?? this.terminalBackground,
      terminalPrompt: terminalPrompt ?? this.terminalPrompt,
      terminalCommand: terminalCommand ?? this.terminalCommand,
      terminalStdout: terminalStdout ?? this.terminalStdout,
      terminalStderr: terminalStderr ?? this.terminalStderr,
      terminalError: terminalError ?? this.terminalError,
    );
  }

  @override
  HappyColors lerp(ThemeExtension<HappyColors>? other, double t) {
    if (other is! HappyColors) return this;
    return HappyColors(
      textDestructive: Color.lerp(textDestructive, other.textDestructive, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      deleteAction: Color.lerp(deleteAction, other.deleteAction, t)!,
      warningCritical: Color.lerp(warningCritical, other.warningCritical, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      surfaceRipple: Color.lerp(surfaceRipple, other.surfaceRipple, t)!,
      surfacePressed: Color.lerp(surfacePressed, other.surfacePressed, t)!,
      surfaceSelected: Color.lerp(surfaceSelected, other.surfaceSelected, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      surfaceHighest: Color.lerp(surfaceHighest, other.surfaceHighest, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      headerBackground: Color.lerp(headerBackground, other.headerBackground, t)!,
      headerTint: Color.lerp(headerTint, other.headerTint, t)!,
      switchTrackActive: Color.lerp(switchTrackActive, other.switchTrackActive, t)!,
      switchTrackInactive: Color.lerp(switchTrackInactive, other.switchTrackInactive, t)!,
      switchThumbActive: Color.lerp(switchThumbActive, other.switchThumbActive, t)!,
      switchThumbInactive: Color.lerp(switchThumbInactive, other.switchThumbInactive, t)!,
      grouppedBackground: Color.lerp(grouppedBackground, other.grouppedBackground, t)!,
      grouppedChevron: Color.lerp(grouppedChevron, other.grouppedChevron, t)!,
      grouppedSectionTitle: Color.lerp(grouppedSectionTitle, other.grouppedSectionTitle, t)!,
      fabBackground: Color.lerp(fabBackground, other.fabBackground, t)!,
      fabBackgroundPressed: Color.lerp(fabBackgroundPressed, other.fabBackgroundPressed, t)!,
      fabIcon: Color.lerp(fabIcon, other.fabIcon, t)!,
      radioActive: Color.lerp(radioActive, other.radioActive, t)!,
      radioInactive: Color.lerp(radioInactive, other.radioInactive, t)!,
      radioDot: Color.lerp(radioDot, other.radioDot, t)!,
      buttonPrimaryBackground: Color.lerp(buttonPrimaryBackground, other.buttonPrimaryBackground, t)!,
      buttonPrimaryTint: Color.lerp(buttonPrimaryTint, other.buttonPrimaryTint, t)!,
      buttonPrimaryDisabled: Color.lerp(buttonPrimaryDisabled, other.buttonPrimaryDisabled, t)!,
      buttonSecondaryTint: Color.lerp(buttonSecondaryTint, other.buttonSecondaryTint, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      inputText: Color.lerp(inputText, other.inputText, t)!,
      inputPlaceholder: Color.lerp(inputPlaceholder, other.inputPlaceholder, t)!,
      statusConnected: Color.lerp(statusConnected, other.statusConnected, t)!,
      statusConnecting: Color.lerp(statusConnecting, other.statusConnecting, t)!,
      statusDisconnected: Color.lerp(statusDisconnected, other.statusDisconnected, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      permissionDefault: Color.lerp(permissionDefault, other.permissionDefault, t)!,
      permissionAcceptEdits: Color.lerp(permissionAcceptEdits, other.permissionAcceptEdits, t)!,
      permissionBypass: Color.lerp(permissionBypass, other.permissionBypass, t)!,
      permissionPlan: Color.lerp(permissionPlan, other.permissionPlan, t)!,
      permissionReadOnly: Color.lerp(permissionReadOnly, other.permissionReadOnly, t)!,
      permissionSafeYolo: Color.lerp(permissionSafeYolo, other.permissionSafeYolo, t)!,
      permissionYolo: Color.lerp(permissionYolo, other.permissionYolo, t)!,
      permissionAllowBg: Color.lerp(permissionAllowBg, other.permissionAllowBg, t)!,
      permissionDenyBg: Color.lerp(permissionDenyBg, other.permissionDenyBg, t)!,
      permissionAllowAllBg: Color.lerp(permissionAllowAllBg, other.permissionAllowAllBg, t)!,
      diffAddedBg: Color.lerp(diffAddedBg, other.diffAddedBg, t)!,
      diffAddedText: Color.lerp(diffAddedText, other.diffAddedText, t)!,
      diffRemovedBg: Color.lerp(diffRemovedBg, other.diffRemovedBg, t)!,
      diffRemovedText: Color.lerp(diffRemovedText, other.diffRemovedText, t)!,
      diffContextBg: Color.lerp(diffContextBg, other.diffContextBg, t)!,
      diffContextText: Color.lerp(diffContextText, other.diffContextText, t)!,
      diffLineNumberBg: Color.lerp(diffLineNumberBg, other.diffLineNumberBg, t)!,
      diffLineNumberText: Color.lerp(diffLineNumberText, other.diffLineNumberText, t)!,
      diffHunkHeaderBg: Color.lerp(diffHunkHeaderBg, other.diffHunkHeaderBg, t)!,
      diffHunkHeaderText: Color.lerp(diffHunkHeaderText, other.diffHunkHeaderText, t)!,
      userMessageBackground: Color.lerp(userMessageBackground, other.userMessageBackground, t)!,
      userMessageText: Color.lerp(userMessageText, other.userMessageText, t)!,
      agentMessageText: Color.lerp(agentMessageText, other.agentMessageText, t)!,
      agentEventText: Color.lerp(agentEventText, other.agentEventText, t)!,
      syntaxKeyword: Color.lerp(syntaxKeyword, other.syntaxKeyword, t)!,
      syntaxString: Color.lerp(syntaxString, other.syntaxString, t)!,
      syntaxComment: Color.lerp(syntaxComment, other.syntaxComment, t)!,
      syntaxNumber: Color.lerp(syntaxNumber, other.syntaxNumber, t)!,
      syntaxFunction: Color.lerp(syntaxFunction, other.syntaxFunction, t)!,
      syntaxDefault: Color.lerp(syntaxDefault, other.syntaxDefault, t)!,
      gitBranchText: Color.lerp(gitBranchText, other.gitBranchText, t)!,
      gitAddedText: Color.lerp(gitAddedText, other.gitAddedText, t)!,
      gitRemovedText: Color.lerp(gitRemovedText, other.gitRemovedText, t)!,
      terminalBackground: Color.lerp(terminalBackground, other.terminalBackground, t)!,
      terminalPrompt: Color.lerp(terminalPrompt, other.terminalPrompt, t)!,
      terminalCommand: Color.lerp(terminalCommand, other.terminalCommand, t)!,
      terminalStdout: Color.lerp(terminalStdout, other.terminalStdout, t)!,
      terminalStderr: Color.lerp(terminalStderr, other.terminalStderr, t)!,
      terminalError: Color.lerp(terminalError, other.terminalError, t)!,
    );
  }
}

const _lightHappyColors = HappyColors(
  textDestructive: Color(0xFFFF3B30),
  textSecondary: Color(0xFF8E8E93),
  textLink: Color(0xFF2BACCC),
  deleteAction: Color(0xFFFF6B6B),
  warningCritical: Color(0xFFFF3B30),
  warning: Color(0xFF8E8E93),
  success: Color(0xFF34C759),
  surfaceRipple: Color(0x14000000),
  surfacePressed: Color(0xFFF0F0F2),
  surfaceSelected: Color(0xFFEAEAEA),
  surfaceHigh: Color(0xFFF8F8F8),
  surfaceHighest: Color(0xFFF0F0F0),
  divider: Color(0xFFEAEAEA),
  headerBackground: Color(0xFFFFFFFF),
  headerTint: Color(0xFF18171C),
  switchTrackActive: Color(0xFF34C759),
  switchTrackInactive: Color(0xFFDDDDDD),
  switchThumbActive: Color(0xFFFFFFFF),
  switchThumbInactive: Color(0xFF767577),
  grouppedBackground: Color(0xFFF2F2F7),
  grouppedChevron: Color(0xFFC7C7CC),
  grouppedSectionTitle: Color(0xFF8E8E93),
  fabBackground: Color(0xFF000000),
  fabBackgroundPressed: Color(0xFF1A1A1A),
  fabIcon: Color(0xFFFFFFFF),
  radioActive: Color(0xFF007AFF),
  radioInactive: Color(0xFFC0C0C0),
  radioDot: Color(0xFF007AFF),
  buttonPrimaryBackground: Color(0xFF000000),
  buttonPrimaryTint: Color(0xFFFFFFFF),
  buttonPrimaryDisabled: Color(0xFFC0C0C0),
  buttonSecondaryTint: Color(0xFF666666),
  inputBackground: Color(0xFFF5F5F5),
  inputText: Color(0xFF000000),
  inputPlaceholder: Color(0xFF999999),
  statusConnected: Color(0xFF34C759),
  statusConnecting: Color(0xFF007AFF),
  statusDisconnected: Color(0xFF999999),
  statusError: Color(0xFFFF3B30),
  permissionDefault: Color(0xFF8E8E93),
  permissionAcceptEdits: Color(0xFF007AFF),
  permissionBypass: Color(0xFFFF9500),
  permissionPlan: Color(0xFF34C759),
  permissionReadOnly: Color(0xFF8B8B8D),
  permissionSafeYolo: Color(0xFFFF6B35),
  permissionYolo: Color(0xFFDC143C),
  permissionAllowBg: Color(0xFF34C759),
  permissionDenyBg: Color(0xFFFF3B30),
  permissionAllowAllBg: Color(0xFF007AFF),
  diffAddedBg: Color(0xFFE6FFED),
  diffAddedText: Color(0xFF24292E),
  diffRemovedBg: Color(0xFFFFEEF0),
  diffRemovedText: Color(0xFF24292E),
  diffContextBg: Color(0xFFF6F8FA),
  diffContextText: Color(0xFF586069),
  diffLineNumberBg: Color(0xFFF6F8FA),
  diffLineNumberText: Color(0xFF959DA5),
  diffHunkHeaderBg: Color(0xFFF1F8FF),
  diffHunkHeaderText: Color(0xFF005CC5),
  userMessageBackground: Color(0xFFF0EEE6),
  userMessageText: Color(0xFF000000),
  agentMessageText: Color(0xFF000000),
  agentEventText: Color(0xFF666666),
  syntaxKeyword: Color(0xFF1D4ED8),
  syntaxString: Color(0xFF059669),
  syntaxComment: Color(0xFF6B7280),
  syntaxNumber: Color(0xFF0891B2),
  syntaxFunction: Color(0xFF9333EA),
  syntaxDefault: Color(0xFF374151),
  gitBranchText: Color(0xFF6B7280),
  gitAddedText: Color(0xFF22C55E),
  gitRemovedText: Color(0xFFEF4444),
  terminalBackground: Color(0xFF1E1E1E),
  terminalPrompt: Color(0xFF34C759),
  terminalCommand: Color(0xFFE0E0E0),
  terminalStdout: Color(0xFFE0E0E0),
  terminalStderr: Color(0xFFFFB86C),
  terminalError: Color(0xFFFF5555),
);

const _darkHappyColors = HappyColors(
  textDestructive: Color(0xFFFF453A),
  textSecondary: Color(0xFF8E8E93),
  textLink: Color(0xFF2BACCC),
  deleteAction: Color(0xFFFF6B6B),
  warningCritical: Color(0xFFFF453A),
  warning: Color(0xFF8E8E93),
  success: Color(0xFF32D74B),
  surfaceRipple: Color(0x14FFFFFF),
  surfacePressed: Color(0xFF2C2C2E),
  surfaceSelected: Color(0xFF2C2C2E),
  surfaceHigh: Color(0xFF2C2C2E),
  surfaceHighest: Color(0xFF38383A),
  divider: Color(0xFF38383A),
  headerBackground: Color(0xFF18171C),
  headerTint: Color(0xFFFFFFFF),
  switchTrackActive: Color(0xFF34C759),
  switchTrackInactive: Color(0xFF3A393F),
  switchThumbActive: Color(0xFFFFFFFF),
  switchThumbInactive: Color(0xFF767577),
  grouppedBackground: Color(0xFF1C1C1E),
  grouppedChevron: Color(0xFF48484A),
  grouppedSectionTitle: Color(0xFF8E8E93),
  fabBackground: Color(0xFFFFFFFF),
  fabBackgroundPressed: Color(0xFFF0F0F0),
  fabIcon: Color(0xFF000000),
  radioActive: Color(0xFF0A84FF),
  radioInactive: Color(0xFF48484A),
  radioDot: Color(0xFF0A84FF),
  buttonPrimaryBackground: Color(0xFF000000),
  buttonPrimaryTint: Color(0xFFFFFFFF),
  buttonPrimaryDisabled: Color(0xFFC0C0C0),
  buttonSecondaryTint: Color(0xFF8E8E93),
  inputBackground: Color(0xFF1C1C1E),
  inputText: Color(0xFFFFFFFF),
  inputPlaceholder: Color(0xFF8E8E93),
  statusConnected: Color(0xFF34C759),
  statusConnecting: Color(0xFFFFFFFF),
  statusDisconnected: Color(0xFF8E8E93),
  statusError: Color(0xFFFF453A),
  permissionDefault: Color(0xFF8E8E93),
  permissionAcceptEdits: Color(0xFF0A84FF),
  permissionBypass: Color(0xFFFF9F0A),
  permissionPlan: Color(0xFF32D74B),
  permissionReadOnly: Color(0xFF98989D),
  permissionSafeYolo: Color(0xFFFF7A4C),
  permissionYolo: Color(0xFFFF453A),
  permissionAllowBg: Color(0xFF32D74B),
  permissionDenyBg: Color(0xFFFF453A),
  permissionAllowAllBg: Color(0xFF0A84FF),
  diffAddedBg: Color(0xFF0D2E1F),
  diffAddedText: Color(0xFFC9D1D9),
  diffRemovedBg: Color(0xFF3F1B23),
  diffRemovedText: Color(0xFFC9D1D9),
  diffContextBg: Color(0xFF161B22),
  diffContextText: Color(0xFF8B949E),
  diffLineNumberBg: Color(0xFF161B22),
  diffLineNumberText: Color(0xFF6E7681),
  diffHunkHeaderBg: Color(0xFF161B22),
  diffHunkHeaderText: Color(0xFF58A6FF),
  userMessageBackground: Color(0xFF2C2C2E),
  userMessageText: Color(0xFFFFFFFF),
  agentMessageText: Color(0xFFFFFFFF),
  agentEventText: Color(0xFF8E8E93),
  syntaxKeyword: Color(0xFF569CD6),
  syntaxString: Color(0xFFCE9178),
  syntaxComment: Color(0xFF6A9955),
  syntaxNumber: Color(0xFFB5CEA8),
  syntaxFunction: Color(0xFFDCDCAA),
  syntaxDefault: Color(0xFFD4D4D4),
  gitBranchText: Color(0xFF8E8E93),
  gitAddedText: Color(0xFF34C759),
  gitRemovedText: Color(0xFFFF453A),
  terminalBackground: Color(0xFF1E1E1E),
  terminalPrompt: Color(0xFF32D74B),
  terminalCommand: Color(0xFFE0E0E0),
  terminalStdout: Color(0xFFE0E0E0),
  terminalStderr: Color(0xFFFFB86C),
  terminalError: Color(0xFFFF6B6B),
);

/// Builds the light [ThemeData] for the app.
ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF007AFF),
      brightness: Brightness.light,
      surface: const Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xFFF2F2F7),
    fontFamily: 'IBMPlexSans',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      foregroundColor: Color(0xFF18171C),
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEAEAEA),
      thickness: 0.5,
    ),
    extensions: const [_lightHappyColors],
  );
}

/// Builds the dark [ThemeData] for the app.
ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0A84FF),
      brightness: Brightness.dark,
      surface: const Color(0xFF18171C),
    ),
    scaffoldBackgroundColor: const Color(0xFF1C1C1E),
    fontFamily: 'IBMPlexSans',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF18171C),
      foregroundColor: Color(0xFFFFFFFF),
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF38383A),
      thickness: 0.5,
    ),
    extensions: const [_darkHappyColors],
  );
}

/// Convenience extension to access [HappyColors] from [BuildContext].
extension HappyColorsExtension on BuildContext {
  HappyColors get happyColors =>
      Theme.of(this).extension<HappyColors>()!;
}
