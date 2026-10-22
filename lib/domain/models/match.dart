class Match {
  final int id;
  final String sport;
  final String league;
  final String minute;
  final String home;
  final String away;
  final String homeCode;
  final String awayCode;
  final String score;
  final bool isLive;
  final int dayOffset;
  final String time;
  final String venue;
  final String colorA;
  final String colorB;
  final String imageUrl;

  const Match({
    required this.id,
    required this.sport,
    required this.league,
    required this.minute,
    required this.home,
    required this.away,
    required this.homeCode,
    required this.awayCode,
    required this.score,
    required this.isLive,
    required this.dayOffset,
    required this.time,
    required this.venue,
    required this.colorA,
    required this.colorB,
    required this.imageUrl,
  });

  Match copyWith({
    int? id,
    String? sport,
    String? league,
    String? minute,
    String? home,
    String? away,
    String? homeCode,
    String? awayCode,
    String? score,
    bool? isLive,
    int? dayOffset,
    String? time,
    String? venue,
    String? colorA,
    String? colorB,
    String? imageUrl,
  }) {
    return Match(
      id: id ?? this.id,
      sport: sport ?? this.sport,
      league: league ?? this.league,
      minute: minute ?? this.minute,
      home: home ?? this.home,
      away: away ?? this.away,
      homeCode: homeCode ?? this.homeCode,
      awayCode: awayCode ?? this.awayCode,
      score: score ?? this.score,
      isLive: isLive ?? this.isLive,
      dayOffset: dayOffset ?? this.dayOffset,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      colorA: colorA ?? this.colorA,
      colorB: colorB ?? this.colorB,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Match &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
