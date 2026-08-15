# MIZAN — Release Plan

## 1. Release Philosophy
Ship a narrow, high-quality v1 rather than a broad, shallow one. Every feature in v1 scope (`PRODUCT_REQUIREMENTS.md` §6) must meet the Final Quality Gate (master prompt §26) before public release — partial/fake functionality is never shipped as if complete.

## 2. Release Milestones

### Milestone A — Internal Alpha
- Backend + AI scaffold functional against a real dev Firebase project and dev Postgres.
- Flutter app running on simulator/device, all core screens navigable, Light/Dark + Arabic/English verified.
- AI assistant answering grounded questions against seeded test data.
- Audience: internal only.

### Milestone B — Closed Beta
- Full state matrix (`TESTING_STRATEGY.md` §3) passing.
- Crash reporting live; no P0/P1 bugs open.
- Small group of real UAE-based users, feedback loop established.

### Milestone C — Public v1 Launch
- Security review complete (`SECURITY_REQUIREMENTS.md` §11 pending items closed).
- App Store / Play Store listings localized (Arabic + English screenshots/copy).
- Support channel established for user issues.

## 3. Versioning
Semantic versioning for the backend API (`/api/v1`, breaking changes bump to `/api/v2` with a deprecation window). Mobile app uses standard store versioning (`major.minor.patch` + build number).

## 4. Release Notes Discipline
Every release ships with a changelog entry categorized as Added/Changed/Fixed/Security, so users and the team can track what actually shipped versus what's still pending — consistent with the project's "no fake completion" principle.

## 5. Current Status
This repository build corresponds to pre-Milestone-A engineering work: documentation, architecture, and scaffolded implementation. See `FINAL_TECHNICAL_REPORT.md` for the precise, honest status of each component.
