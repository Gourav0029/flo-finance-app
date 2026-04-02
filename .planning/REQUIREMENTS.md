# Requirements: Flo Finance

**Defined:** 2026-04-02
**Core Value:** Empowering users to effortlessly track their finances and adopt better habits through proactive, AI-driven spending insights based on their own secure local data.

## v1 Requirements

### Core Database (Hive)

- [ ] **DATA-01**: Define transaction data model with Hive TypeAdapters
- [ ] **DATA-02**: Initialize Hive boxes securely on app launch
- [ ] **DATA-03**: Create base repository for fetching, adding, updating, expanding transaction data

### Dashboard

- [ ] **DASH-01**: Display gross total balance at top
- [ ] **DASH-02**: Display miniature weekly spending bar chart
- [ ] **DASH-03**: Quick-add transaction FAB

### Transactions

- [ ] **TXN-01**: Screen to view full scrollable list of transactions
- [ ] **TXN-02**: User can add new transaction (amount, category, date, notes)
- [ ] **TXN-03**: User can edit existing transaction
- [ ] **TXN-04**: User can delete transaction with confirmation

### Insights (fl_chart)

- [ ] **INSI-01**: Screen displaying visual category breakdown pie chart
- [ ] **INSI-02**: Screen displaying monthly spend bar chart comparison

### AI Coach

- [ ] **COAC-01**: Background pipeline to aggregate last 30 days data safely
- [ ] **COAC-02**: Groq API integration (Llama 3/Mixtral) with local aggregated data
- [ ] **COAC-03**: Surface AI insight card gracefully on the dashboard
- [ ] **COAC-04**: Graceful handling of rate limits and missing network

### Architecture

- [ ] **ARCH-01**: Configure GoRouter navigation layer
- [ ] **ARCH-02**: Implement Riverpod state management and Dependency Injection

### Gamification & Goals

- [ ] **GOAL-01**: Establish savings goal threshold
- [ ] **GOAL-02**: No-spend streak day counter

## v2 Requirements

(None yet)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Cloud Syncing / Firebase | Breaks explicit local-first privacy commitment. |
| Bank Account / Plaid Sync | High overhead, breaks manual control and local-first architecture. |
| Conversational Chatbot | User explicitly opted for proactive insights instead of prompted chat inputs. |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| DATA-01 | Phase 1 | Pending |
| DATA-02 | Phase 1 | Pending |
| DATA-03 | Phase 1 | Pending |
| ARCH-01 | Phase 2 | Pending |
| ARCH-02 | Phase 2 | Pending |
| DASH-01 | Phase 2 | Pending |
| DASH-02 | Phase 3 | Pending |
| DASH-03 | Phase 2 | Pending |
| TXN-01 | Phase 2 | Pending |
| TXN-02 | Phase 2 | Pending |
| TXN-03 | Phase 2 | Pending |
| TXN-04 | Phase 2 | Pending |
| INSI-01 | Phase 3 | Pending |
| INSI-02 | Phase 3 | Pending |
| COAC-01 | Phase 4 | Pending |
| COAC-02 | Phase 4 | Pending |
| COAC-03 | Phase 4 | Pending |
| COAC-04 | Phase 4 | Pending |
| GOAL-01 | Phase 5 | Pending |
| GOAL-02 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 20 total
- Mapped to phases: 20
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-02*
*Last updated: 2026-04-02 after initial definition*
