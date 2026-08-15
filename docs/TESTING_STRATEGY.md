# MIZAN — Testing Strategy

## 1. Test Layers

### 1.1 Backend (Python)
- **Unit tests** (`backend/tests/unit/`): service-layer business logic (budget calculation, notification-trigger logic) tested with mocked repositories — no DB required.
- **Repository/integration tests** (`backend/tests/integration/`): against a test PostgreSQL instance (or SQLite in-memory for fast CI runs where dialect-compatible), verifying actual queries.
- **API tests** (`backend/tests/api/`): FastAPI `TestClient`-based, exercising endpoints end-to-end with a test DB and a mocked Firebase token verifier.
- **AI workflow tests** (`ai/tests/`): graph routing tests with mocked LLM responses (deterministic), verifying the router selects the correct node for representative questions, and tools return correctly shaped data against fixture data.

### 1.2 Mobile (Flutter)
- **Unit tests** (`mobile/test/unit/`): domain use cases, formatters, validators.
- **Widget tests** (`mobile/test/widget/`): individual screens/components in isolation, including explicit assertions for loading/empty/error states.
- **Golden/theme tests** (`mobile/test/golden/`): key screens rendered under both Light and Dark themes, and under Arabic (RTL) and English (LTR) locales, to catch regressions.
- **Integration tests** (`mobile/integration_test/`): critical flows end-to-end (register → onboarding → add transaction → dashboard reflects it) against a mocked backend.

## 2. Coverage Priorities (in order)
1. Budget calculation correctness (money math bugs are the highest-cost bugs in this product).
2. Auth flows and route guarding.
3. Add Transaction flow (all 6 sub-types).
4. AI tool groundedness (tool outputs match fixture data exactly; no hallucination path exists because tools are the only data source).
5. Theming and localization regressions (per master prompt §14 requirement — every screen in both themes and both languages).

## 3. Explicit State Matrix (per master prompt §21 quality gate)
Every applicable screen is tested against: Light Mode, Dark Mode, Arabic/RTL, English/LTR, loading state, empty state, error state, and at least two representative screen sizes (small phone, large phone).

## 4. CI (Target, see `DEPLOYMENT_PLAN.md`)
- Backend: `pytest` + coverage report on every PR.
- Mobile: `flutter test` + `flutter analyze` on every PR.
- Both gated before merge to `main`.

## 5. AI Evaluation Set
A fixture-based question set (`ai/tests/eval_questions.json`, representative of `USER_SCENARIOS.md`) with expected intent classification and expected tool calls, run against the router to catch prompt-change regressions without needing a live LLM for every CI run (a smaller live-LLM smoke set runs less frequently, gated by API key availability).

## 6. Manual QA Checklist (pre-release)
- Full state matrix (§3) walked manually on at least one physical iOS and one physical Android device.
- Accessibility pass: screen reader labels present on primary actions, contrast spot-checked in both themes.
- Localization review: Arabic copy reviewed by a native speaker for naturalness, not just correctness.

## 7. Current Status
Test scaffolding (directory structure, example tests demonstrating the pattern) is included in this build. Full suite execution requires a live Flutter SDK and Python virtualenv with installed dependencies — not available in the authoring sandbox; see `FINAL_TECHNICAL_REPORT.md` for exact pending items.
