# Feature Research

**Domain:** Personal Finance App
**Researched:** 2026-04-02
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Dashboard | Need an at-a-glance view of current financial health | MEDIUM | Quick summary cards for balance, spending chart over the last week/month. |
| Transaction CRUD | Without inputs, a manual finance app is fundamentally broken | MEDIUM | Must be frictionless. Category, amount, date, notes. |

### Differentiators (Competitive Advantage)

Features that set the product apart. Not required, but valuable.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Proactive AI Coach | Turns raw data into actionable insights instantly | HIGH | Uses Groq API over local Hive data to synthesize "You are spending 10% more on Coffee this week". |
| No-spend streaks | Gamifies positive financial behavior | LOW/MEDIUM | Encourages daily app usage to maintain savings streaks. |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Bank Plaid Integration | Automates tracking entirely | High ongoing API costs, frequent auth breakages, and ruins the explicit "local-first" privacy model. | Frictionless manual entry with AI assistance. |

## Feature Dependencies

```
[Transaction CRUD]
    └──requires──> [Local Database (Hive)]
                       └──requires──> [Data Models]

[Proactive AI Coach] ──requires──> [Transaction CRUD] (To have data to analyze)
[Home Dashboard] ──requires──> [Transaction CRUD] (To feed charts)
[Goals Screen] ──enhances──> [Transaction CRUD]
```

## MVP Definition

### Launch With (v1)

Minimum viable product — what's needed to validate the concept.

- [ ] Home Dashboard — Quick health check
- [ ] Transaction Tracking CRUD — Essential data entry
- [ ] Insights Screen — Basic visual categorization

### Add After Validation (v1.x)

Features to add once core is working.

- [ ] Proactive AI Spending Coach — Refine prompts based on actual user data structure
- [ ] Goals/No-spend streaks — Gamification hook

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Transaction System | HIGH | MEDIUM | P1 |
| Dashboard & Charts | HIGH | MEDIUM | P1 |
| Proactive AI Coach | HIGH | HIGH | P2 |
| Goals & Streaks | MEDIUM | LOW | P2 |

---
*Feature research for: Personal Finance App*
*Researched: 2026-04-02*
