# ChoreBloom (SwiftUI iPhone App)

ChoreBloom is an original family chore app concept built with SwiftUI + MVVM and local-first persistence (SwiftData).

## Highlights
- Original product concept, copy, and visual direction (no copied branding or protected UX from other apps).
- Family members with names, avatar colors, and point totals.
- Chore creation with title, assignee, repeat schedule, due date, and points.
- Daily + weekly task views.
- Completion celebration animation and points updates.
- Rewards screen with badge unlock progression.
- Overdue reminder notifications.
- StoreKit 2 monetization model:
  - Free tier: limited members + chores.
  - Premium tier: unlimited chores/members and expanded feature gates.
- Sample household data seeding for development and previews.

## Project Structure
- `ChoreBloom/Models`: SwiftData models and shared types.
- `ChoreBloom/Services`: StoreKit and notification services.
- `ChoreBloom/ViewModels`: MVVM logic.
- `ChoreBloom/Views`: Screen and reusable component views.
- `ChoreBloom/PreviewContent`: Sample household and rewards seed data.

## Notes
To run in Xcode, create an iOS App target named **ChoreBloom** and add these Swift files to that target.
