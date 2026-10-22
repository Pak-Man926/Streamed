import '../models/match_model.dart';

abstract class MatchesDataSource {
  Future<List<MatchModel>> fetchMatches();
}
