# Flo Finance

## What This Is

A personal finance companion mobile app that helps users track, understand, and improve their spending habits. It combines manual transaction tracking with proactive AI-driven insights from local data to serve as an intelligent financial coach.

## Core Value

Empowering users to effortlessly track their finances and adopt better habits through proactive, AI-driven spending insights based on their own secure local data.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

<!-- Current scope. Building toward these. -->

- [ ] Home dashboard with balance card and spending chart
- [ ] Transaction tracking with full CRUD
- [ ] Goals screen with no-spend challenge streak and savings progress bar
- [ ] Insights screen with category charts and week comparison
- [ ] Proactive AI Spending Coach using Groq API (analyzes Hive data and bubbles up suggestions automatically)

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- Cloud syncing / remote databases — User specifically requested local storage with Hive, keeping user financial data strictly local.
- Unprompted conversational Chatbot AI — User explicitly opted for proactive insights generated from local data over an on-demand conversation flow.

## Context

- Designed as a local-first application prioritizing privacy and speed, applying rapid AI inference over the user's local financial graph.
- The project has some existing code but the codebase mapping was deliberately skipped to focus squarely on the desired architecture and new goals.

## Constraints

- **Tech Stack Core**: Flutter SDK
- **State Management**: Riverpod — Specified by user for structured dependency injection and reactive state.
- **Local Database**: Hive — Selected for rapid local NoSQL read/writes.
- **Navigation**: GoRouter — Required for declarative routing setup.
- **Charts**: fl_chart — Required for visualizing spending and insights.
- **AI Integration**: Groq API — Chosen for blazingly fast inference to generate proactive insights without perceived latency.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Local-first with Hive | Ensures user financial data privacy while allowing AI to analyze localized patterns | — Pending |
| Proactive AI Insights | Provides higher value by automatically bubbling up suggestions instead of expecting the user to construct queries | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-02 after initialization*
