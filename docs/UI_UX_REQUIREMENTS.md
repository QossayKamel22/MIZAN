# MIZAN — UI/UX Requirements

## 1. Design Direction
**Minimal + Premium + Financial + Modern.** Palette: white, black, green (primary financial accent), neutral grays. Green is used intentionally (positive balance, progress, confirmation, primary CTAs) rather than saturating the whole UI. Avoid generic template aesthetics, excessive gradients, excessive shadows, or unnecessary animation.

## 2. Design System (see `TECHNICAL_ARCHITECTURE.md` §1 for file layout: `core/theme/`)

### 2.1 Color Tokens (semantic, not literal, so screens never hardcode hex values)
| Token | Purpose |
|---|---|
| `colorBackground` | Screen background |
| `colorSurface` | Card/elevated surface |
| `colorSurfaceAlt` | Secondary surface (e.g., input fields) |
| `colorPrimary` | Brand green — primary actions, positive emphasis |
| `colorPrimaryMuted` | Subtle green tint (progress track backgrounds, chips) |
| `colorTextPrimary` / `colorTextSecondary` / `colorTextTertiary` | Text hierarchy |
| `colorBorder` | Hairline borders |
| `colorSuccess` / `colorWarning` / `colorDanger` | Status semantics (distinct from brand green where status ≠ "positive brand action") |
| `colorOverlay` | Scrims/dialogs |

### 2.2 Typography Scale
`displayLarge, headlineLarge, headlineMedium, titleLarge, titleMedium, bodyLarge, bodyMedium, bodySmall, labelLarge, labelSmall` — mapped to a single typeface family with Arabic-optimized fallback (a typeface with full, well-shaped Arabic glyph support, not a Latin font force-rendering Arabic).

### 2.3 Spacing & Radius
4px base spacing unit (4/8/12/16/24/32/48). Corner radius tokens: `radiusSmall (8)`, `radiusMedium (12)`, `radiusLarge (20)`, `radiusPill (999)`.

### 2.4 Elevation
Light mode: subtle shadows (low blur, low opacity). Dark mode: elevation communicated primarily via surface color steps (lighter dark-gray surfaces), shadows minimized (per master prompt §12/§14 — dark mode is not just inverted light mode).

## 3. Theming Requirements
- Full Light and Dark themes, both intentionally designed (not a naive color inversion).
- Theme options: System Default, Light, Dark — persisted locally, applied instantly.
- Every screen category must be verified in both themes (dashboard, budget, transfers, add transaction, notifications, settings, forms, bottom nav, cards, charts, dialogs, bottom sheets, buttons, text fields, AI assistant, empty/loading/error states) — tracked in `TESTING_STRATEGY.md`.
- Charts/financial indicators must remain readable and meaningful (sufficient contrast, not relying on hue alone) in both themes.

## 4. Localization & RTL/LTR Requirements
- Arabic and English are both first-class; Arabic UI must read as natively designed, not mechanically mirrored/translated.
- Full RTL mirroring: layout direction, text alignment, icon direction where directionally meaningful (e.g., back/forward chevrons, progress direction), navigation gesture areas.
- Numbers, dates, and currency formatted per locale conventions (Arabic-Indic vs. Western digits handled per `core/utils` formatters — default to Western digits with AED currency formatting unless a future preference is added, documented explicitly rather than assumed).

## 5. Information Hierarchy Principles
- Dashboard prioritizes hierarchy over density: balance and top alert first, secondary summaries below, detail on drill-in — not all data at equal visual weight.
- Add Transaction flow minimizes required fields (per FR-TXN-7) to keep entry friction low.

## 6. Component States (mandatory across the app)
Every data-bearing screen/component must define: **loading**, **empty**, **error**, and **populated** states — no screen ships with only the happy path.

## 7. Accessibility
See `NON_FUNCTIONAL_REQUIREMENTS.md` §3. Minimum tap target 44x44dp, WCAG AA contrast in both themes, status never conveyed by color alone.

## 8. Motion
Purposeful, minimal motion only: state-change transitions (theme switch, screen transitions, budget progress fill) — no decorative animation that adds latency to core financial tasks.
