import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamed/data/datasources/mock_matches_datasource.dart';
import 'package:streamed/data/repositories/matches_repository_impl.dart';
import 'package:streamed/main.dart';
import 'package:streamed/presentation/providers/category_provider.dart';
import 'package:streamed/presentation/providers/navigation_provider.dart';
import 'package:streamed/presentation/providers/theme_provider.dart';

void main() {
  group('MatchesRepository Tests', () {
    late MatchesRepositoryImpl repository;

    setUp(() {
      repository = MatchesRepositoryImpl(
        dataSource: MockMatchesDataSource(),
      );
    });

    test('getAllMatches returns all mock matches', () async {
      final matches = await repository.getAllMatches();
      expect(matches.length, equals(8));
    });

    test('getLiveMatches returns only live matches', () async {
      final liveMatches = await repository.getLiveMatches();
      expect(liveMatches.length, equals(3));
      for (final match in liveMatches) {
        expect(match.isLive, isTrue);
      }
    });

    test('getUpcomingMatches returns only non-live matches sorted', () async {
      final upcoming = await repository.getUpcomingMatches();
      expect(upcoming.length, equals(5));
      for (final match in upcoming) {
        expect(match.isLive, isFalse);
      }
    });

    test('getMatchesByCategory filters correctly', () async {
      final footballMatches = await repository.getMatchesByCategory('football');
      expect(footballMatches.length, equals(3));
      for (final match in footballMatches) {
        expect(match.sport, equals('football'));
      }

      final allMatches = await repository.getMatchesByCategory('all');
      expect(allMatches.length, equals(8));
    });

    test('getMatchesByDay returns matches for specific day offset', () async {
      final todayGames = await repository.getMatchesByDay(0);
      expect(todayGames.length, equals(1)); // Arsenal vs Liverpool is day 0
      expect(todayGames.first.home, equals('Arsenal'));

      final tomorrowGames = await repository.getMatchesByDay(1);
      expect(tomorrowGames.length, equals(2)); // Los Angeles vs Chicago, I. Swiatek vs C. Gauff
    });
  });

  group('Riverpod Providers Tests', () {
    test('themeModeProvider toggles between dark and light', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), equals(ThemeMode.dark));

      container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.light));

      container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
    });

    test('navigationProvider updates active tab', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(navigationProvider), equals(AppNavTab.home));

      container.read(navigationProvider.notifier).setTab(AppNavTab.live);
      expect(container.read(navigationProvider), equals(AppNavTab.live));

      container.read(navigationProvider.notifier).setTab(AppNavTab.schedule);
      expect(container.read(navigationProvider), equals(AppNavTab.schedule));
    });

    test('selectedCategoryProvider updates category filter', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(selectedCategoryProvider), equals('all'));

      container.read(selectedCategoryProvider.notifier).state = 'basketball';
      expect(container.read(selectedCategoryProvider), equals('basketball'));
    });
  });

  group('Widget Smoke Tests', () {
    testWidgets('StreamedApp renders and displays Strreamed splash branding',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: StreamedApp(),
        ),
      );

      // Verify splash screen displays Brand title and tagline
      expect(find.text('EVERY GAME. ONE STREAM.'), findsOneWidget);
      expect(find.text('Strreamed'), findsAtLeastNWidgets(1));

      // Tap on splash to finish immediately
      await tester.tap(find.text('EVERY GAME. ONE STREAM.'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
