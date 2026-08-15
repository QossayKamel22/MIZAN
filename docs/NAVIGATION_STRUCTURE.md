# MIZAN — Navigation Structure

## 1. Top-Level Navigation
Bottom navigation bar with 5 destinations (GetX named routes, see `mobile/lib/app/routes/`):

```
[ Dashboard ]  [ Budget ]  [  (+) Add  ]  [ Notifications ]  [ Settings ]
```

- **Dashboard** (`/dashboard`) — home/overview.
- **Budget** (`/budget`) — Budget & Transfers hub.
- **Add** (center, elevated action, `/add`) — opens the transaction-type selector as a modal bottom sheet, not a full tab with its own persistent content (it's an action, not a browsable section).
- **Notifications** (`/notifications`) — notification center.
- **Settings** (`/settings`) — profile, theme, language, security, preferences.

The AI Assistant is reachable from a persistent entry point on the Dashboard (insight card → "Ask MIZAN") and optionally a floating/quick-access affordance — not a 6th bottom-nav tab, to keep the primary nav uncluttered, per minimal design direction.

## 2. Route Table (`AppRoutes` / `AppPages`)

| Route | Screen | Auth Required |
|---|---|---|
| `/splash` | Splash / bootstrap | No |
| `/auth` | Auth choice (login/register) | No |
| `/auth/login` | Login | No |
| `/auth/register` | Register | No |
| `/auth/forgot-password` | Password reset | No |
| `/onboarding` | First-run onboarding (add income/bills/budget) | Yes |
| `/dashboard` | Dashboard | Yes |
| `/budget` | Budget & Transfers list | Yes |
| `/budget/create` | Create/edit budget | Yes |
| `/budget/:id` | Budget detail | Yes |
| `/transfers` | Transfer history | Yes |
| `/add` | Add-transaction type selector (modal) | Yes |
| `/add/income` | Add income form | Yes |
| `/add/expense` | Add expense form | Yes |
| `/add/transfer` | Add transfer form | Yes |
| `/add/bill` | Add bill form | Yes |
| `/add/savings` | Add savings contribution form | Yes |
| `/add/goal` | Create goal form | Yes |
| `/notifications` | Notification center | Yes |
| `/ai-assistant` | AI Assistant conversation | Yes |
| `/settings` | Settings home | Yes |
| `/settings/profile` | Profile edit | Yes |
| `/settings/appearance` | Theme selection | Yes |
| `/settings/language` | Language selection | Yes |
| `/settings/security` | Biometric lock, password | Yes |
| `/settings/notifications` | Notification preferences | Yes |

## 3. Navigation Rules
- Auth-required routes are guarded by a GetX `middleware` (`AuthMiddleware`) checking session state, redirecting to `/auth` if absent.
- Deep links from push notifications resolve to the specific route (e.g., `budget/:id`) via the `deep_link` field on the notification record.
- Back navigation always available except on `/splash` and immediately post-login redirect.
- The Add flow, once a type is selected, replaces the modal content rather than stacking new modals.

## 4. RTL Navigation Considerations
- Bottom nav item order visually mirrors under RTL (handled by Flutter's `Directionality` + GetX localization controller) — Dashboard/Settings positions swap sides consistently with reading direction, Add stays center.
- Swipe-back gestures respect RTL direction (right-edge swipe in LTR, left-edge in RTL) via platform defaults.
