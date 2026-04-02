---
phase: 3
slug: insights-visualizations
status: draft
nyquist_compliant: true
wave_0_complete: false
created: 2026-04-02
---

# Phase 3 — Validation Strategy

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

## Sampling Rate

- **After every task commit:** Run `flutter analyze`
- **After every plan wave:** Run `flutter test`

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 3-01-01 | 01 | 1 | DASH-02 | command | `flutter analyze lib/application/` | ✅ | ⬜ pending |
| 3-01-02 | 02 | 2 | DASH-04 | widget | `flutter test test/ui/home_chart_test.dart` | ❌ W0 | ⬜ pending |
| 3-01-03 | 03 | 2 | IN-01, IN-02 | widget | `flutter test test/ui/insights_test.dart` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `test/ui/home_chart_test.dart` — stubs for testing chart injection
- [ ] `test/ui/insights_test.dart` — stubs for testing Insights grid

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Chart Animation | DASH-02 | Visual animation | Route to Insights Tab, observe initial `PieChart` spin rendering smoothly without drop frames. |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Wave 0 covers all MISSING references
- [x] `nyquist_compliant: true` set in frontmatter
