# MIZAN — Deployment Plan

## 1. Environments
| Environment | Purpose |
|---|---|
| `development` | Local development, local/dev Firebase project, local Postgres (Docker) |
| `staging` | Pre-production validation, staging Firebase project, managed Postgres |
| `production` | Live app, production Firebase project, managed Postgres with backups |

## 2. Backend Deployment
- **Containerization**: `backend/Dockerfile` (multi-stage build: dependency install → slim runtime image).
- **Target infra**: any container-hosting platform supporting a standard Docker image + managed Postgres (e.g., a managed container service + managed Postgres instance). Kept infra-agnostic in v1 rather than locking to one vendor prematurely.
- **Config**: all environment-specific values via environment variables (see `.env.example`), injected by the hosting platform's secret manager — never baked into the image.
- **Migrations**: `alembic upgrade head` run as a release-time step before the new backend version receives traffic.
- **Health check**: `GET /health` endpoint (no auth) for load-balancer/orchestrator liveness checks.

## 3. Firebase Setup (Pending — external step)
1. Create Firebase project per environment (dev/staging/prod).
2. Enable Email/Password auth provider (and any additional providers decided later).
3. Provision Firestore in the region closest to the primary user base (UAE-proximate region).
4. Configure Firestore security rules restricting `notifications/*` per-user (see `SECURITY_REQUIREMENTS.md` §3).
5. Enable Cloud Messaging, register platform credentials (APNs key for iOS, FCM for Android).
6. Generate a service account key for backend-side Admin SDK use; store as a secret, never in source (see `.gitignore`).

This step requires real Firebase console access/credentials and is documented as **pending** rather than performed in this repository build — see `FINAL_TECHNICAL_REPORT.md`.

## 4. Mobile App Deployment
- **iOS**: Xcode Cloud or Fastlane-driven build → TestFlight (internal testing) → App Store review → release.
- **Android**: Gradle build → Play Console Internal Testing track → staged rollout → production.
- **Signing**: release keystores/certificates managed outside source control (per `.gitignore`: `android/key.properties`, iOS provisioning profiles excluded).

## 5. CI/CD (Target)
- On PR: lint + unit/widget tests (backend `pytest`, mobile `flutter test`/`flutter analyze`).
- On merge to `main`: build backend Docker image, push to registry, deploy to `staging` automatically; `production` deploy is a manual promotion step.
- Mobile builds triggered on release-tag creation, uploaded to TestFlight/Play internal track.

## 6. Rollback Strategy
- Backend: previous container image redeployed via the hosting platform's rollback mechanism; DB migrations written to be backward-compatible for one version where feasible (additive changes preferred over destructive ones within a release cycle).
- Mobile: staged rollout percentage halted/reverted via store console if a release-blocking issue surfaces.

## 7. Monitoring (Target)
- Backend structured logs shipped to a log aggregator.
- Uptime/health-check monitoring on `/health`.
- Mobile crash reporting via Firebase Crashlytics once provisioned.
