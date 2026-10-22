import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/models/match.dart';
import 'team_badge.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surface2Color = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final borderColor = isDark ? AppColors.darkLine : AppColors.lightLine;

    final dateInfo = DateFormatter.getScheduleDate(match.dayOffset);
    final statusText = match.isLive
        ? match.minute
        : '${dateInfo.day} · ${match.time}';

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Image with Status Badge
          SizedBox(
            height: 106,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  match.imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black.withValues(alpha: 0.2),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: surface2Color,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.sports_soccer_outlined,
                      size: 40,
                      color: mutedColor,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: match.isLive
                          ? AppColors.liveRed
                          : const Color(0xA80A0C0A),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (match.isLive) ...[
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          statusText.toUpperCase(),
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
                ),
              ],
            ),
          ),

          // Match Info Section
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 15),
            child: Column(
              children: [
                // League Eyebrow
                Text(
                  match.league.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.dmSans(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: mutedColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Match Row: Home, Score button, Away
                Row(
                  children: [
                    // Home Team
                    Expanded(
                      child: Row(
                        children: [
                          TeamBadge(
                            code: match.homeCode,
                            colorHex: match.colorA,
                            size: 34,
                            fontSize: 10,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              match.home,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.barlow(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Center Score & Action
                    InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              match.score,
                              style: AppTypography.barlow(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              match.isLive ? 'WATCH' : 'PREVIEW',
                              style: AppTypography.dmSans(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                color: AppColors.scoreAccent,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Away Team
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              match.away,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.barlow(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TeamBadge(
                            code: match.awayCode,
                            colorHex: match.colorB,
                            size: 34,
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
