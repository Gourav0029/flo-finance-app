# Phase 2: Fundamental UI & Routing - Research

**Objective:** Define architectural configurations unifying Flutter's `go_router`, pure Riverpod Form Notifiers, and the foundational pixels required for the "Financial Sanctuary" standard.

## Navigation Architecture: GoRouter ShellRoute
- A `StatefulShellRoute.indexedStack` resolves persistent bottom navigation retention. This ensures state continuity (scrolling metrics, transaction tab filters) doesn't wipe randomly when switching tabs.
- Four main branches: `Home`, `Transactions`, `Goals`, `Insights`.

## Design System Atoms
Based strictly on Stitch MCP `DESIGN.md` extractions:
- `AppTheme` implements `ThemeExtension<AppTheme>` guaranteeing strict boundaries instead of polluting built-in `ThemeData`.
- Colors: `primary` (#1E1B4B), `secondary` (#006C4B), `secondary_container` (#64F9BC). No true black (#000000) allowed.
- Depth & Borders: Corner rounded edges explicitly at `24px` (`BorderRadius.circular(24)`). Absolute zero native 1px borders—separation achieved through background elevation variants over a ghost backdrop.
- Glassmorphism: Persistent bottom nav requires an opacity constraint on an `#FFFFFF` backing, blurred extensively via a local `BackdropFilter` filter metric of `20px`.

## Screen Bootstrapping Architecture
- `HomeDashboardScreen`: Metric scaffolding with embedded chart abstractions rendering over standard Flutter grids.
- `TransactionsListScreen`: Real-time listeners watching the `TransactionRepository` via Riverpod AsyncValues natively injected.
- `AddTransactionModal`: Abstracted completely as a reactive Bottom Sheet rendering input fields over a separate route.

## Form Abstraction: Riverpod
- A `TransactionFormNotifier` avoids `StatefulWidget` clutter. Validation bindings push reactive flags down over inputs synchronously.
