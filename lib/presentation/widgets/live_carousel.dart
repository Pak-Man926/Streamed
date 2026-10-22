import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/match.dart';
import 'live_card.dart';

class LiveCarousel extends StatefulWidget {
  final List<Match> matches;
  final ValueChanged<Match> onWatch;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const LiveCarousel({
    super.key,
    required this.matches,
    required this.onWatch,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  State<LiveCarousel> createState() => _LiveCarouselState();
}

class _LiveCarouselState extends State<LiveCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.9,
      initialPage: widget.currentIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.matches.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 355,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.matches.length,
        onPageChanged: widget.onIndexChanged,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final match = widget.matches[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: LiveCard(
              match: match,
              onWatch: () => widget.onWatch(match),
            ),
          );
        },
      ),
    );
  }
}

class CarouselDotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const CarouselDotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final inactiveColor = isDark ? AppColors.darkLine : AppColors.lightLine;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: isActive ? 18.0 : 5.0,
          height: 5.0,
          decoration: BoxDecoration(
            color: isActive ? accentColor : inactiveColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      }),
    );
  }
}
