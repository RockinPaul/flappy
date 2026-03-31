# Flutter Migration Plan: happy-app (React Native/Expo) -> happy-flutter (Flutter)

## Context

**Happy Coder** is a multi-platform mobile app for remote control of Claude Code AI coding sessions. The current mobile client (`packages/happy-app`) is built with React Native (Expo 55) + TypeScript. It features E2E encryption, real-time WebSocket sync, voice communication (LiveKit + ElevenLabs), in-app purchases, and 9-language i18n support across ~82,000 lines of code in ~995 files.

**Why migrate**: Rewrite the mobile client in Flutter as a new `packages/happy-flutter` package, targeting iOS and Android. Web stays on React Native (Expo) — Flutter Web is not recommended due to text rendering limitations, bundle size, and existing Tauri desktop integration.

**Flutter skills status**: No Flutter/Dart skills exist in the skills.sh ecosystem. No skills to install — we proceed with general-purpose capabilities.

---

## Dependency Mapping: React Native -> Flutter

| React Native / Expo | Flutter Equivalent | Notes |
|---|---|---|
| Expo Router (file-based) | `go_router` | Named routes + ShellRoute for nested navigation |
| Zustand | `riverpod` | Closest to Zustand's simplicity; split into focused providers |
| Socket.io-client | `socket_io_client` | Mature Dart port, near 1:1 API |
| `@more-tech/react-native-libsodium` | `sodium_libs` (FFI) or `pinenacl` (pure Dart) | Must be byte-compatible with existing encryption |
| `rn-encryption` (AES) | `pointycastle` or `cryptography` | AES-256-GCM |
| LiveKit | `livekit_client` | Official Flutter SDK |
| ElevenLabs | Custom HTTP + WebSocket | No official Flutter SDK; build minimal client |
| Unistyles | Flutter `ThemeData` + `ThemeExtension` | Built-in theming |
| RevenueCat | `purchases_flutter` | Official SDK |
| PostHog | `posthog_flutter` | Official SDK |
| react-native-mmkv | `hive` | Fast typed key-value storage |
| expo-secure-store | `flutter_secure_storage` | Keychain/Keystore abstraction |
| Zod | `freezed` + `json_serializable` | Code gen replaces runtime validation |
| expo-camera (QR) | `mobile_scanner` | QR/barcode scanning |
| expo-notifications | `firebase_messaging` + `flutter_local_notifications` | Standard Flutter approach |
| react-native-reanimated | Flutter animations (built-in) | Native animation system |
| Markdown rendering | `flutter_markdown` | Mature package |
| Syntax highlighting | `flutter_highlight` | Code blocks |
| Diff rendering | `diffutil_dart` or custom | Unified diff |
| Axios | `dio` | HTTP client with interceptors |
| expo-image | `cached_network_image` | Image loading/caching |
| Lottie | `lottie` | Official Flutter package |
| Fuse.js | `fuzzy` or `fuse_dart` | Fuzzy search |

---

## Phased Migration Plan

### Phase 0: Project Scaffolding (2-3 weeks) — Low complexity

1. Create `packages/happy-flutter/` as a Flutter project (iOS + Android)
2. Set up project structure:
   ```
   lib/
   ├── app/             # go_router route definitions
   ├── auth/            # Authentication
   ├── core/            # Config, logging, errors
   ├── encryption/      # Crypto primitives
   ├── models/          # Data models (from storageTypes, typesMessage, etc.)
   ├── providers/       # Riverpod state providers
   ├── services/        # Sync engine, API clients, socket
   ├── ui/              # Widgets
   │   ├── chat/
   │   ├── tools/
   │   ├── markdown/
   │   └── common/
   ├── i18n/            # Internationalization
   └── utils/           # Utilities
   ```
3. Configure `pubspec.yaml` with core dependencies
4. Port theming from `packages/happy-app/sources/theme.ts` to `ThemeData` + `ThemeExtension<HappyTheme>` (light/dark)
5. Port breakpoint system from `packages/happy-app/sources/unistyles.ts`
6. Configure environment flavors (dev/preview/production)

---

### Phase 1: Protocol Types + Encryption Layer (3-4 weeks) — Very High complexity

**Phase 1A: Port happy-wire types to Dart (1-2 weeks)**

Port Zod schemas to `freezed` + `json_serializable` classes:
- `packages/happy-wire/src/messages.ts` — SessionMessageSchema, MessageContentSchema
- `packages/happy-wire/src/legacyProtocol.ts` — UserMessageSchema, AgentMessageSchema
- `packages/happy-wire/src/voice.ts` — VoiceTokenResponseSchema
- `packages/happy-app/sources/sync/storageTypes.ts` — Session, Machine, MetadataSchema, AgentStateSchema
- `packages/happy-app/sources/sync/typesMessage.ts` — Message, ToolCall, UserTextMessage, AgentTextMessage
- `packages/happy-app/sources/sync/apiTypes.ts` — ApiUpdateSchema and update sub-types
- `packages/happy-app/sources/sync/typesRaw.ts` — NormalizedMessage, AgentEvent, UsageData

**Phase 1B: Port Encryption Layer (2 weeks)**

Critical files to port (must be byte-compatible with existing TypeScript implementation):

Low-level primitives (`packages/happy-app/sources/encryption/`):
- `libsodium.ts` — NaCl box/secretbox -> `sodium_libs` or `pinenacl`
- `aes.ts` — AES-256-GCM -> `pointycastle` or `cryptography`
- `deriveKey.ts` — HMAC-SHA512 HD key derivation (custom logic)
- `hmac_sha512.ts` — HMAC-SHA512
- `base64.ts`, `hex.ts`, `text.ts` — encoding utilities -> `dart:convert`

High-level encryption (`packages/happy-app/sources/sync/encryption/`):
- `encryptor.ts` — Encryptor/Decryptor interfaces, SecretBoxEncryption, BoxEncryption, AES256Encryption
- `encryption.ts` — Master Encryption class, key management
- `sessionEncryption.ts` — Per-session encryption
- `machineEncryption.ts` — Per-machine encryption
- `encryptionCache.ts` — Decryption caching
- `artifactEncryption.ts` — Artifact encryption

**Verification**: Create shared test vectors — encrypt with TypeScript, decrypt with Dart (and vice versa). Pay attention to nonce bundling format, AES-GCM version byte prefix (`0x00`), HMAC-SHA512 key derivation paths.

---

### Phase 2: Authentication + Storage (2 weeks) — Medium complexity

- `packages/happy-app/sources/auth/tokenStorage.ts` -> `flutter_secure_storage`
- `packages/happy-app/sources/auth/authQRStart.ts` — Generate keypair, POST to server
- `packages/happy-app/sources/auth/authQRWait.ts` — Poll for challenge
- `packages/happy-app/sources/auth/authChallenge.ts` — Challenge-response decryption
- `packages/happy-app/sources/auth/authApprove.ts` — Approval flow
- `packages/happy-app/sources/auth/secretKeyBackup.ts` — Key backup/restore
- QR scanning: `mobile_scanner`; QR generation: `qr_flutter`
- Local persistence: `packages/happy-app/sources/sync/persistence.ts` -> `hive`
- Auth state: `AuthContext.tsx` -> Riverpod provider

---

### Phase 3: Sync Engine Core (4-5 weeks) — Very High complexity

**3A: Socket Connection (1 week)**
- `packages/happy-app/sources/sync/apiSocket.ts` -> `socket_io_client`
- Auth handshake, reconnection, message handlers

**3B: InvalidateSync Utility (0.5 weeks)**
- `packages/happy-app/sources/utils/sync.ts` — Debounced serialized async task execution (used 12+ times in Sync class)

**3C: Zustand Store -> Riverpod (1-2 weeks)**
- `packages/happy-app/sources/sync/storage.ts` (1,363 lines) — Split into focused providers:
  - `sessionsProvider`, `machinesProvider`, `settingsProvider`, `purchasesProvider`
  - `profileProvider`, `messagesProvider` (per-session family), `friendsProvider`, `feedProvider`

**3D: Message Reducer (1-2 weeks)**
- `packages/happy-app/sources/sync/reducer/reducer.ts` (1,223 lines) — 5+ processing phases
- `packages/happy-app/sources/sync/reducer/reducerTracer.ts` — Sidechain tracer
- `packages/happy-app/sources/sync/reducer/activityUpdateAccumulator.ts`
- Port existing `reducer.spec.ts` tests first, then implement to pass them

**3E: Main Sync Class (1 week)**
- `packages/happy-app/sources/sync/sync.ts` (2,287 lines) — Session/message fetching, encryption/decryption, outbox, background processing
- Supporting API files: `apiPush.ts`, `apiGithub.ts`, `apiServices.ts`, `apiKv.ts`, `apiUsage.ts`, `apiVoice.ts`, `apiFriends.ts`, `apiFeed.ts`, `apiArtifacts.ts`
- Config: `serverConfig.ts`, `settings.ts`, `profile.ts`, `purchases.ts`
- Git: `gitStatusSync.ts`, `gitStatusFiles.ts`, `projectManager.ts`

---

### Phase 4: Core UI + Navigation (3-4 weeks) — Medium-High complexity

**4A: Navigation Shell (1 week)**
- Port ~30 routes from `packages/happy-app/sources/app/(app)/` to `go_router`
- Sidebar navigator for tablet from `SidebarNavigator.tsx`
- Tab bar (Home, Inbox, Friends, Settings) from `TabBar.tsx`
- Custom header from `components/navigation/Header.tsx`
- Deep linking for push notification routing

**4B: Common Components (1-2 weeks)**
- `Item.tsx`, `ItemList.tsx`, `ItemGroup.tsx` — primary list/settings UI
- `Avatar.tsx` variants (Gradient, Brutalist, Skia)
- `Switch.tsx`, `RoundButton.tsx`, `FAB.tsx`, `FABWide.tsx`
- `StatusDot.tsx`, `ConnectButton.tsx`, `ShimmerView.tsx`
- `MultiTextInput.tsx`, `SearchableListSelector.tsx`
- `layout.ts` (responsive width constraints)

**4C: Settings + Static Screens (1 week)**
- Settings: index, account, appearance, language, features, voice, usage
- Changelog, terminal/connect, restore/manual

---

### Phase 5: Chat UI + Message Rendering (3-4 weeks) — High complexity

**5A: Message Rendering (2 weeks)**
- `MessageView.tsx`, `ChatList.tsx` (inverted list), `ChatHeaderView.tsx`, `ChatFooter.tsx`
- `AgentInput.tsx` + autocomplete system
- Markdown: `markdown/MarkdownView.tsx`, `parseMarkdown.ts` -> `flutter_markdown`
- Code: `CodeView.tsx`, `SimpleSyntaxHighlighter.tsx` -> `flutter_highlight`
- Diff: `diff/DiffView.tsx`, `diff/calculateDiff.ts`

**5B: Tool Call UI (1-2 weeks)**
- `components/tools/` — ToolView, ToolFullView, ToolHeader, ToolStatusIndicator
- Individual tools: BashView, EditView, WriteView, MultiEditView, TaskView, TodoView, MCPToolView
- `PermissionFooter.tsx`, `knownTools.tsx`

**5C: Session Screens (1 week)**
- `session/[id].tsx`, `session/[id]/info.tsx`, `session/[id]/files.tsx`, `session/[id]/file.tsx`
- `session/[id]/message/[messageId].tsx`, `session/recent.tsx`

---

### Phase 6: Home Screen + Sessions List (2 weeks) — Medium-High complexity

- `(app)/index.tsx`, `SessionsList.tsx`, `ActiveSessionsGroup.tsx`
- `MainView.tsx` (phone/tablet layouts), `SidebarView.tsx`
- `HomeHeader.tsx`, `InboxView.tsx`, `FeedItemCard.tsx`
- Git status components, VoiceAssistantStatusBar
- New session: `new/index.tsx`, Machine: `machine/[id].tsx`

---

### Phase 7: Internationalization (1-2 weeks) — Medium complexity (mechanical)

- Port 10 language files from `packages/happy-app/sources/text/translations/` to JSON/ARB
- Use `easy_localization` for dot-notation keys + parameterized strings
- Current languages: en, ru, pl, es, ca, it, pt, ja, zh-Hans
- Integrate incrementally from Phase 4 onward

---

### Phase 8: Voice Communication (2 weeks) — High complexity

- `packages/happy-app/sources/realtime/RealtimeSession.ts` — Voice session lifecycle
- LiveKit: `livekit_client` official Flutter SDK
- ElevenLabs: Custom WebSocket + REST client (no official Flutter SDK)
  - Study React Native SDK source for WebSocket protocol
  - Audio: `just_audio` for playback, `record` for recording
- Voice hooks, context formatters, client tools

---

### Phase 9: In-App Purchases + Analytics (1-2 weeks) — Medium complexity

- RevenueCat: `purchases_flutter` official SDK (from `sync/revenueCat/`)
- PostHog: `posthog_flutter` (from `track/`)
- Push notifications: `firebase_messaging` + `flutter_local_notifications` (from `sync/pushRegistration.ts`)
- Notification routing from `utils/notificationRouting.ts`

---

### Phase 10: Social Features + Remaining (2-3 weeks) — Medium complexity

- Friends: list, search, user profile
- Artifacts: gallery, detail, create, edit
- OAuth, server status, command palette (primarily web — may defer)

---

### Phase 11: Testing + QA (ongoing + 2-3 weeks dedicated)

1. **Unit tests**: Encryption round-trips (cross-platform vectors), reducer tests (port `reducer.spec.ts`), message parsing, utilities
2. **Integration tests**: Socket.io connection flow, full auth flow, encrypt-send-receive-decrypt round trip
3. **Widget tests**: MessageView, ChatList, ToolView, navigation flows
4. **E2E tests** (Flutter `integration_test`): Login, session creation, messaging, settings
5. **Cross-compatibility**: Verify Flutter can read RN-stored data, encrypted data interoperable both ways

---

## Key Risk Areas

| Risk | Severity | Mitigation |
|------|----------|------------|
| Encryption byte-compatibility | Critical | Shared test vector file validated by both TS and Dart implementations |
| Sync engine complexity (2,287 lines) | High | Port incrementally, test each API method individually |
| Reducer correctness (1,223 lines) | High | Port tests first, implement to pass them |
| ElevenLabs without official SDK | Medium | Study RN SDK source for WebSocket protocol, build minimal client |
| Running two apps in monorepo | Low | Both share same server API; happy-wire protocol is the contract |

## Web Platform Decision

**Recommendation: Keep web on React Native (Expo).** Flutter Web has worse text rendering, larger bundles, and the existing app has extensive web-specific code (Tauri integration, CSS, keyboard shortcuts via `useGlobalKeyboard`, ~10 `.web.tsx` component variants). Focus Flutter on iOS and Android only.

---

## Critical Files Reference

| File | Lines | Role |
|------|-------|------|
| `packages/happy-app/sources/sync/sync.ts` | 2,287 | Main sync engine |
| `packages/happy-app/sources/sync/storage.ts` | 1,363 | Entire app state (Zustand) |
| `packages/happy-app/sources/sync/reducer/reducer.ts` | 1,223 | Message processing |
| `packages/happy-app/sources/sync/encryption/encryptor.ts` | — | Encryption abstraction |
| `packages/happy-app/sources/sync/encryption/encryption.ts` | — | Master key management |
| `packages/happy-app/sources/theme.ts` | — | Theme definitions |
| `packages/happy-wire/src/messages.ts` | — | Wire protocol types |
| `packages/happy-app/sources/app/(app)/_layout.tsx` | — | Navigation structure |
