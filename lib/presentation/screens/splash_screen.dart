import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/brand_logo.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({
    super.key,
    required this.onFinish,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _loaderController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _timer = Timer(const Duration(milliseconds: 2100), () {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ringController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onFinish,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D110D),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.maxContentWidth,
            ),
            child: SizedBox.expand(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Concentric Glowing Rings (centered)
                  ...List.generate(3, (index) {
                    return Center(
                      child: AnimatedBuilder(
                        animation: _ringController,
                        builder: (context, child) {
                          final progress =
                              (_ringController.value + (index * 0.33)) % 1.0;
                          final scale = 0.25 + (progress * 1.55);
                          final opacity = (1.0 - progress).clamp(0.0, 0.7);

                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.darkAccent
                                      .withValues(alpha: opacity * 0.25),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  // Brand & Tagline in Center
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BrandLogo(
                          compact: true,
                          size: 92,
                          tileColor: AppColors.darkAccent,
                          streamColor: AppColors.darkAccentText,
                          playColor: AppColors.darkAccentText,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          AppConstants.appName,
                          textAlign: TextAlign.center,
                          style: AppTypography.barlow(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkText,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppConstants.tagline.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: AppTypography.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF7F887D),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Progress Loader Bar (horizontally centered)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 48,
                    child: SafeArea(
                      child: Center(
                        child: Container(
                          width: 90,
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF252B24),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: AnimatedBuilder(
                            animation: _loaderController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _loaderController.value,
                                child: Container(
                                  color: AppColors.darkAccent,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
