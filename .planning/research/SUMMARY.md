# Project Research Summary

**Project:** Flo Finance
**Domain:** Personal Finance App
**Researched:** 2026-04-02
**Confidence:** HIGH

## Executive Summary

Flo Finance is a local-first personal finance app powered by native Flutter and Hive, designed for privacy-conscious users who want rapid insights without giving their transaction data to cloud aggregators. The core innovation relies on applying the Groq API's blazing inference speed locally to synthesize patterns based on strict, typed user financial data.

The recommended approach enforces Riverpod for robust AsyncState handling and GoRouter for structural clarity.

Key risks include accidentally leaking massive transaction lists to Groq and causing frame stutters when aggregating chart data. Both can be mitigated through asynchronous background computations and careful prompt design that only relies on pre-aggregated local data.

## Key Findings

### Recommended Stack

**Core technologies:**
- Flutter 3.29+: Mobile framework — Fast execution, native performance.
- Riverpod 2.6+: State Management — Compile safe DI.
- Hive 2.2+: Local Database — Speed and local privacy.
- GoRouter 14.0+: Navigation — Standard routing.
- fl_chart: Visuals — Drawing insights and trends.
- groq: AI SDK — Near instant text synthesis for proactive insights.

### Expected Features

**Must have (table stakes):**
- Transaction CRUD — users expect this
- Home Dashboard — users expect this

**Should have (competitive):**
- Proactive AI Coach — differentiator
- Goals/No-spend streaks — gamified differentiator

**Defer (v2+):**
- Cloud Syncing / Bank Account links

### Architecture Approach

**Major components:**
1. UI Layer (Widgets & GoRouter)
2. State/App Layer (Riverpod `AsyncNotifier` classes)
3. Data Layer (Hive TypeAdapters & HTTP API clients)

### Critical Pitfalls

1. **Leaking Sensitive Data to LLMs** — avoid by pre-aggregating metrics locally before sending to Groq.
2. **App Lag During Chart Renders** — avoid by off-boarding aggregate `.fold` calculations into isolate/Async processes instead of the UI thread.
3. **Skipping TypeAdapters in Hive** — avoid by writing proper schema upfront for speed.

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 1: Core Architecture & Data Engine
**Rationale:** Database structure blocks any UI or AI development.
**Delivers:** Hive models, TypeAdapters, initialization routine, basic transaction CRUD logic (no polished UI).
**Addresses:** Transaction CRUD

### Phase 2: Fundamental UI & Routing
**Rationale:** Need screens to insert the data and view it.
**Delivers:** GoRouter setup, Theme scaffolding, Dashboard structure, Transaction input screens.
**Addresses:** Home dashboard, Transaction entry UI.

### Phase 3: Insights & Visualizations (fl_chart)
**Rationale:** Data must exist to visualize it. Focus on lag-free calculations.
**Delivers:** fl_chart implementations on Dashboard and Insights screens.
**Avoids:** App Lag chart renders pitfall.

### Phase 4: Proactive AI Coach
**Rationale:** AI Coach requires a populated database and UI to display effectively.
**Delivers:** Groq API Integration, prompt aggregation logic, UI surfacing for suggestion prompts.
**Avoids:** Leaking sensitive data pitfall.

### Phase 5: Gamification & Goals
**Rationale:** Enhances the app once core flow is proven.
**Delivers:** Savings goals, streak trackers.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Flutter standards are well established. |
| Features | HIGH | Financial app structures are deeply understood. |
| Architecture | HIGH | Riverpod/Hive pattern is highly standard. |
| Pitfalls | HIGH | Common mistakes mapped correctly. |

**Overall confidence:** HIGH

---
*Research completed: 2026-04-02*
*Ready for roadmap: yes*
