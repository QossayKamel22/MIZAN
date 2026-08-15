# MIZAN — Use Cases

Detailed use cases for the core flows. Format: Actor, Preconditions, Main Flow, Alternate/Exception Flows, Postconditions.

## UC-1: Register Account
- **Actor**: Unauthenticated user.
- **Preconditions**: App installed, network available.
- **Main Flow**: 1) User opens app → Register. 2) Enters name, email, password. 3) Client validates input format. 4) Backend/Firebase creates account. 5) User is redirected to onboarding (add first income/bill). 6) On completion, lands on Dashboard.
- **Alternate**: Email already in use → inline error, offer "Log in instead". Weak password → inline strength guidance.
- **Postconditions**: Account created; user authenticated; session token stored securely on-device.

## UC-2: Log In
- **Actor**: Registered user.
- **Main Flow**: 1) User enters credentials (or uses biometric if previously enabled). 2) Backend/Firebase authenticates. 3) User lands on Dashboard.
- **Exception**: Invalid credentials → inline error, no indication of which field is wrong (security best practice). Network failure → retry affordance.

## UC-3: Add Expense
- **Actor**: Authenticated user.
- **Main Flow**: 1) User taps Add (from any main tab). 2) Selects "Expense". 3) Enters amount (required), selects category, date defaults to today. 4) Optionally adds notes/account/recurrence. 5) Taps Save. 6) System persists transaction, updates relevant budget's spent total, updates dashboard.
- **Alternate**: Amount invalid (non-numeric, zero, negative) → inline validation blocks save. Offline → transaction queued locally (phase 2) or save blocked with clear message (v1 fallback).
- **Postconditions**: Transaction persisted; budget progress recalculated; dashboard reflects new state.

## UC-4: Create Budget
- **Actor**: Authenticated user.
- **Main Flow**: 1) User navigates to Budget tab → Create Budget. 2) Selects category or "Overall". 3) Sets limit amount and period (weekly/monthly/custom range). 4) Saves. 5) System begins tracking matching transactions against the budget.
- **Postconditions**: New budget active; historical transactions in the current period are included in spent-to-date if they match the budget's category/period.

## UC-5: Receive Budget Alert
- **Actor**: System (triggered), User (recipient).
- **Trigger**: A new/updated transaction causes a budget's spent percentage to cross a configured threshold (default 80%, 100%).
- **Main Flow**: 1) Backend recalculates budget status on transaction write. 2) If threshold crossed and not already notified this period, system creates a notification. 3) Push notification sent via FCM (if enabled) and appears in-app notification center.
- **Postconditions**: Notification recorded with read=false; user sees it in Notifications and optionally as a push.

## UC-6: Ask the AI Assistant a Question
- **Actor**: Authenticated user.
- **Main Flow**: 1) User opens AI Assistant. 2) Types a free-text financial question. 3) Request sent to backend, which invokes the LangGraph agent graph with the user's ID as context scope. 4) Agent selects appropriate tool(s) (e.g., `get_spending_by_category`, `get_upcoming_bills`) to retrieve real data. 5) Agent composes a grounded natural-language answer. 6) Response streamed back to client.
- **Exception**: Agent tool call fails (DB unavailable) → assistant responds with a graceful "I couldn't retrieve your data right now" rather than a fabricated answer.
- **Postconditions**: Conversation turn logged (for quality improvement) with data references, not raw PII beyond what's needed.

## UC-7: Add and Track a Bill
- **Actor**: Authenticated user.
- **Main Flow**: 1) User adds a Bill (payee, amount, due date, recurrence). 2) System schedules reminder notifications relative to due date. 3) On/near due date, user marks bill as paid (creates a linked Expense transaction) or it remains outstanding.
- **Postconditions**: Bill status tracked (upcoming/due/overdue/paid); dashboard "Upcoming Bills" reflects current state.

## UC-8: Switch Theme
- **Actor**: Authenticated or unauthenticated user (theme is device-local, not account-gated).
- **Main Flow**: 1) User opens Settings → Appearance. 2) Selects System Default / Light / Dark. 3) App re-themes immediately across all currently mounted screens. 4) Preference persisted to local storage.
- **Postconditions**: Preference survives app restart.

## UC-9: Switch Language
- **Actor**: Authenticated or unauthenticated user.
- **Main Flow**: 1) User opens Settings → Language. 2) Selects Arabic or English. 3) App reloads locale, layout direction flips to RTL/LTR accordingly. 4) Preference persisted.
- **Postconditions**: All screens, including previously cached AI conversation UI chrome (not historical message content), render in the new language on next load.
