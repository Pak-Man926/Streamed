import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class TeamBadge extends StatelessWidget {
  final String code;
  final String colorHex;
  final double size;
  final double? fontSize;

  const TeamBadge({
    super.key,
    required this.code,
    required this.colorHex,
    this.size = 40,
    this.fontSize,
  });

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _parseColor(colorHex);
    // Background mixed with dark tone
    final bgColor = Color.lerp(const Color(0xFF202020), baseColor, 0.72) ?? baseColor;
    // Border mixed with white
    final borderColor = Color.lerp(Colors.white, baseColor, 0.65) ?? baseColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.18),
            spreadRadius: -2,
            blurRadius: 0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: AppTypography.barlow(
          fontSize: fontSize ?? (size * 0.32),
          fontWeight: FontWeight.w800,
          color: const Color(0xFF101610),
        ),
      ),
    );
  }
}
