---
phase: 1
slug: core-architecture-data
status: draft
nyquist_compliant: true
wave_0_complete: false
created: 2026-04-02
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Flutter Test |
| **Config file** | pubspec.yaml |
| **Quick run command** | `dart analyze` |
| **Full suite command** | `flutter test` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `dart analyze`
- **After every plan wave:** Run `flutter test`
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 1-01-01 | 01 | 1 | DATA-01 | command | `flutter pub get` | ✅ | ⬜ pending |
| 1-01-02 | 02 | 1 | DATA-02 | command | `dart run build_runner build -d` | ✅ | ⬜ pending |
| 1-01-03 | 03 | 2 | DATA-03 | unit | `flutter test test/infrastructure/transaction_repository_test.dart` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `test/infrastructure/transaction_repository_test.dart` — stubs for testing transaction repository
- [ ] Add `mockito` or `mocktail` dependencies to `pubspec.yaml` (if not present)

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| App boots via `main()` | DATA-02 | OS cold-boot test | Run app on emulator natively and observe instant boot to a blank scaffold. |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 15s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** 2026-04-02
