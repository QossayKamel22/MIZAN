# MIZAN — Non-Functional Requirements

## 1. Performance
- **NFR-PERF-1**: Cold app start to interactive dashboard ≤ 2.5s on a mid-tier device under typical network conditions (target; validated post-implementation).
- **NFR-PERF-2**: API p95 response time ≤ 300ms for CRUD endpoints, excluding AI agent endpoints.
- **NFR-PERF-3**: AI assistant response streaming begins ≤ 2s after request (perceived latency via streaming, not blocking on full generation).
- **NFR-PERF-4**: Lists (transactions, notifications) use pagination/lazy loading beyond 50 items.

## 2. Security
See `SECURITY_REQUIREMENTS.md` for full detail. Summary: encrypted transport (TLS), no secrets in source, secure token storage on-device, backend input validation on every endpoint, least-privilege Firebase security rules.

## 3. Usability & Accessibility
- **NFR-UX-1**: Primary actions (Add Transaction) reachable within 1 tap from any main tab.
- **NFR-UX-2**: Minimum tappable target size 44x44dp.
- **NFR-UX-3**: Color contrast meets WCAG AA in both Light and Dark themes.
- **NFR-UX-4**: Critical flows (add transaction, view budget) usable without relying on color alone (icons/labels accompany status colors).

## 4. Localization Quality
- **NFR-L10N-1**: Arabic copy is written/reviewed as native Arabic, not machine-translated filler.
- **NFR-L10N-2**: All screens mirror correctly in RTL (layout direction, icons where directionally meaningful, text alignment).
- **NFR-L10N-3**: Numeric/date/currency formatting respects locale conventions.

## 5. Reliability & Availability
- **NFR-REL-1**: Backend targets 99.5% uptime once deployed to production infrastructure.
- **NFR-REL-2**: Client degrades gracefully offline: cached last-known dashboard data shown with an offline indicator; writes queue and sync on reconnect (documented as a phase-2 enhancement if not in v1 cut).

## 6. Maintainability
- **NFR-MAINT-1**: Clean Architecture layering enforced (presentation / domain / data) on both client and backend.
- **NFR-MAINT-2**: No file/widget/controller exceeds reasonable complexity thresholds; large components are decomposed (guideline: single responsibility per class/widget).
- **NFR-MAINT-3**: All public APIs (Dart classes, Python modules) documented with docstrings/comments explaining intent, not just mechanics.

## 7. Scalability
- **NFR-SCALE-1**: Database schema supports horizontal growth in transaction volume without redesign (indexed foreign keys, partitionable transaction table by date if needed later).
- **NFR-SCALE-2**: AI agent architecture supports adding new agents/tools without modifying existing agent graphs (see `AI_AGENT_ARCHITECTURE.md` §5).
- **NFR-SCALE-3**: Backend is stateless per-request (session state in DB/Firebase, not in-process) to allow horizontal scaling.

## 8. Compatibility
- **NFR-COMPAT-1**: Supports current and previous major iOS and Android OS versions at time of release.
- **NFR-COMPAT-2**: Responsive to common phone screen sizes (small phones through large phones); tablet support is a future enhancement.

## 9. Observability
- **NFR-OBS-1**: Backend structured logging with correlation IDs, excluding sensitive data (no PII/financial values in logs).
- **NFR-OBS-2**: Client crash/error reporting hook point defined (e.g., Firebase Crashlytics), even if not fully wired in v1.
