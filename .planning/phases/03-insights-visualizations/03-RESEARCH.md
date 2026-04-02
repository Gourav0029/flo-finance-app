# Phase 3: Insights & Visualizations - Research

**Objective:** Map out `fl_chart` configurations alongside Isolate-computation logic bridging synchronous Riverpod views cleanly.

## Charting Bounds: `fl_chart`
- **Miniature Weekly Bar Chart (Home Dashboard):** Implemented using `BarChart`. Ensure `BarChartData(borderData: FlBorderData(show: false), gridData: FlGridData(show: false))` to comply with Financial Sanctuary visual rules natively utilizing strict `#006C4B`. 
- **Category Donut Chart (Insights):** Utilize `PieChart` structured with `PieChartData`. Mapped against specific categorical constraints utilizing the core colors securely without grids:
  - Transport: `secondary` (#006C4B)
  - Food: `primary` (#1E1B4B)
  - Shopping: `accent` (#64F9BC)
  - Other: `background`
- All titles utilize the INR configuration natively explicitly checking boundaries.

## Computation Abstractions: The `compute()` Boundary
- The `transactionRepositoryProvider` surfaces natively serialized streams. We will utilize `flutter_riverpod` mapped to `FutureProvider` wrapping `compute(aggregateTransactions, list_of_txns)` returning categorical HashMaps like `{'Food': 1200}` avoiding UI latency entirely.

## Architecture & Integration
- Components must rely solely on native padding matrices rendering simple standard alignments mirroring the 24px configurations encoded securely down.
