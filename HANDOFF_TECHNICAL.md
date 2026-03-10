# JarvisApp — Technical Handoff

_Last updated: 2026-03-09_

## 1. Executive summary

JarvisApp is intended to be the **mobile embodiment of Jarvis**, backed by Jarvis Core/OpenClaw running on the user's Mac mini.

Current state:
- Flutter project exists and compiles.
- macOS app builds successfully.
- Android APK builds successfully.
- Core app shell, navigation, host configuration, chat flow, and voice-capture foundation exist.
- Chat is wired to Jarvis Core via the local OpenAI-compatible gateway endpoint.
- LAN exposure for the gateway was enabled so mobile devices can reach the Mac mini.
- The project is **not yet a closed MVP**. Main unresolved issue is making Android ↔ Jarvis Core feel reliably usable end-to-end.

This handoff is meant to let another AI continue immediately without rediscovering architecture, file locations, environment, or major blockers.

---

## 2. Workspace locations

### Main workspace
- `/Users/aneuyrs/.openclaw/workspace`

### Jarvis mobile project docs / planning
- `/Users/aneuyrs/.openclaw/workspace/jarvis-mobile`

### Actual Flutter app project
- `/Users/aneuyrs/.openclaw/workspace/Proyectos/JarvisApp`

### Flutter application root
- `/Users/aneuyrs/.openclaw/workspace/Proyectos/JarvisApp/app`

### Research system
- `/Users/aneuyrs/.openclaw/workspace/Research`

---

## 3. Product intent

JarvisApp is **not** intended to be a generic chatbot shell.
It is intended to be:
- Jarvis's official mobile embodiment
- connected to Jarvis Core on the main server/Mac mini
- eventually voice-first, but text-safe
- future-ready for household support, voice biometrics, and later a Raspberry Pi embodiment

Current scope should focus on a usable MVP, not all future ideas.

---

## 4. Important planning/docs already created

Inside `jarvis-mobile/` there is a large planning corpus. Important files include:

### Foundational planning
- `VISION.md`
- `EXECUTIVE_SUMMARY.md`
- `SPRINT-1.md`
- `SPRINT-2.md`
- `SPRINT-3.md`

### Product docs
- `PRD.md`
- `BACKLOG.md`
- `MILESTONES.md`
- `PRD-HOUSEHOLD.md`
- `BACKLOG-HOUSEHOLD.md`
- `ROADMAP-EMBODIMENTS.md`
- `SPRINT-3-PLAN.md`
- `IMPLEMENTATION_BACKLOG.md`
- `DECISIONS_OPEN.md`

### UX / UI docs
- `UX_FLOWS.md`
- `SCREEN_SPECS.md`
- `DESIGN_SYSTEM.md`
- `IDENTITY_UX.md`
- `VOICE_ENROLLMENT_FLOW.md`
- `HOUSEHOLD_ADMIN_SCREENS.md`
- some Sprint 3 UI docs were intended, but implementation moved faster than documentation completion

### Architecture / technical docs
- `ARCHITECTURE.md`
- `TECH_DECISIONS.md`
- `BOOTSTRAP_PLAN.md`
- `ARCHITECTURE-HOUSEHOLD.md`
- `VOICE_IDENTITY_ENGINE.md`
- `CLIENTS_AND_EMBODIMENTS.md`
- `FLUTTER_BOOTSTRAP.md`
- `PROJECT_STRUCTURE.md`
- `CORE_API_CONTRACTS.md`

### QA / release docs
- `TEST_PLAN.md`
- `RISK_REGISTER.md`
- `BETA_CHECKLIST.md`
- `TEST_PLAN-HOUSEHOLD.md`
- `VOICE_BIOMETRICS_RISKS.md`
- `SAFETY_GUARDRAILS.md`
- `FOUNDATION_QA.md`
- `DEV_READY_CHECKLIST.md`
- `FOUNDATION_RISKS.md`

### Functional review docs
- `/Users/aneuyrs/.openclaw/workspace/Proyectos/JarvisApp/docs/FUNCTIONAL_GAP_REPORT.md`
- `/Users/aneuyrs/.openclaw/workspace/Proyectos/JarvisApp/docs/BUILD_READINESS_REPORT.md`

The next AI should use these docs for context, but **should prioritize execution over generating more docs**.

---

## 5. Current implementation status

### 5.1 Build/toolchain

Installed and working:
- Flutter
- Dart
- Android Studio
- Android SDK
- CocoaPods
- Xcode (at least sufficiently for builds that were executed)

Previously validated:
- `flutter analyze` has passed multiple times after recent changes.
- `flutter build macos` has succeeded repeatedly.
- `flutter build apk --debug` succeeded.
- `flutter build apk --release --split-per-abi` succeeded.

Known artifact paths:
- macOS app:
  - `Proyectos/JarvisApp/app/build/macos/Build/Products/Release/jarvis_app.app`
- Android debug APK:
  - `Proyectos/JarvisApp/app/build/app/outputs/flutter-apk/app-debug.apk`
- Android arm64 release APK:
  - `Proyectos/JarvisApp/app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

### 5.2 Implemented functionality

Implemented at least in partial form:
- App shell
- Theme
- Bottom navigation
- Splash/startup flow
- Login/setup flow
- Host/base URL configuration and persistence
- Host connection testing
- Chat screen
- Chat request path to Jarvis Core via gateway
- Voice hold-to-record base
- Audio file storage (`.m4a`)
- STT transport path to `/v1/audio/transcriptions`
- Settings screen improved beyond placeholder
- History screen improved beyond placeholder
- Tools screen improved beyond placeholder

### 5.3 Still not fully closed

Not fully solved:
- Truly reliable Android ↔ Jarvis Core usable experience
- Full auth/session flow
- Token handling security for non-dev mode
- Full STT backend compatibility
- TTS playback / response voice loop
- A polished “usable MVP” experience that no longer feels like a prototype

---

## 6. Network / infrastructure details

### Mac mini local LAN IP
- `10.0.0.46`

### Gateway base URL
Originally loopback-only:
- `http://127.0.0.1:18789`

Then changed to LAN bind.
Current intended LAN URL:
- `http://10.0.0.46:18789`

### Important gateway note
The gateway was switched from loopback to LAN by setting:
- `gateway.bind = lan`

This resulted in port 18789 listening on `*`.

### Validation done
Confirmed that:
- `http://10.0.0.46:18789` responded with HTTP 200
- it returned Control UI HTML at `/`

This means **LAN reachability is working**.
If the app still cannot perform useful operations, the problem is now likely one of:
- wrong endpoint path
- auth/token mismatch
- app-side expectations vs gateway response shape
- STT endpoint mismatch

---

## 7. Jarvis Core / gateway integration details

### Chat endpoint used in app
The app was wired to:
- `POST /v1/chat/completions`

Gateway chat completions were explicitly enabled in config.

### Successful manual test pattern
A successful manual test used roughly:
- Authorization: Bearer `<gateway token>`
- model: `openclaw:main`
- messages array in OpenAI-compatible format

### STT path currently assumed by app
The app expects a backend endpoint at:
- `POST /v1/audio/transcriptions`

Request style:
- `multipart/form-data`
- fields:
  - `file`
  - `model=whisper-1`
  - `response_format=json`

Response shape expected by app:
- either `text`
- or `transcript`

This endpoint has **not been fully validated as working end-to-end** against the real backend.
That is one of the biggest open integration issues.

---

## 8. Security / dev shortcuts currently in play

### Host config
The host/base URL is now persisted and configurable. Good progress.

### Development auth/token
There is/was a local development token file used for gateway access:
- `lib/core/config/dev_gateway_local.dart`

It was added to `.gitignore` to avoid committing local secrets.

Important:
- host is no longer hardcoded as product UX
- but auth/token handling is still partially dev-oriented and not a finished product flow

### Auth hardening already done
A later pass hardened startup/auth so the app does not silently pretend to be authenticated.
Key behavior after hardening:
- no host → login/config
- host + valid real session → home
- host + no session → login
- host + no session + preview mode → home, explicitly marked as preview

This means “fake auth” has been reduced, but a real production login/link flow still is not complete.

---

## 9. Important app code areas

All paths below are under:
- `/Users/aneuyrs/.openclaw/workspace/Proyectos/JarvisApp/app/lib`

### Core config / network
- `core/config/app_env.dart`
- `core/config/app_config.dart`
- `core/config/app_config_controller.dart`
- `core/config/app_config_storage.dart`
- `core/config/dev_gateway_local.dart` (local dev secret file, intended to be ignored)
- `core/network/dio_provider.dart`

### App shell
- `main.dart`
- `app/app.dart`
- `app/bootstrap.dart`
- `app/router.dart`
- `app/theme/app_theme.dart`
- `shared/widgets/jarvis_shell.dart`

### Auth/session
- `features/auth/domain/models/session.dart`
- `features/auth/domain/models/auth_state.dart`
- `features/auth/domain/repositories/session_repository.dart`
- `features/auth/data/api/auth_api.dart`
- `features/auth/data/repositories/session_repository_impl.dart`
- `features/auth/presentation/controllers/auth_controller.dart`
- `features/auth/presentation/screens/splash_screen.dart`
- `features/auth/presentation/screens/login_screen.dart`

### Assistant / chat
- `features/assistant/domain/models/chat_message.dart`
- `features/assistant/domain/models/chat_state.dart`
- `features/assistant/data/api/chat_api.dart`
- `features/assistant/data/repositories/chat_repository.dart`
- `features/assistant/presentation/controllers/chat_controller.dart`
- `features/assistant/presentation/screens/assistant_home_screen.dart`
- `features/assistant/presentation/screens/conversation_screen.dart`
- `features/assistant/presentation/widgets/chat_input_bar.dart`
- `features/assistant/presentation/widgets/message_bubble.dart`
- `features/assistant/presentation/widgets/chat_status_banner.dart`

### Voice capture / STT transport
- `features/assistant/domain/models/voice_capture_state.dart`
- `features/assistant/application/voice_capture_service.dart`
- `features/assistant/data/api/voice_transcription_api.dart`
- `features/assistant/data/repositories/voice_transcription_repository.dart`
- `features/assistant/presentation/controllers/voice_capture_controller.dart`
- `features/assistant/presentation/widgets/voice_capture_panel.dart`

### Supporting screens
- `features/history/presentation/screens/history_screen.dart`
- `features/tools/presentation/screens/tools_screen.dart`
- `features/settings/presentation/screens/settings_screen.dart`
- `features/settings/presentation/widgets/host_config_card.dart`

---

## 10. What sub-agents already improved

### Chat hardening
A sub-agent improved:
- honest startup into conversation
- empty state
- loading/error messaging
- clearer connection banner
- direct entry to real conversation instead of a fake-feeling home-first flow

### Host config
A sub-agent implemented:
- first-run base URL configuration
- settings-based host editing
- local persistence with `shared_preferences`
- host test button/state

### Placeholder replacement
A sub-agent improved:
- History screen
- Tools screen
- Settings screen
so they are no longer simple placeholders

### Auth hardening
A sub-agent improved:
- fake auth removal
- explicit developer preview mode
- stricter session restore rules

### Voice/STT path
A sub-agent improved:
- file upload path for STT
- response parsing for transcription
- ability to push transcribed text into the chat flow

### QA reports
A sub-agent produced:
- functional gap report
- build readiness report
and highlighted realistic blockers rather than code-style noise

---

## 11. Biggest remaining blockers

### A. Android ↔ Core experience still feels partial
This is the most important unresolved problem.
Even after solving:
- APK builds
- LAN bind
- host config
there is still a gap between “app can reach host” and “app is cleanly usable from Android”.

### B. STT endpoint may not align with real backend
The app assumes:
- `POST /v1/audio/transcriptions`

That endpoint may or may not be fully supported in the actual running Jarvis Core/OpenClaw gateway.
This must be validated empirically.

### C. Dev-token assumptions still exist
The app has reduced fake auth, but a true production-safe auth flow is still not in place.

### D. TTS/playback not done
No full voice loop exists yet.
There is no finished response-audio playback experience.

### E. MVP honesty problem
The app has a lot more real substance than before, but still risks feeling like a “serious prototype” rather than a “usable MVP” if these integration issues are not closed.

---

## 12. Recommended next actions for the next AI

### Highest-priority path
1. **Validate Android-to-Core request paths in practice**
   - inspect actual requests sent by the app
   - confirm the host persisted on Android really is `http://10.0.0.46:18789`
   - confirm auth headers are present and correct
   - confirm whether `/v1/chat/completions` succeeds from the phone, not just desktop curl

2. **Validate or adapt STT endpoint**
   - confirm whether `POST /v1/audio/transcriptions` really exists and works in the live gateway
   - if not, either:
     - implement the backend route somewhere appropriate, or
     - change app transport to the correct existing route

3. **Produce a new Android APK only after a meaningful fix**
   - do not ship another APK that is functionally equivalent to prior builds
   - ship only after the mobile-side issue is clearly improved

4. **Close MVP 1.0 scope honestly**
   A realistic MVP 1.0 should probably be:
   - host configurable
   - app reaches core
   - text chat usable
   - voice capture present but possibly still partial
   - clear messaging where a feature is not yet closed

5. **Push TTS / playback to v1.5 if necessary**
   Unless the next AI can close it quickly without destabilizing the app, TTS should likely be treated as v1.5.

### Important strategic note
Do **not** keep opening new fronts.
The correct focus is:
- usable Android ↔ Core path
- STT validation/adaptation
- MVP closure

---

## 13. Commands that were useful

### Build / analyze
```bash
cd /Users/aneuyrs/.openclaw/workspace/Proyectos/JarvisApp/app
flutter analyze
flutter build macos
flutter build apk --debug
flutter build apk --release --split-per-abi
```

### Check LAN gateway bind
```bash
lsof -nP -iTCP:18789 -sTCP:LISTEN
curl -i http://10.0.0.46:18789/
```

### Gateway bind
The working setting was:
- `gateway.bind = lan`

### Chat completion test pattern
Manual tests against the gateway used OpenAI-compatible chat completions with bearer auth and model `openclaw:main`.

---

## 14. User preferences that matter here

The user is highly sensitive to:
- visible progress
- slow loops with too much theory
- repeated reports of the same blocker
- APKs that are not meaningfully improved

The user prefers:
- execution over explanation
- modern, fluid, intuitive UI
- dashboard-style status reporting
- initiative without waiting for constant permission, except when something incurs cost

Important rule from user:
- avoid steps that require physical approval on the Mac mini while the user lacks physical access
- approvals that can happen through this chat are fine

---

## 15. Recommended handoff summary in one paragraph

JarvisApp is a partially-realized Flutter mobile embodiment app for Jarvis. It compiles, has Android/macOS builds, configurable host onboarding, real chat wiring to Jarvis Core via the OpenAI-compatible gateway, a hardened startup/auth model, improved placeholder screens, and a real voice-capture foundation with an STT transport path. The main unresolved issue is turning this from a serious prototype into a genuinely usable Android MVP by closing the real mobile ↔ core integration loop and validating or adapting the STT backend path. The next AI should stop widening scope, validate the actual Android request/response behavior against the LAN-exposed gateway at `http://10.0.0.46:18789`, resolve the STT contract, and only then produce a new APK as the MVP 1.0 candidate.
