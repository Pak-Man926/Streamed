import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/models/match.dart';
import '../providers/player_provider.dart';
import '../widgets/brand_logo.dart';

class PlayerScreen extends ConsumerWidget {
  final Match match;
  final VoidCallback onClose;

  const PlayerScreen({
    super.key,
    required this.match,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(isPlayerPlayingProvider);
    final isFullscreen = ref.watch(isPlayerFullscreenProvider);
    final dateInfo = DateFormatter.getScheduleDate(match.dayOffset);

    return Scaffold(
      backgroundColor: const Color(0xFF0D100D),
      body: SafeArea(
        top: !isFullscreen,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Video Player Section
              Container(
                height: isFullscreen
                    ? MediaQuery.of(context).size.height
                    : 390,
                color: const Color(0xFF050605),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    Image.network(
                      match.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF141914),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.live_tv_rounded,
                          size: 64,
                          color: Color(0x33FFFFFF),
                        ),
                      ),
                    ),

                    // Video Shade
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.35, 1.0],
                          colors: [
                            Color(0x73000000),
                            Colors.transparent,
                            Color(0xB8000000),
                          ],
                        ),
                      ),
                    ),

                    // Top Bar: Close Button, Compact Brand, Fullscreen
                    Positioned(
                      top: 16,
                      left: 18,
                      right: 18,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGlassButton(
                            icon: Icons.close_rounded,
                            onTap: onClose,
                          ),
                          BrandLogo(
                            compact: true,
                            size: 34,
                            tileColor: const Color(0x8C0A0A0A),
                            streamColor: AppColors.darkAccent,
                            playColor: AppColors.darkAccent,
                          ),
                          _buildGlassButton(
                            icon: isFullscreen
                                ? Icons.fullscreen_exit_rounded
                                : Icons.fullscreen_rounded,
                            onTap: () {
                              ref
                                  .read(isPlayerFullscreenProvider.notifier)
                                  .state = !isFullscreen;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Live / Preview Pill
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: match.isLive
                                ? AppColors.liveRed
                                : const Color(0xCC1A201A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (match.isLive) ...[
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                match.isLive
                                    ? 'LIVE · ${match.minute}'
                                    : 'MATCH PREVIEW',
                                style: AppTypography.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Central Play / Pause Button
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref.read(isPlayerPlayingProvider.notifier).state =
                                !isPlaying;
                          },
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: AppColors.darkAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  spreadRadius: 9,
                                ),
                              ],
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 34,
                              color: AppColors.darkAccentText,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Floating Score
                    Positioned(
                      bottom: 68,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            match.homeCode,
                            style: AppTypography.barlow(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            match.score,
                            style: AppTypography.barlow(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            match.awayCode,
                            style: AppTypography.barlow(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Video Controls Bar
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 16,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Scrubber bar
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: isPlaying ? 0.78 : 0.45,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.darkAccent,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Control icons & time status
                          Row(
                            children: [
                              const Icon(
                                Icons.volume_up_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.4)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'HD',
                                  style: AppTypography.dmSans(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                match.isLive
                                    ? '72:18 / 90:00'
                                    : 'Preview · 00:24',
                                style: AppTypography.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.65),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Player Details Bottom Sheet
              if (!isFullscreen)
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 14, 22, 35),
                  decoration: const BoxDecoration(
                    color: AppColors.playerSheetBg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.playerHandle,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Eyebrow League
                      Text(
                        match.league.toUpperCase(),
                        style: AppTypography.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF8E968B),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Home vs Away
                      RichText(
                        text: TextSpan(
                          style: AppTypography.barlow(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                          children: [
                            TextSpan(text: match.home),
                            TextSpan(
                              text: ' vs ',
                              style: AppTypography.barlow(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkAccent,
                              ),
                            ),
                            TextSpan(text: match.away),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Venue
                      Text(
                        match.venue,
                        style: AppTypography.dmSans(
                          fontSize: 11,
                          color: const Color(0xFF8E968B),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Match Facts Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildFactCard(
                              label: 'STATUS',
                              value: match.isLive
                                  ? 'Live now'
                                  : '${dateInfo.day} · ${match.time}',
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: _buildFactCard(
                              label: 'COVERAGE',
                              value: 'HD · English',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0x800A0A0A),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFactCard({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.playerCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.dmSans(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF8E968B),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: AppTypography.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
