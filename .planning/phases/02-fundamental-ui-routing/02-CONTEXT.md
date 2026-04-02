# Phase 2: Fundamental UI & Routing - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning

<domain>
## Phase Boundary

Build the primary screens for data entry and observation (Home Dashboard, Transactions List, Add Transaction form) and integrate them securely into a GoRouter ShellRoute navigation framework utilizing the Financial Sanctuary design system fetched via Stitch MCP.
</domain>

<decisions>
## Implementation Decisions

### Navigation Architecture
- **D-01:** Implement a GoRouter `ShellRoute` managing a 4-tab persistent Glassmorphism bottom navigation bar (Home, Transactions, Goals, Insights). Default routing points to the Home Dashboard.

### Form State Management
- **D-02:** Utilize pure Riverpod (`AutoDisposeNotifier`) to cleanly separate input state, validation, and domain mapping before saving entities onto the Hive repositories.

### Design System Extraction
- **D-03:** Formally structure the "Financial Sanctuary" atoms (Colors: #1E1B4B, #006C4B, #64F9BC | Fonts: Manrope/Inter | Borders: 24px) utilizing Flutter's `ThemeExtension` bounded within a core `lib/core/theme/` directory.

### Screen Compositions
- **Home Dashboard:** Must include a balance card, income/expense summary, recent transactions list slice, and a spending donut chart.
- **Transactions List:** Provide search capability, filtering chips, and CRUD operations interface.
- **Add Transaction:** Rendered natively as a strictly controlled Bottom Sheet encompassing category picker, amount, and date picker.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Dynamic Stitch Assets
- **CRITICAL IMPERATIVE:** Fetch the project "Flo Finance" securely using the Stitch MCP server, and map the explicit dimensions utilizing `DESIGN.md` immediately before generating the UI layout syntax.
</canonical_refs>

---

*Phase: 02-fundamental-ui-routing*
*Context gathered: 2026-04-02*
