import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/matches_datasource.dart';
import '../../data/datasources/mock_matches_datasource.dart';
import '../../data/repositories/matches_repository_impl.dart';
import '../../domain/models/match.dart';
import '../../domain/models/sport_category.dart';
import '../../domain/repositories/matches_repository.dart';
import 'category_provider.dart';

final matchesDataSourceProvider = Provider<MatchesDataSource>((ref) {
  return MockMatchesDataSource();
});

final matchesRepositoryProvider = Provider<MatchesRepository>((ref) {
  final dataSource = ref.watch(matchesDataSourceProvider);
  return MatchesRepositoryImpl(dataSource: dataSource);
});

final categoriesProvider = Provider<List<SportCategory>>((ref) {
  final repository = ref.watch(matchesRepositoryProvider);
  return repository.getCategories();
});

final allMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final repository = ref.watch(matchesRepositoryProvider);
  return await repository.getAllMatches();
});

final liveMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final repository = ref.watch(matchesRepositoryProvider);
  return await repository.getLiveMatches();
});

final upcomingMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final repository = ref.watch(matchesRepositoryProvider);
  return await repository.getUpcomingMatches();
});

final categoryMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  final repository = ref.watch(matchesRepositoryProvider);
  return await repository.getMatchesByCategory(category);
});

final scheduleMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final day = ref.watch(selectedScheduleDayProvider);
  final repository = ref.watch(matchesRepositoryProvider);
  return await repository.getMatchesByDay(day);
});
