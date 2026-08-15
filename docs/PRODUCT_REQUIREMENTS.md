# MIZAN (ميزان) — Product Requirements Document (PRD)

## 1. Product Summary

MIZAN is a smart personal financial management mobile application built primarily for the UAE, GCC, and wider Arab market. It centralizes income, expenses, budgets, transfers, bills, savings, financial goals, and AI-powered financial insight into a single, trustworthy, premium experience.

**Product philosophy:** Make personal finance simple, intelligent, organized, and actionable.

**Brand feel:** Simple + Premium + Modern + Trustworthy + Intelligent.

## 2. Problem Statement

Arab-market consumers currently manage personal finances across a fragmented set of tools: bank apps (transactional, not analytical), spreadsheets (manual, error-prone), and generic international budgeting apps (poor Arabic/RTL support, not localized to GCC financial habits — e.g., salary-cycle budgeting, remittances, Islamic finance sensitivities). There is no single trustworthy, Arabic-first, AI-assisted personal finance app for this market.

## 3. Target Users

- **Primary:** UAE residents (expat and national) aged 22–45, salaried professionals, mobile-first, bilingual (Arabic/English).
- **Secondary:** Broader GCC and Arab-market users with similar salary-cycle financial patterns.
- **User financial sophistication:** Ranges from financially novice to intermediate. The product must not assume expert financial literacy.

## 4. Goals

### Business Goals
- Establish MIZAN as the trusted personal-finance app of choice in the UAE/GCC market.
- Build a defensible data + AI moat via financial insight quality.
- Create a scalable architecture that supports rapid iteration toward monetizable features (premium tiers, partnerships with banks/fintechs) in later phases.

### User Goals
- Understand where money goes without manual bookkeeping effort.
- Stay within budget and avoid missed bills.
- Build savings and progress toward financial goals.
- Get plain-language, actionable financial guidance (not raw data dumps).

### Non-Goals (v1)
- MIZAN v1 is not a bank, does not hold funds, and does not move real money on the user's behalf. Transfers/bills features in v1 are tracking and organization tools, not payment rails.
- MIZAN v1 does not provide licensed financial/investment advice. AI recommendations are informational, not regulated advisory output.
- MIZAN v1 does not implement full investment portfolio management (documented as a future phase, see `DEVELOPMENT_ROADMAP.md`).

## 5. Success Metrics

- Activation: % of new users who add at least one income + one expense within first session.
- Engagement: weekly active users / monthly active users (WAU/MAU) ratio.
- Retention: Day-7 and Day-30 retention.
- Financial value delivered: % of users with an active budget who stay within budget month-over-month after 3 months of use.
- AI engagement: % of active users interacting with the AI assistant at least weekly.

## 6. Scope of v1 (Initial Release)

In scope:
- Authentication (email/password + Firebase-backed, biometric unlock on-device)
- Dashboard (financial overview)
- Add Transaction (income, expense, transfer, bill, savings, goal)
- Budget & Transfers management
- Notifications center
- Settings (theme, language, profile, security)
- AI Financial Assistant (analysis, recommendations, bill awareness, Q&A) — scoped to the capabilities documented in `AI_AGENT_ARCHITECTURE.md`, with clearly marked future capabilities
- Full Arabic (RTL) and English (LTR) localization
- Light Mode and Dark Mode

Out of scope for v1 (documented in roadmap as future phases):
- Real payment execution / bank account linking (Open Banking)
- Investment trading
- Multi-currency conversion automation beyond basic display
- Family/shared accounts
- Web application

## 7. Assumptions & Constraints

- Firebase is used for authentication, real-time data, and push notifications.
- Backend business logic and AI orchestration run in Python (FastAPI for the API layer, LangGraph for agents).
- No real financial institution integrations exist yet in v1; all financial data is user-entered or manually imported. This is documented, not hidden, per the project's "no fake completion" rule.
- The mobile client is Flutter, using GetX for state management, DI, and navigation.

## 8. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| No live bank data source in v1 lowers automatic-tracking value | Medium | Position v1 as manual-entry-first with strong UX for fast entry; plan Open Banking integration in a later phase |
| AI recommendations perceived as financial advice | High (regulatory/trust) | Clear in-product disclaimers; AI positioned as "insights", not advice; documented in `SECURITY_REQUIREMENTS.md` and `AI_AGENT_ARCHITECTURE.md` |
| RTL/LTR and Arabic/English quality gap | High (core market) | Arabic treated as first-class throughout design system, not a translation pass; explicit QA pass per `TESTING_STRATEGY.md` |
| Scope creep beyond v1 | Medium | Roadmap phased explicitly; PRD non-goals enforced |

## 9. Stakeholders

- Product/Engineering: single technical owner (this repository's maintainer).
- End users: UAE/GCC individual consumers.
