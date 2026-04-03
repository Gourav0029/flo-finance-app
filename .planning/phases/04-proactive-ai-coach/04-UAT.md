---
status: testing
phase: 04-proactive-ai-coach
source: 04-01-PLAN.md, 04-02-PLAN.md
started: 2026-04-02T18:43:00Z
updated: 2026-04-02T18:43:00Z
---

## Current Test
<!-- OVERWRITE each test - shows where we are -->

number: 1
name: Cold-Start Smoke Test
expected: |
  Start the application. App boots completely with no crashes, local Hive initializations load without error, and default Home Screen shows 0 balance or previously added dummy transactions natively.
awaiting: user response

## Tests

### 1. Cold-Start Smoke Test
expected: Start the application. App boots completely with no crashes, local Hive initializations load without error, and default Home Screen shows 0 balance or previously added dummy transactions natively.
result: [pending]

### 2. Category Dynamic Filter Checks
expected: On the Transactions tab, tap 'Food'. Only transactions categorized as Food appear natively in the list.
result: [pending]

### 3. Add Transaction and View Refresh
expected: Click Add Transaction FAB/Menu, put 'Income' and amount. On Save, the main Dashboard instantly reflects the new totals natively seamlessly.
result: [pending]

### 4. Delete Transaction via Long Press
expected: Long press a transaction on the Transactions Screen. A confirmation dialog appears natively.
result: [pending]

### 5. Open AI Coach FAB
expected: Tap the global floating Action Button. An AI Coach bottom sheet opens clearly tracking context natively.
result: [pending]

### 6. Dynamic Context GenAI Chat
expected: In the AI Coach sheet, ask "How is my spending?". The Assistant replies mentioning specific category amounts matching your transactions natively!
result: [pending]

## Summary

total: 6
passed: 0
issues: 0
pending: 6
skipped: 0

## Gaps

