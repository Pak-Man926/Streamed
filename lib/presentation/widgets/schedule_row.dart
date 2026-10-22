import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/match.dart';
import 'team_badge.dart';

class ScheduleRow extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;
  final bool showDivider;

  const ScheduleRow({
    super.key,
    required this.match,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final dividerColor = isDark ? AppColors.darkLine : AppColors.lightLine;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: dividerColor, width: 1))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Time Column
            SizedBox(
              width: 50,
              child: Text(
                match.time,
                style: AppTypography.barlow(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: mutedColor,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Teams Column & League
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Home Team
                  Row(
                    children: [
                      TeamBadge(
                        code: match.homeCode,
                        colorHex: match.colorA,
                        size: 24,
                        fontSize: 8,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          match.home,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.barlow(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),

                  // Away Team
                  Row(
                    children: [
                      TeamBadge(
                        code: match.awayCode,
                        colorHex: match.colorB,
                        size: 24,
                        fontSize: 8,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          match.away,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.barlow(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // League & Chevron
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          match.league.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.dmSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: mutedColor,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: mutedColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
