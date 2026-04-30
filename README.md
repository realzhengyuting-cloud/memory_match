# Memory Match - Flutter App

## Project Structure

```
memory_match/
├── lib/
│   └── main.dart          # Main game logic and UI
├── test/
│   └── widget_test.dart   # Widget tests
├── web/                   # Web platform files
├── android/               # Android platform files
├── ios/                   # iOS platform files
└── pubspec.yaml           # Dependencies
```

## How to Configure and Run

### Prerequisites
- Flutter SDK (3.x or later)
- Chrome browser (for web) or Android Studio / Xcode (for mobile)

### Run on Chrome (Web)
```bash
cd memory_match
flutter run -d chrome
```

### Run on Android Emulator
```bash
flutter run -d android
```

### Run on iOS Simulator
```bash
flutter run -d ios
```

### Build for Web
```bash
flutter build web
```

## Screenshots

### Initial State
The game starts with 16 face-down cards in a 4x4 grid. Each card has a unique color.

### Gameplay
- Tap a card to flip it and reveal the emoji underneath
- Tap a second card to try to find a match
- Matched pairs stay face-up with a green border
- Unmatched cards flip back after 0.8 seconds

### Features
- 4x4 grid with 8 pairs of emoji cards
- Animated card flip transitions
- Move counter to track attempts
- Progress bar showing matched pairs percentage
- Restart button to reset the game
- Win dialog with play-again option
- Apple-style UI design (SF colors, rounded corners, clean typography)

## Game Rules
1. All cards start face-down
2. Tap any card to flip it over
3. Tap a second card to check for a match
4. If both cards show the same emoji, they stay revealed (matched)
5. If they don't match, both flip back face-down
6. Find all 8 pairs to win the game
