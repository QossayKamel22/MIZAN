# MIZAN — Security Requirements

MIZAN handles sensitive personal financial data. Security is a core, non-negotiable requirement, not an add-on.

## 1. Authentication & Session
- Authentication delegated to Firebase Authentication (industry-vetted identity provider) rather than a custom-built auth system.
- Backend verifies Firebase ID tokens on every request via the Firebase Admin SDK; never trusts a client-supplied `user_id`.
- Tokens stored on-device using platform secure storage (Keychain on iOS, Keystore-backed encrypted storage on Android) — never in plain SharedPreferences/UserDefaults.
- Optional biometric/PIN app-lock gates app foreground access without requiring re-login (local-only gate, layered on top of the persisted auth session).

## 2. Authorization
- Every data-access query is scoped by the authenticated user's internal `user_id` at the repository layer — not just at the API boundary — so a bug in one endpoint cannot leak cross-user data via a shared repository method.
- No admin/staff backdoor endpoints in v1.

## 3. Transport & Storage Security
- All client-backend and client-Firebase traffic over TLS.
- Database credentials, LLM API keys, Firebase service account credentials: environment variables only, injected at deploy time, never committed (see `.env.example`, `.gitignore`).
- Firebase security rules (Firestore) restrict the `notifications` collection so a user can only read `users/{their_uid}/notifications/*`.

## 4. Input Validation
- All backend endpoints validate request bodies via Pydantic schemas (type, range, required fields) before any business logic runs.
- Client-side validation is a UX convenience only — never the security boundary; the backend re-validates independently.
- SQL access exclusively via the ORM (SQLAlchemy) with parameterized queries — no raw string-interpolated SQL.

## 5. Secrets Management
- `.env.example` documents required variables with placeholder values; real `.env` is gitignored.
- No API keys, Firebase service account JSON, or credentials are ever committed. `.gitignore` explicitly excludes `*firebase-adminsdk*.json`, `serviceAccountKey.json`, `*.pem`, `*.key`, `.env`.
- Secret rotation: documented as an operational runbook item in `DEPLOYMENT_PLAN.md`.

## 6. Financial/Regulatory Considerations
- MIZAN v1 does not hold funds, execute payments, or provide licensed financial advisory services. UI copy and AI assistant responses must not imply otherwise.
- AI responses containing recommendations (not pure factual lookups) carry a disclaimer: informational only, not professional financial advice.
- This is a product-scope decision that also reduces regulatory exposure in v1; full compliance review is required before any future phase that adds real money movement or licensed advisory features.

## 7. AI-Specific Risks
- **Prompt injection**: user free-text input to the AI assistant is never used to construct raw tool arguments (e.g., SQL fragments) — arguments are validated/typed server-side regardless of what the LLM proposes.
- **Data leakage via LLM**: tool outputs passed to the LLM are scoped strictly to the requesting user's own data; the agent has no tool capable of cross-user queries.
- **Hallucination as a trust risk**: mitigated via grounded-answer system prompts and by keeping all v1 agent tools read-only (see `AI_AGENT_ARCHITECTURE.md` §7).

## 8. Data Retention & Deletion
- Account deletion (`DELETE /users/me`) soft-deletes the user row and associated data immediately (excluded from all reads), with a hard-purge job removing rows after a defined retention window (e.g., 30 days) to allow for accidental-deletion recovery within that window.
- `ai_interactions` logs are retained for quality review with a defined retention policy, purged on the same schedule as account deletion when tied to a deleted account.

## 9. Logging
- Structured logs exclude PII and financial values (e.g., log "transaction created" with transaction ID, not amount/category in plaintext logs).
- Error logs never include tokens, passwords, or full request bodies containing sensitive fields.

## 10. Dependency & Supply Chain
- Backend dependencies pinned in `requirements.txt`; mobile dependencies pinned in `pubspec.yaml`/`pubspec.lock`.
- Dependency vulnerability scanning is a recommended CI step (see `DEPLOYMENT_PLAN.md`).

## 11. Pending Security Work (documented, not hidden)
- Firebase project provisioning and actual security-rules deployment (requires a live Firebase project — external credential, currently pending, see `FINAL_TECHNICAL_REPORT.md`).
- Penetration testing / third-party security review before public production launch.
- Formal rate-limiting infrastructure (e.g., Redis-backed) beyond the basic in-process limiter scaffolded in v1.
