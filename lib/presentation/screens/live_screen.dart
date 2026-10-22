import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_formatter.dart';
import '../providers/category_provider.dart';
import '../providers/matches_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/live_card.dart';
import '../widgets/live_carousel.dart';

class LiveScreen extends ConsumerWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    final carouselIndex = ref.watch(liveCarouselIndexProvider);
    final liveMatchesAsync = ref.watch(liveMatchesProvider);
    final todayFormatted = DateFormatter.formatHeaderDate(DateTime.now());

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(liveMatchesProvider);
      },
      color: accentColor,
      backgroundColor: surfaceColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intro Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todayFormatted.toUpperCase(),
                    style: AppTypography.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: mutedColor,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: AppTypography.barlow(
                        fontSize: 54,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        height: 0.88,
                        letterSpacing: -1.5,
                      ),
                      children: [
                        const TextSpan(text: 'LIVE RIGHT '),
                        TextSpan(
                          text: 'NOW.',
                          style: TextStyle(
                            color: accentColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Live games
            liveMatchesAsync.when(
              data: (liveMatches) {
                if (liveMatches.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.sensors_off_rounded, size: 48, color: mutedColor),
                          const SizedBox(height: 12),
                          Text(
                            'NO LIVE GAMES RIGHT NOW',
                            style: AppTypography.barlow(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Check the schedule tab for upcoming fixtures.',
                            style: AppTypography.dmSans(
                              fontSize: 12,
                              color: mutedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ALL LIVE GAMES',
                                style: AppTypography.barlow(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                '${liveMatches.length} games in play',
                                style: AppTypography.dmSans(
                                  fontSize: 10,
                                  color: mutedColor,
                                ),
                              ),
                            ],
                          ),
                          CarouselDotsIndicator(
                            count: liveMatches.length,
                            currentIndex: carouselIndex,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    LiveCarousel(
                      matches: liveMatches,
                      currentIndex: carouselIndex,
                      onIndexChanged: (index) {
                        ref.read(liveCarouselIndexProvider.notifier).state = index;
                      },
                      onWatch: (match) {
                        ref.read(selectedPlayerMatchProvider.notifier).state = match;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Additional Live Matches vertical cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: liveMatches.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final match = liveMatches[index];
                          return LiveCard(
                            match: match,
                            onWatch: () {
                              ref
                                  .read(selectedPlayerMatchProvider.notifier)
                                  .state = match;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
