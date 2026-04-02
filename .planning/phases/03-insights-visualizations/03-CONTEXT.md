# Phase 3: Insights & Visualizations - Context

**Gathered:** 2026-04-02
**Status:** Ready for planning

<domain>
## Phase Boundary

Compute dynamic financial analytics safely decoupled from the UI thread, rendering high-fidelity animations referencing the Financial Sanctuary design rules mapping the Dashboard and Insights modules via `fl_chart`.
</domain>

<decisions>
## Implementation Decisions

### Charting Architecture
- **D-01:** Strictly utilize `fl_chart` mapping abstract native painters.
- **Styling constraints:** Remove all grid lines and borders completely. Animate interpolations softly on load.
- **Axes formats:** Explicitly attach the INR (₹) parameter.
- **Palette Mapping:** Categories distribute recursively among [`#1E1B4B`, `#006C4B`, `#64F9BC`, `#F8F9FA`].

### Data Computation Constraints
- **D-02:** Time horizon aggregates strictly enforce "Current Calendar Month" limits natively.
- **Performance Execution:** Analytics models aggregating Hive repository structures **must** execute asynchronously inside `compute()` isolated boundaries preventing dropped UI frames.

### View Compositions
- **Home Dashboard Update:** Replace placeholder with a miniature weekly spending bar chart (past 7 days, grouped by day) colored strictly in `#006C4B`.
- **Insights Tab Setup:** Complete categorical Pie/Donut breakdown chart alongside a robust comparative Monthly Spending Bar Chart.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Dynamic Stitch Assets
- **CRITICAL IMPERATIVE:** Investigate and derive the exact layout padding rules referencing the Insights Screen via Stitch MCP before executing chart scaffolding constraints.
</canonical_refs>

---

*Phase: 03-insights-visualizations*
*Context gathered: 2026-04-02*
