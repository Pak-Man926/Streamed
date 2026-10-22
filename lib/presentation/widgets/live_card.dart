import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/match.dart';
import 'team_badge.dart';

class LiveCard extends StatefulWidget {
  final Match match;
  final VoidCallback onWatch;

  const LiveCard({
    super.key,
    required this.match,
    required this.onWatch,
  });

  @override
  State<LiveCard> createState() => _LiveCardState();
}

class _LiveCardState extends State<LiveCard> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final accentTextColor = isDark ? AppColors.darkAccentText : AppColors.lightAccentText;

    return Container(
      height: 355,
      decoration: BoxDecoration(
        color: const Color(0xFF182018),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2B000000), // rgba(0,0,0,0.17)
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with gradient fallback
          Image.network(
            match.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E281E), Color(0xFF0F160F)],
                ),
              ),
              child: const Icon(
                Icons.sports,
                size: 72,
                color: Color(0x22FFFFFF),
              ),
            ),
          ),

          // Gradient Card Shade
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.4, 1.0],
                colors: [
                  Color(0x26000000),
                  Colors.transparent,
                  Color(0xF0040A05),
                ],
              ),
            ),
          ),

          // Top Header: Live Pill & League
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Live indicator badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.liveRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _blinkController,
                        builder: (context, child) => Opacity(
                          opacity: 0.3 + (_blinkController.value * 0.7),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE · ${match.minute}',
                        style: AppTypography.dmSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // League Glass Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0x26000000),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    match.league.split(' · ').first.toUpperCase(),
                    style: AppTypography.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content at bottom: Venue, Scoreboard, Watch Live button
          Positioned(
            left: 17,
            right: 17,
            bottom: 17,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  match.venue,
                  textAlign: TextAlign.center,
                  style: AppTypography.dmSans(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.68),
                  ),
                ),
                const SizedBox(height: 12),

                // Hero Score
                Row(
                  children: [
                    // Home Team
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TeamBadge(
                            code: match.homeCode,
                            colorHex: match.colorA,
                            size: 46,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            match.home,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Score Display
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        match.score,
                        style: AppTypography.barlow(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Away Team
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TeamBadge(
                            code: match.awayCode,
                            colorHex: match.colorB,
                            size: 46,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            match.away,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Watch Live Button
                Material(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: widget.onWatch,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            size: 20,
                            color: accentTextColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Watch live',
                            style: AppTypography.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: accentTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
