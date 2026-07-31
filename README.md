# GoFit

A modern fitness tracker built with Flutter — onboarding, auth, and a full
6‑tab dashboard with charts, all in a lime / black / lavender design system
that supports light and dark themes.

> UI‑focused project: no Firebase, authentication, API, or storage. Screens
> run on placeholder data so the whole experience is navigable end‑to‑end.

## Features

- **Onboarding** — 3 animated intro screens with a glassmorphism style
- **Auth flow** — login, sign‑up, "enter your details" ruler pickers, and
  forgot‑password (UI only; buttons navigate into the app)
- **Dashboard** (6 tabs behind a floating pill bottom nav):
  - **Home** — daily summary rings, weekly bar chart, heart‑rate line,
    sleep timeline, and achievement badges
  - **Calories** — daily goal, meals list, macro donut, weekly overview
  - **Stats** — monthly trend, key metrics, activity heatmap
  - **My Feed** — activity posts with GPS route previews, likes and sharing
  - **Profile** — goals, and links to sub‑pages
  - **Settings** — dark‑mode toggle, units, about
- **Sub‑pages** — Food Details, Start Activity, Personal Details,
  Personal Goals, Privacy, Connect Watch, and About Me
- **Theming** — one‑tap light/dark switch driven by theme‑aware color tokens
- **Charts without dependencies** — ring gauges, donut, line, bar, sleep
  segmented bar, activity heatmap, and GPS route preview are all drawn with
  `CustomPainter` (only external package is `google_fonts`)

## Architecture

Feature‑first layout:

```
lib/
├── core/            # theme, colors, sizes, routing
├── shared/          # reusable widgets + CustomPainter charts
└── features/        # onboarding, auth, home, nutrition, stats,
                     # activity, profile, settings, main (shell)
```

State is handled with built‑in `setState` and lightweight `ValueNotifier`
controllers (theme + shell tab) — no state‑management package.

## Getting started

```bash
flutter pub get
flutter run            # pick a device, or:
flutter run -d chrome  # run in the browser
```

Requires Flutter 3.41+ (Dart 3.11+).

## Tech

Flutter · Dart · google_fonts · Material 3
