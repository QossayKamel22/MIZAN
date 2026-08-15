# MIZAN — Functional Requirements

Each requirement uses ID format `FR-<AREA>-<NUM>` for traceability into `USE_CASES.md` and test plans.

## FR-AUTH — Authentication & Account

- **FR-AUTH-1**: Users can register with email + password.
- **FR-AUTH-2**: Users can log in with email + password.
- **FR-AUTH-3**: Users can reset a forgotten password via email link (Firebase Auth).
- **FR-AUTH-4**: Users can enable biometric/PIN app-lock for local session re-entry.
- **FR-AUTH-5**: Users can log out, which clears local session state.
- **FR-AUTH-6**: Users can delete their account, which triggers full data deletion per `SECURITY_REQUIREMENTS.md`.

## FR-DASH — Dashboard

- **FR-DASH-1**: Dashboard displays current total balance across tracked accounts.
- **FR-DASH-2**: Dashboard displays current-period income vs. expense summary.
- **FR-DASH-3**: Dashboard displays active budget(s) status (spent/remaining, progress indicator).
- **FR-DASH-4**: Dashboard displays upcoming bills within a configurable horizon (default 7 days).
- **FR-DASH-5**: Dashboard displays savings/goal progress summary.
- **FR-DASH-6**: Dashboard surfaces top AI insight(s) or alert(s), prioritized by relevance/urgency, not shown as an unranked list.
- **FR-DASH-7**: Dashboard supports pull-to-refresh and shows loading/empty/error states.

## FR-TXN — Add Transaction

- **FR-TXN-1**: Users can add an Income record (amount, source, date, account, notes, recurrence optional).
- **FR-TXN-2**: Users can add an Expense record (amount, category, date, account, notes, recurrence optional).
- **FR-TXN-3**: Users can add a Transfer record between two tracked accounts/goals.
- **FR-TXN-4**: Users can add a Bill record (payee, amount, due date, recurrence, reminder preference).
- **FR-TXN-5**: Users can add a Savings contribution toward a savings goal.
- **FR-TXN-6**: Users can create a Financial Goal (target amount, target date, category).
- **FR-TXN-7**: The Add flow is a single entry point with type selection, minimizing required fields (amount + type + date are the only hard requirements; everything else is optional or has sensible defaults).
- **FR-TXN-8**: Users can edit or delete any transaction they created.

## FR-BUDGET — Budget & Transfers

- **FR-BUDGET-1**: Users can create a budget scoped to a category or overall spending, with a limit and a period (weekly/monthly/custom).
- **FR-BUDGET-2**: The system computes and displays spend-to-date vs. limit and remaining amount in real time as transactions are added.
- **FR-BUDGET-3**: Users receive a notification when a budget crosses configurable thresholds (e.g., 80%, 100%).
- **FR-BUDGET-4**: Users can view a list/history of transfers with filters (date range, account).
- **FR-BUDGET-5**: Users can view budget progress visually (progress bar/ring + numeric).
- **FR-BUDGET-6**: Users can edit or archive a budget.

## FR-NOTIF — Notifications

- **FR-NOTIF-1**: The system generates notifications for: bill due reminders, budget threshold alerts, unusual spending, AI insights/recommendations, goal milestones.
- **FR-NOTIF-2**: Users can view a chronological notification list with read/unread state.
- **FR-NOTIF-3**: Users can mark all as read, or mark individual notifications as read by opening them.
- **FR-NOTIF-4**: Notifications list has explicit empty, loading, and error states.
- **FR-NOTIF-5**: Users can configure notification categories they want to receive (Settings).

## FR-AI — AI Financial Assistant

- **FR-AI-1**: Users can ask free-text financial questions about their own data (e.g., "Where did I spend the most this month?").
- **FR-AI-2**: The system provides spending-pattern analysis on demand and proactively (surfaced via Dashboard/Notifications).
- **FR-AI-3**: The system provides budget and savings recommendations grounded in the user's actual transaction data (no fabricated figures).
- **FR-AI-4**: The system provides bill awareness support (upcoming bill summaries, due-date reminders framed conversationally).
- **FR-AI-5**: Every AI response referencing financial figures must be traceable to underlying transaction/budget data retrieved via agent tools, not hallucinated.
- **FR-AI-6**: AI features not yet implemented (see `AI_AGENT_ARCHITECTURE.md` §6 "Future Capabilities") must not be exposed as working in the UI.

## FR-SET — Settings

- **FR-SET-1**: Users can switch theme: System Default / Light / Dark; preference persists across restarts.
- **FR-SET-2**: Users can switch language: Arabic / English; preference persists and triggers full RTL/LTR relayout.
- **FR-SET-3**: Users can manage profile info (name, email, avatar).
- **FR-SET-4**: Users can manage security settings (biometric lock, password change).
- **FR-SET-5**: Users can manage notification preferences.
- **FR-SET-6**: Users can view app info (version, legal/privacy links).

## Cross-Cutting Functional Requirements

- **FR-X-1**: All list/data screens implement loading, empty, and error states (no blank screens).
- **FR-X-2**: All monetary values are formatted per the user's selected locale and a configurable base currency (default AED).
- **FR-X-3**: All user-facing strings are sourced from localization resources, not hardcoded.
