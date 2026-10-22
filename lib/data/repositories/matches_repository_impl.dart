import '../../domain/models/match.dart';
import '../../domain/models/sport_category.dart';
import '../../domain/repositories/matches_repository.dart';
import '../datasources/matches_datasource.dart';

class MatchesRepositoryImpl implements MatchesRepository {
  final MatchesDataSource dataSource;

  MatchesRepositoryImpl({required this.dataSource});

  @override
  Future<List<Match>> getAllMatches() async {
    return await dataSource.fetchMatches();
  }

  @override
  Future<List<Match>> getLiveMatches() async {
    final matches = await dataSource.fetchMatches();
    return matches.where((match) => match.isLive).toList();
  }

  @override
  Future<List<Match>> getUpcomingMatches() async {
    final matches = await dataSource.fetchMatches();
    final upcoming = matches.where((match) => !match.isLive).toList();
    upcoming.sort((a, b) {
      final dayComparison = a.dayOffset.compareTo(b.dayOffset);
      if (dayComparison != 0) return dayComparison;
      return a.time.compareTo(b.time);
    });
    return upcoming;
  }

  @override
  Future<List<Match>> getMatchesByCategory(String categoryId) async {
    final matches = await dataSource.fetchMatches();
    if (categoryId == 'all') {
      return matches;
    }
    return matches.where((match) => match.sport == categoryId).toList();
  }

  @override
  Future<List<Match>> getMatchesByDay(int dayOffset) async {
    final upcoming = await getUpcomingMatches();
    return upcoming.where((match) => match.dayOffset == dayOffset).toList();
  }

  @override
  Future<Match?> getMatchById(int id) async {
    final matches = await dataSource.fetchMatches();
    try {
      return matches.firstWhere((match) => match.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<SportCategory> getCategories() {
    return SportCategory.defaults;
  }
}
