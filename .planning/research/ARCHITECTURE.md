# Architecture Research

**Domain:** Personal Finance App
**Researched:** 2026-04-02
**Confidence:** HIGH

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                            UI Layer                          │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │ Dashboard│  │ Transac.│  │ Goals   │  │ Insights│        │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘        │
│       │            │            │            │              │
├───────┴────────────┴────────────┴────────────┴──────────────┤
│                   State / Application Layer                  │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐    │
│  │           Riverpod Notifiers & Usecases              │    │
│  └─────────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────┤
│                     Data / Repository Layer                  │
│  ┌──────────┐  ┌──────────┐  ┌────────────┐                 │
│  │ Hive DB  │  │ HTTP/Groq│  │ Local Prefs│                 │
│  └──────────┘  └──────────┘  └────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| UI | Rendering pixels, user input, GoRouter routing | Flutter Widgets (StatelessWidget/ConsumerWidget) |
| AsyncNotifiers | Managing asynchronous states (Loading, Error, Data), business logic | Riverpod `@riverpod` classes |
| Repositories | Abstracting data access (Hive, Groq) | Plain Dart classes injected via Provider |

## Recommended Project Structure

```
lib/
├── core/               # Shared constants, theme, routing
├── data/               # Models, Hive TypeAdapters
├── features/           # Feature-first architecture
│   ├── dashboard/
│   ├── transactions/
│   ├── insights/
│   ├── goals/
│   └── ai_coach/
└── main.dart           # App entrypoint and ProviderScope
```

### Structure Rationale

- **features/:** Grouping files by feature (Screens + State + Local widgets) scales much better than grouping by type (all screens together, all controllers together).
- **data/:** Keeping models centralized helps since Hive models generate adapters and are referenced by multiple features.

## Data Flow

### Request Flow

```
[User Action]
    ↓
[ConsumerWidget] → [Riverpod Notifier] → [Repository] → [Hive DB / Groq]
    ↓                 ↓                     ↓               ↓
[UI rebuild] ← [State Emitted] ←     [Data Returns] ←   [Response]
```

## Scaling Considerations

| Scale | Architecture Adjustments |
|-------|--------------------------|
| 0-1,000 txs | Hive list load is instantaneous. |
| 10,000+ txs | Need to paginate Hive queries or use Isar instead for indexed reads if charts begin lagging. |

## Anti-Patterns

### Anti-Pattern 1: Bloated Main

**What people do:** Initialize every service, Hive box, and Router inside `main()`.
**Why it's wrong:** Delays the first frame render (splash screen hang).
**Do this instead:** Use FutureBuilders, AsyncNotifiers, or splash screen implementations to initialize Hive asynchronously.

### Anti-Pattern 2: Tightly Coupled UI and Groq

**What people do:** Call the HTTP POST to Groq directly inside `onPressed` of a button.
**Why it's wrong:** UI handles HTTP exceptions, JSON parsing, and loading state manually. Un-testable.
**Do this instead:** Create a dedicated `AiCoachRepository` called by a `AiCoachController` Riverpod state class.

---
*Architecture research for: Personal Finance App*
*Researched: 2026-04-02*
