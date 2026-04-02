---
phase: 2
slug: fundamental-ui-routing
status: draft
nyquist_compliant: true
wave_0_complete: false
created: 2026-04-02
---

# Phase 2 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Flutter Test |
| **Config file** | pubspec.yaml |
| **Quick run command** | `flutter analyze` |
| **Full suite command** | `flutter test` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter analyze`
- **After every plan wave:** Run `flutter test`
---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 2-01-01 | 01 | 1 | ARCH-01 | command | `flutter analyze lib/core/theme` | ✅ | ⬜ pending |
| 2-01-02 | 02 | 1 | ARCH-02 | unit | `flutter test test/routing_test.dart` | ❌ W0 | ⬜ pending |
| 2-01-03 | 03 | 2 | DASH-01 | widget | `flutter test test/ui/home_test.dart` | ❌ W0 | ⬜ pending |
| 2-01-04 | 04 | 3 | TXN-01 | widget | `flutter test test/ui/transactions_test.dart` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `test/routing_test.dart` — stubs for testing GoRouter mapping
- [ ] `test/ui/home_test.dart` — stubs for testing screen
- [ ] `test/ui/transactions_test.dart` — stubs for testing screen
- [ ] ensure dependencies `go_router` exists in `pubspec.yaml`

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Bottom Sheet Rendering | TXN-03 | Visual interaction | Launch app, tap FAB or 'Add', confirm bottom sheet mounts correctly with Glassmorphism overlay. |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] Feedback latency < 15s
- [x] `nyquist_compliant: true` set in frontmatter
