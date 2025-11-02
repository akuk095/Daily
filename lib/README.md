# Daily Task App - Flutter UI

This is a Flutter application for task management with a beautiful dark-themed UI.

## Features

- **Today Screen**: Displays tasks in a timeline view with:
  - Weekly calendar navigation
  - Timeline with task cards
  - Current time indicator
  - Task status indicators (notifications, timers, etc.)
  - Free time blocks

- **Archive Screen**: Shows completed and archived tasks with:
  - Toggle between Completed and Archived views
  - List of archived tasks
  - Task status indicators

## Running the App

1. Make sure you have Flutter installed (SDK version >=3.0.0)
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Project Structure

```
lib/
├── main.dart                 # App entry point
└── screens/
    ├── today_screen.dart     # Today timeline view
    └── archive_screen.dart   # Archive view
```

## UI Features Implemented

- Dark theme with custom colors
- Bottom navigation bar
- Timeline view with task cards
- Weekly calendar
- Archive screen with toggle buttons
- Responsive layouts
