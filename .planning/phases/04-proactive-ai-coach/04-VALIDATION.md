---
phase: 4
slug: proactive-ai-coach
status: draft
nyquist_compliant: true
wave_0_complete: false
created: 2026-04-02
---

# Phase 4 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Flutter Test |
| **Config file** | pubspec.yaml |
| **Quick run command** | `flutter analyze` |
| **Full suite command** | `flutter test` |

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 4-01-01 | 01 | 1 | CRUD_FIX | command | `flutter analyze lib/` | ✅ | ⬜ pending |
| 4-02-01 | 02 | 2 | AI_SDK | widget | `flutter test test/api/` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Wave 0 covers all MISSING references
- [x] `nyquist_compliant: true` set in frontmatter
