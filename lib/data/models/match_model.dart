import '../../domain/models/match.dart';

class MatchModel extends Match {
  const MatchModel({
    required super.id,
    required super.sport,
    required super.league,
    required super.minute,
    required super.home,
    required super.away,
    required super.homeCode,
    required super.awayCode,
    required super.score,
    required super.isLive,
    required super.dayOffset,
    required super.time,
    required super.venue,
    required super.colorA,
    required super.colorB,
    required super.imageUrl,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as int,
      sport: json['sport'] as String,
      league: json['league'] as String,
      minute: json['minute'] as String? ?? '',
      home: json['home'] as String,
      away: json['away'] as String,
      homeCode: json['homeCode'] as String,
      awayCode: json['awayCode'] as String,
      score: json['score'] as String,
      isLive: json['live'] as bool? ?? (json['isLive'] as bool? ?? false),
      dayOffset: json['day'] as int? ?? (json['dayOffset'] as int? ?? 0),
      time: json['time'] as String,
      venue: json['venue'] as String,
      colorA: json['colorA'] as String,
      colorB: json['colorB'] as String,
      imageUrl: json['image'] as String? ?? (json['imageUrl'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sport': sport,
      'league': league,
      'minute': minute,
      'home': home,
      'away': away,
      'homeCode': homeCode,
      'awayCode': awayCode,
      'score': score,
      'live': isLive,
      'day': dayOffset,
      'time': time,
      'venue': venue,
      'colorA': colorA,
      'colorB': colorB,
      'image': imageUrl,
    };
  }

  factory MatchModel.fromEntity(Match match) {
    return MatchModel(
      id: match.id,
      sport: match.sport,
      league: match.league,
      minute: match.minute,
      home: match.home,
      away: match.away,
      homeCode: match.homeCode,
      awayCode: match.awayCode,
      score: match.score,
      isLive: match.isLive,
      dayOffset: match.dayOffset,
      time: match.time,
      venue: match.venue,
      colorA: match.colorA,
      colorB: match.colorB,
      imageUrl: match.imageUrl,
    );
  }
}
