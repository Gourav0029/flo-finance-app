# Stack Research

**Domain:** Personal Finance App
**Researched:** 2026-04-02
**Confidence:** HIGH

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Flutter | 3.29+ | Cross-platform framework | Provides 60/120fps UI, native compilation, and seamless cross-platform delivery from a single codebase. |
| Riverpod | 2.6+ | State Management | Safest, compile-time safe dependency injection and reactive state handling in Flutter. |
| Hive | 2.2+ | Local Database | Fast, lightweight NoSQL key-value database perfect for offline-first, local data privacy. |
| GoRouter | 14.0+ | Navigation | Declarative routing officially endorsed by the Flutter team. Perfect for handling deep linking later. |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| fl_chart | 0.69+ | Charting Visualization | For drawing the spending charts and insight metric visuals on the Home and Insights screens. |
| groq | 0.0.1+ (or HTTP) | AI Inference API | To interact with Groq's APIs (Llama 3, Mixtral) with near-zero latency for the AI Spending Coach. |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| riverpod_generator | Code Generation | Reduces Riverpod boilerplate by generating providers. |
| build_runner | Code Generation runner | Required to run code generation for Hive type adapters and Riverpod. |

## Installation

```bash
flutter pub add flutter_riverpod riverpod_annotation hive fl_chart go_router http
flutter pub add -d build_runner riverpod_generator hive_generator
```

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Hive | Isar / SQflite | If complex relational querying across massive datastores becomes required. Hive is faster but pure key-value. |
| Riverpod | Bloc | If building within an enterprise team that strictly adheres to the BLoC pattern. Riverpod is less boilerplate for smaller/agile teams. |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| GetX | Bloated, tightly couples routing/state/DI, and frequently breaks with new Flutter engine updates. | Riverpod for state, GoRouter for routing |
| Shared Preferences for Analytics | Extremely slow and unsafe for storing thousands of unstructured transactions. | Hive / Isar |

## Version Compatibility

| Package A | Compatible With | Notes |
|-----------|-----------------|-------|
| riverpod_generator | build_runner | Ensure you use compatible modern versions to avoid pub resolution errors. |

---
*Stack research for: Personal Finance App*
*Researched: 2026-04-02*
