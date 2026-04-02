# Roadmap: Flo Finance

## Overview

The journey to launch involves establishing a robust Hive local data engine, building the foundational UI and routing structure, expanding it with visual charts for insights, seamlessly integrating a proactive Groq-powered AI coach, and finally rounding it out with gamified challenges for savings goals.

## Phases

- [ ] **Phase 1: Core Architecture & Data** - Hive database models, TypeAdapters and base repositories
- [ ] **Phase 2: Fundamental UI & Routing** - GoRouter config, Riverpod wiring, Home Dashboard and Transactions CRUD
- [ ] **Phase 3: Insights & Visualizations** - Analytical charts using `fl_chart` without UI lag
- [ ] **Phase 4: Proactive AI Coach** - Groq API integration and secure local data aggregation
- [ ] **Phase 5: Gamification & Goals** - Savings goals threshold and no-spend streak metrics

## Phase Details

### Phase 1: Core Architecture & Data
**Goal**: Establish the local-first unblockable Hive foundation.
**Depends on**: Nothing
**Requirements**: DATA-01, DATA-02, DATA-03
**Success Criteria** (what must be TRUE):
  1. App initializes Hive securely and quickly on startup.
  2. Transaction models are statically typed via built-in generators.
  3. Repositories can fetch and save records successfully off the UI layer.
**Plans**: 3 plans

Plans:
- [ ] 01-01: Set up project structure and implement Riverpod/Hive dependencies.
- [ ] 01-02: Define Hive TypeAdapters and Transaction Dart models.
- [ ] 01-03: Implement the base Transaction storage and repository abstractions.

### Phase 2: Fundamental UI & Routing
**Goal**: Build the primary screens for data entry and basic observation.
**Depends on**: Phase 1
**Requirements**: ARCH-01, ARCH-02, DASH-01, DASH-03, TXN-01, TXN-02, TXN-03, TXN-04
**Success Criteria** (what must be TRUE):
  1. User can navigate smoothly between Home and Transactions views natively.
  2. User can Add, Edit, or Delete transactions natively via UI forms.
  3. Total Gross Balance updates reactively without visual stutters.
**Plans**: 4 plans

Plans:
- [ ] 02-01: Configure GoRouter implementation and basic theme scaffolding.
- [ ] 02-02: Implement Riverpod AsyncNotifiers bridging the Repository up to the UI.
- [ ] 02-03: Build Transactions list screen and functional CRUD modal/pages.
- [ ] 02-04: Build Dashboard scaffolding, gross balance card, and FAB shortcut.

### Phase 3: Insights & Visualizations
**Goal**: Display interactive spending charts using `fl_chart`.
**Depends on**: Phase 2
**Requirements**: DASH-02, INSI-01, INSI-02
**Success Criteria** (what must be TRUE):
  1. Home screen dynamically visualizes a bar chart of the past 7 days spending.
  2. The Insights screen clearly highlights the month's categorized spending fractions.
**Plans**: 3 plans

Plans:
- [ ] 03-01: Create asynchronous aggregate data isolation (for lag-free computations).
- [ ] 03-02: Implement the miniature weekly spending bar chart upon the Dashboard.
- [ ] 03-03: Build the full standalone Insights screen displaying pie charts.

### Phase 4: Proactive AI Coach
**Goal**: Integrate Groq Llama 3/Mixtral to generate actionable intelligence.
**Depends on**: Phase 3
**Requirements**: COAC-01, COAC-02, COAC-03, COAC-04
**Success Criteria** (what must be TRUE):
  1. Data is anonymized or aggregated safely before transiting externally.
  2. The AI identifies explicit financial trends locally over ~0.5 second network intervals.
  3. Gracefully hides errors if the user goes purely offline.
**Plans**: 3 plans

Plans:
- [ ] 04-01: Create a secure 30-day aggregate compression pipeline bridging Hive.
- [ ] 04-02: Connect the Groq REST API layer and prompt engineering infrastructure.
- [ ] 04-03: Build the dynamic AI Insight UI card embedded cleanly onto the Dashboard.

### Phase 5: Gamification & Goals
**Goal**: Hook the user with retention algorithms (Streaks + Goals).
**Depends on**: Phase 2
**Requirements**: GOAL-01, GOAL-02
**Success Criteria** (what must be TRUE):
  1. User can define a total ceiling savings goal.
  2. A counter tracks progressive zero-spend days iteratively in real-time.
**Plans**: 2 plans

Plans:
- [ ] 05-01: Implement goal preferences and iterative streak tracking logic.
- [ ] 05-02: Build the standalone Goal UI, streak animations, and Dashboard integration points.

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Core Architecture & Data | 0/3 | Not started | - |
| 2. Fundamental UI & Routing | 0/4 | Not started | - |
| 3. Insights & Visualizations | 0/3 | Not started | - |
| 4. Proactive AI Coach | 0/3 | Not started | - |
| 5. Gamification & Goals | 0/2 | Not started | - |
