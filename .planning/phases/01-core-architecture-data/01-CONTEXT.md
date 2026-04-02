# Phase 1: Core Architecture & Data - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning

<domain>
## Phase Boundary

Establish the local-first unblockable Hive foundation including distinct database boxes, typed models, and abstract data repositories. This unlocks data handling completely offline without any UI lag.
</domain>

<decisions>
## Implementation Decisions

### Data Security
- **D-01:** Hive boxes will be kept plaintext to favor maximum performance and avoid asynchronous decryption overhead.

### Initialization Flow
- **D-02:** Hive boxes will boot synchronously in `main()` so the app operates instantly once Flutter mounts relative to the native splash screen.

### Box Structure
- **D-03:** Use distinct strongly-typed boxes (`transactionsBox`, etc) to separate domains instead of a monolithic key-value store.

### Repository Abstraction
- **D-04:** Implement strict abstract interfaces (e.g., `abstract interface class TransactionRepository`) injected via Riverpod to guarantee perfect mockability for Unit tests.

### Global Tech Context / Discretion
- **Stitch MCP Design Constraints (Downstream):** This project operates under the "Financial Sanctuary" design system in Stitch. Read `DESIGN.md` via Stitch MCP before generating UI code downstream. Screen assets are actively available in Stitch.
- **Dart MCP Tooling:** Use Dart MCP to run Flutter commands efficiently contextually.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### General Architecture
- `.planning/research/ARCHITECTURE.md` - High-level structural requirements and definitions
- `.planning/research/PITFALLS.md` - Known bad implementation approaches to avoid

</canonical_refs>

---

*Phase: 01-core-architecture-data*
*Context gathered: 2026-04-02*
