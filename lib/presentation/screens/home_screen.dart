import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_formatter.dart';
import '../providers/category_provider.dart';
import '../providers/matches_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/live_carousel.dart';
import '../widgets/match_card.dart';
import '../widgets/schedule_row.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkLine : AppColors.lightLine;

    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final carouselIndex = ref.watch(liveCarouselIndexProvider);

    final liveMatchesAsync = ref.watch(liveMatchesProvider);
    final upcomingMatchesAsync = ref.watch(upcomingMatchesProvider);
    final categoryMatchesAsync = ref.watch(categoryMatchesProvider);

    final todayFormatted = DateFormatter.formatHeaderDate(DateTime.now());

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allMatchesProvider);
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
                        const TextSpan(text: 'THE GAME\nNEVER '),
                        TextSpan(
                          text: 'STOPS.',
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

            // Live Now Section
            liveMatchesAsync.when(
              data: (liveMatches) {
                if (liveMatches.isEmpty) return const SizedBox.shrink();
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
                                'LIVE NOW',
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
                  ],
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

            const SizedBox(height: 32),

            // Explore Sports Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXPLORE SPORTS',
                        style: AppTypography.barlow(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: categories.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 9),
                          child: CategoryChip(
                            category: cat,
                            isSelected: selectedCategory == cat.id,
                            onTap: () {
                              ref.read(selectedCategoryProvider.notifier).state =
                                  cat.id;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Coming Up / Schedule Preview Section
            upcomingMatchesAsync.when(
              data: (upcoming) {
                final previewList = upcoming.take(3).toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'COMING UP',
                                style: AppTypography.barlow(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'Next on Strreamed',
                                style: AppTypography.dmSans(
                                  fontSize: 10,
                                  color: mutedColor,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              ref
                                  .read(navigationProvider.notifier)
                                  .setTab(AppNavTab.schedule);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Full schedule',
                                  style: AppTypography.dmSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: mutedColor,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 15,
                                  color: mutedColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: previewList.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final match = entry.value;
                            return ScheduleRow(
                              match: match,
                              showDivider: idx < previewList.length - 1,
                              onTap: () {
                                ref
                                    .read(selectedPlayerMatchProvider.notifier)
                                    .state = match;
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 32),

            // Matches Section
            categoryMatchesAsync.when(
              data: (matches) {
                final categoryObj = categories.firstWhere(
                  (c) => c.id == selectedCategory,
                  orElse: () => categories.first,
                );
                final headingTitle = selectedCategory == 'all'
                    ? 'ALL MATCHES'
                    : '${categoryObj.label.toUpperCase()} MATCHES';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            headingTitle,
                            style: AppTypography.barlow(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            '${matches.length} events',
                            style: AppTypography.dmSans(
                              fontSize: 10,
                              color: mutedColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: matches.take(4).length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final match = matches[index];
                          return MatchCard(
                            match: match,
                            onTap: () {
                              ref
                                  .read(selectedPlayerMatchProvider.notifier)
                                  .state = match;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
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
