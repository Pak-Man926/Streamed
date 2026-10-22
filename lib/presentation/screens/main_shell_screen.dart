import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../providers/navigation_provider.dart';
import '../providers/player_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/brand_logo.dart';
import '../widgets/custom_bottom_nav.dart';
import 'home_screen.dart';
import 'live_screen.dart';
import 'player_screen.dart';
import 'schedule_screen.dart';
import 'splash_screen.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {

    final currentTab = ref.watch(navigationProvider);
    final themeMode = ref.watch(themeModeProvider);
    final selectedMatch = ref.watch(selectedPlayerMatchProvider);

    final isDark = themeMode == ThemeMode.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkLine : AppColors.lightLine;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final bodyBgColor = isDark ? AppColors.darkBodyBg : AppColors.lightBodyBg;

    return Scaffold(
      backgroundColor: bodyBgColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Stack(
              children: [
                // Main Content View
                Column(
                  children: [
                    // Top App Bar
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BrandLogo(),
                            Row(
                              children: [
                                // Theme Toggle Button
                                _buildCircleIconButton(
                                  icon: isDark
                                      ? Icons.wb_sunny_outlined
                                      : Icons.nightlight_round_outlined,
                                  surfaceColor: surfaceColor,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  onTap: () {
                                    ref
                                        .read(themeModeProvider.notifier)
                                        .toggleTheme();
                                  },
                                ),
                                const SizedBox(width: 8),

                                // Notification Button with Red Indicator
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    _buildCircleIconButton(
                                      icon: Icons.notifications_none_rounded,
                                      surfaceColor: surfaceColor,
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'No new notifications right now.'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: AppColors.notificationRed,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: surfaceColor,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Active Tab Screen
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: switch (currentTab) {
                          AppNavTab.home => const HomeScreen(key: ValueKey('home')),
                          AppNavTab.live => const LiveScreen(key: ValueKey('live')),
                          AppNavTab.schedule =>
                            const ScheduleScreen(key: ValueKey('schedule')),
                        },
                      ),
                    ),
                  ],
                ),

                // Fixed Floating Bottom Navigation
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomBottomNav(
                    currentTab: currentTab,
                    onTabSelected: (tab) {
                      ref.read(navigationProvider.notifier).setTab(tab);
                    },
                  ),
                ),

                // Player Modal View (Animated slide-up overlay)
                if (selectedMatch != null)
                  Positioned.fill(
                    child: PlayerScreen(
                      match: selectedMatch,
                      onClose: () {
                        ref.read(selectedPlayerMatchProvider.notifier).state =
                            null;
                      },
                    ),
                  ),

                // Splash Screen Overlay
                if (_showSplash)
                  Positioned.fill(
                    child: SplashScreen(
                      onFinish: () {
                        setState(() {
                          _showSplash = false;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: surfaceColor,
      shape: CircleBorder(
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: 20,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
