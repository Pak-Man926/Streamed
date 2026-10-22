import '../models/match.dart';
import '../models/sport_category.dart';

abstract class MatchesRepository {
  Future<List<Match>> getAllMatches();
  Future<List<Match>> getLiveMatches();
  Future<List<Match>> getUpcomingMatches();
  Future<List<Match>> getMatchesByCategory(String categoryId);
  Future<List<Match>> getMatchesByDay(int dayOffset);
  Future<Match?> getMatchById(int id);
  List<SportCategory> getCategories();
}
