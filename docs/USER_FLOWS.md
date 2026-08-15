# MIZAN — User Flows

Text-based flow diagrams (rendered as step sequences; convertible to visual diagrams later).

## Flow 1 — Onboarding → First Value
```
Splash
  → Auth Choice (Login / Register)
  → Register (email, password)
  → Onboarding Step 1: Add primary income
  → Onboarding Step 2: Add 1-3 recurring bills (optional, skippable)
  → Onboarding Step 3: Set first budget (optional, skippable)
  → Dashboard (populated, not empty)
```

## Flow 2 — Add Transaction (Global Entry Point)
```
Any main tab
  → Tap central "Add" action
  → Type selector: Income | Expense | Transfer | Bill | Savings | Goal
  → Type-specific form (amount required; smart defaults for date/account)
  → Save
  → Confirmation (subtle, non-blocking) + return to prior screen
  → Dashboard/Budget totals update reactively
```

## Flow 3 — Budget Creation & Monitoring
```
Budget tab
  → Create Budget
  → Choose scope (category | overall)
  → Set limit + period
  → Save → Budget card appears with 0% progress
  ...over time, as transactions are added...
  → Progress updates automatically
  → Threshold crossed → Notification generated → shown in Notification Center + push
```

## Flow 4 — AI Assistant Conversation
```
Dashboard (AI insight teaser) OR bottom nav / dedicated entry
  → AI Assistant screen
  → User types question OR taps a suggested prompt chip
  → Loading/streaming indicator
  → Agent graph executes (intent routing → tool calls → synthesis)
  → Grounded response rendered, with reference to source data where relevant
  → User can ask follow-up (context retained within session)
```

## Flow 5 — Notification → Action
```
Push notification received (bill due / budget alert / AI insight)
  → Tap notification
  → Deep-link into relevant screen (Bill detail / Budget detail / AI Assistant)
  → Notification marked as read
```
(If app not opened via push: Notification Center tab shows unread badge until viewed.)

## Flow 6 — Theme & Language Switch
```
Settings
  → Appearance → System Default / Light / Dark → instant re-theme, persisted
  → Language → English / Arabic → locale + direction reload, persisted
```

## Flow 7 — Account Deletion (Security-Sensitive)
```
Settings → Account → Delete Account
  → Confirmation dialog (explicit, re-authentication required)
  → Backend triggers full data deletion (see SECURITY_REQUIREMENTS.md)
  → Session cleared → returned to Auth Choice screen
```
