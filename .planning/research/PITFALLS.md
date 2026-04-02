# Pitfalls Research

**Domain:** Personal Finance App
**Researched:** 2026-04-02
**Confidence:** HIGH

## Critical Pitfalls

### Pitfall 1: Leaking Sensitive Data to LLMs

**What goes wrong:**
Sending raw user transaction data (with specific names, places, precise amounts over time) to the Groq API for insights, inadvertently leaking personal financial patterns to a third party.

**Why it happens:**
It's easiest to just serialize the Hive database and dump it into an LLM prompt.

**How to avoid:**
Sanitize and aggregate data locally before sending. Send "Monthly category totals" or "Anonymized generic prompt data" instead of raw individual entries.

**Warning signs:**
You see individual transaction IDs or precise locations in the prompt logs.

**Phase to address:**
AI Coach Implementation Phase.

---

### Pitfall 2: App Lag During Chart Renders

**What goes wrong:**
The home page stutters when scrolling into the `fl_chart` view.

**Why it happens:**
Querying the entire transaction database to aggregate the chart data down on the main UI thread during `build`.

**How to avoid:**
Calculate aggregated data (monthly totals, weekly curves) inside Riverpod as an asynchronous state calculation (in a background isolate if necessary, though plain computation is usually fine if pre-calculated). The UI simply consumes compiled `List<FlSpot>`.

**Warning signs:**
Dev tools show missed frames (jank) over 16ms when initializing the Insights or Dashboard screen.

**Phase to address:**
Insights/Dashboard Phase.

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Not using Hive TypeAdapters manually | Faster boilerplate (just use JSON maps) | Unsafe types and slow parsing | MVP only |
| Skipping Riverpod Code Gen | Avoid running build_runner | Passing complex `ref` dependencies becomes messy | Never |

## "Looks Done But Isn't" Checklist

- [ ] **Data Entry:** Often missing proper numeric keyboard types — verify `keyboardType: TextInputType.numberWithOptions(decimal: true)` is set on amount fields.
- [ ] **AI Prompts:** Often missing failure fallbacks — verify the UI handles "Groq API rate limit" gracefully.

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Bad Hive Schema | HIGH | Write a local migration script to map old un-typed data into new TypeAdapters at app launch. |

---
*Pitfalls research for: Personal Finance App*
*Researched: 2026-04-02*
