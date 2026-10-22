import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_formatter.dart';
import '../providers/category_provider.dart';
import '../providers/matches_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/schedule_row.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final accentTextColor = isDark ? AppColors.darkAccentText : AppColors.lightAccentText;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkLine : AppColors.lightLine;

    final selectedDay = ref.watch(selectedScheduleDayProvider);
    final scheduleMatchesAsync = ref.watch(scheduleMatchesProvider);
    final selectedDayInfo = DateFormatter.getScheduleDate(selectedDay);

    final dayOffsets = List.generate(7, (index) => index);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Page Heading
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEVER MISS A MOMENT',
                  style: AppTypography.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: mutedColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'SCHEDULE',
                  style: AppTypography.barlow(
                    fontSize: 54,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 0.88,
                    letterSpacing: -1.5,
                  ),
                ),
              ],
            ),
          ),

          // Date Picker Horizontal Strip
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: dayOffsets.map((offset) {
                final dateInfo = DateFormatter.getScheduleDate(offset);
                final isSelected = offset == selectedDay;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ref.read(selectedScheduleDayProvider.notifier).state =
                            offset;
                      },
                      borderRadius: BorderRadius.circular(17),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 58,
                        height: 76,
                        decoration: BoxDecoration(
                          color: isSelected ? accentColor : surfaceColor,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                            color: isSelected ? accentColor : borderColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dateInfo.day.toUpperCase(),
                              style: AppTypography.dmSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? accentTextColor : mutedColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dateInfo.number}',
                              style: AppTypography.barlow(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? accentTextColor : textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Day Heading with date and games count
          scheduleMatchesAsync.when(
            data: (games) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        selectedDayInfo.day.toUpperCase(),
                        style: AppTypography.barlow(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedDayInfo.date,
                        style: AppTypography.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: mutedColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${games.length} games',
                    style: AppTypography.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),

          // Schedule List
          scheduleMatchesAsync.when(
            data: (games) {
              if (games.isEmpty) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 32,
                        color: mutedColor,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'NO FIXTURES YET',
                        style: AppTypography.barlow(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Check another day for upcoming games.',
                        style: AppTypography.dmSans(
                          fontSize: 11,
                          color: mutedColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: games.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final match = entry.value;
                    return ScheduleRow(
                      match: match,
                      showDivider: idx < games.length - 1,
                      onTap: () {
                        ref.read(selectedPlayerMatchProvider.notifier).state =
                            match;
                      },
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
