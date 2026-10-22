import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../providers/navigation_provider.dart';

class CustomBottomNav extends StatelessWidget {
  final AppNavTab currentTab;
  final ValueChanged<AppNavTab> onTabSelected;

  const CustomBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = (isDark ? AppColors.darkBg : AppColors.lightBg).withValues(alpha: 0.92);
    final borderColor = isDark ? AppColors.darkLine : AppColors.lightLine;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 68 + bottomPadding,
          padding: EdgeInsets.only(bottom: bottomPadding),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(top: BorderSide(color: borderColor, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                tab: AppNavTab.home,
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: currentTab == AppNavTab.home,
                accentColor: accentColor,
                textColor: textColor,
                mutedColor: mutedColor,
              ),
              _buildNavItem(
                tab: AppNavTab.live,
                icon: Icons.sensors_rounded,
                label: 'Live',
                isActive: currentTab == AppNavTab.live,
                accentColor: accentColor,
                textColor: textColor,
                mutedColor: mutedColor,
              ),
              _buildNavItem(
                tab: AppNavTab.schedule,
                icon: Icons.calendar_today_rounded,
                label: 'Schedule',
                isActive: currentTab == AppNavTab.schedule,
                accentColor: accentColor,
                textColor: textColor,
                mutedColor: mutedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required AppNavTab tab,
    required IconData icon,
    required String label,
    required bool isActive,
    required Color accentColor,
    required Color textColor,
    required Color mutedColor,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(tab),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Active top indicator line
            if (isActive)
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: isActive ? textColor : mutedColor,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: AppTypography.dmSans(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      color: isActive ? textColor : mutedColor,
                    ),
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
