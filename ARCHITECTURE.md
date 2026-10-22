# Streamed App Architecture

This project is built using **Flutter**, **Clean Architecture**, and **Riverpod** state management.

## Architectural Layers

```
lib/
├── core/                           # Cross-cutting concerns & shared infrastructure
│   ├── constants/                  # Application constants (name, tagline, max width)
│   ├── theme/                      # AppColors, AppTypography (GoogleFonts), AppTheme
│   └── utils/                      # Date formatting & schedule utilities
├── domain/                         # Enterprise business rules & clean models
│   ├── models/                     # Match, SportCategory entities
│   └── repositories/               # MatchesRepository contract/interface
├── data/                           # Data access & external models
│   ├── datasources/                # MatchesDataSource, MockMatchesDataSource
│   ├── models/                     # MatchModel (JSON serialization & entity mapping)
│   └── repositories/               # MatchesRepositoryImpl
└── presentation/                   # UI & State Management
    ├── providers/                  # Riverpod providers
    │   ├── theme_provider.dart     # Dark & light theme mode management
    │   ├── navigation_provider.dart# Bottom navigation tab state
    │   ├── category_provider.dart  # Sport category & schedule day state
    │   ├── matches_provider.dart   # Live, upcoming, category, and schedule match providers
    │   └── player_provider.dart    # Video playback & modal state
    ├── screens/                    # Application screens
    │   ├── splash_screen.dart      # Animated radar rings, brand logo & progress loader
    │   ├── main_shell_screen.dart  # Top bar, active tab host, bottom nav, modal player
    │   ├── home_screen.dart        # Hero title, live carousel, categories, coming up, matches
    │   ├── live_screen.dart        # Dedicated live games view with real-time indicators
    │   ├── schedule_screen.dart    # 7-day horizontal strip, day headers, fixture list, empty state
    │   └── player_screen.dart      # Fullscreen video preview, play/pause, facts & scrubber
    └── widgets/                    # Reusable atomic UI components
        ├── brand_logo.dart         # Scalable vector custom painter for Strreamed logo
        ├── category_chip.dart      # Animated sport category filter chips
        ├── custom_bottom_nav.dart  # Glassmorphic blurred bottom navigation bar
        ├── live_card.dart          # Hero live card with pulsing indicator & scoreboard
        ├── live_carousel.dart      # Paging carousel with synchronized dot indicators
        ├── match_card.dart         # Fixture card with status badge & score action
        ├── schedule_row.dart       # Detailed fixture row for schedule & preview
        └── team_badge.dart         # Color-blended team initial badge
```

## State Management with Riverpod

- **`themeModeProvider`**: Reactive theme state management toggling between dark and light palettes.
- **`navigationProvider`**: Tracks active navigation tab (`home`, `live`, `schedule`) with smooth page transitions.
- **`selectedCategoryProvider`**: Reactive sport category filter on the Home screen.
- **`selectedScheduleDayProvider`**: Reactive 7-day date selector on the Schedule screen.
- **`liveMatchesProvider` & `upcomingMatchesProvider`**: Auto-updating FutureProviders powered by the repository.
- **`selectedPlayerMatchProvider`**: Manages opening and closing the match player modal.