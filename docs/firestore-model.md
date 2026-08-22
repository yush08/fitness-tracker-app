# Firestore data model

Everything the app stores lives under a single per-user tree, so Firestore
security rules only ever have to check "is this the owner?" (see
`firestore.rules`). No data is shared between users.

```
users/{uid}                       ← one document per account
  displayName   : string
  email         : string
  photoUrl      : string | null
  age           : number | absent
  heightCm      : number | absent
  weightKg      : number | absent
  targetWeightKg: number | absent
  goals         : map
      dailySteps    : number   (default 10000)
      dailyCalories : number   (default 2000)
      sleepHours    : number   (default 8)
      waterGlasses  : number   (default 8)
  createdAt     : timestamp (serverTimestamp)

users/{uid}/meals/{mealId}
  subtitle : string            e.g. "Oatmeal with fruits"
  calories : number
  type     : string            one of breakfast | lunch | dinner | snack
  loggedAt : timestamp         used to filter "today" (local midnight range)

users/{uid}/activities/{activityId}
  user       : string          display name (denormalised for the feed card)
  title      : string
  type       : string          Walking | Running | Cycling | Workout | Swimming | Other
  distanceKm : number
  durationSec: number
  likes      : number
  comments   : number
  createdAt  : timestamp (serverTimestamp)
```

## How the code maps to this

| Screen / feature            | Reads / writes                                   |
| --------------------------- | ------------------------------------------------ |
| Sign-up details             | writes `users/{uid}` (name, age, height, weight) |
| Auth gate (first sign-in)   | seeds `users/{uid}` with defaults if missing     |
| Home – Daily Summary        | today's calories (`meals`), active minutes + distance (`activities`) |
| Home – Weekly Distance      | last 7 days of `activities`, bucketed per day    |
| Home – Achievements         | all-time totals from `activities` (count, distance) |
| Stats – 8-week chart + heatmap + totals | all derived from `activities` |
| Calorie Tracking            | live `meals` for today; Add/Delete a meal        |
| Activity Feed               | live `activities`, newest first                  |
| Start Activity              | writes an `activities` doc                        |
| Profile – Today's Progress  | today's calories + distance vs goal              |
| Profile / Personal Goals    | reads & writes `users/{uid}.goals`               |
| Personal Details            | reads & writes `users/{uid}` profile fields      |

`ActivitySummary` (in `activity_repository.dart`) computes today / weekly /
8-weekly / all-time / heatmap figures on the client from the single
`activities` stream, so the whole dashboard needs no extra queries or indexes.

## Indexes

None required. Every query uses a single-field range filter ordered on that
same field (`loggedAt` / `createdAt`), which Firestore serves from its
automatic single-field indexes — no `firestore.indexes.json` needed.

## Removed: sensor-only metrics

Steps, heart rate, and sleep were device-sensor metrics with no user-entry
source, so the Heart Rate and Sleep cards were **removed** rather than shown
with fake data. To bring them back for real, add a Health Connect (Android) /
HealthKit (iOS) integration — the `health` package is the usual route. The only
remaining illustrative figure is the Calorie Tracking macro-breakdown donut
(needs per-meal macros, not yet captured).
