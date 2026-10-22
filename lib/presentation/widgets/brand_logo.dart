import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class BrandLogoPainter extends CustomPainter {
  final Color tileColor;
  final Color streamColor;
  final Color playColor;

  BrandLogoPainter({
    required this.tileColor,
    required this.streamColor,
    required this.playColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 52.0;

    // Draw Tile
    final tilePaint = Paint()
      ..color = tileColor
      ..style = PaintingStyle.fill;

    final tileRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(3 * scale, 3 * scale, 46 * scale, 46 * scale),
      Radius.circular(9 * scale),
    );
    canvas.drawRRect(tileRRect, tilePaint);

    // Draw Stream (Continuous path)
    final streamPaint = Paint()
      ..color = streamColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final streamPath = Path()
      ..moveTo(13 * scale, 17 * scale)
      ..lineTo(25 * scale, 17 * scale)
      ..cubicTo(
        31 * scale,
        17 * scale,
        32 * scale,
        25 * scale,
        26 * scale,
        26 * scale,
      )
      ..lineTo(19 * scale, 27 * scale)
      ..cubicTo(
        13 * scale,
        28 * scale,
        14 * scale,
        36 * scale,
        20 * scale,
        36 * scale,
      )
      ..lineTo(38 * scale, 36 * scale);

    canvas.drawPath(streamPath, streamPaint);

    // Draw Play triangle
    final playPaint = Paint()
      ..color = playColor
      ..style = PaintingStyle.fill;

    final playPath = Path()
      ..moveTo(29 * scale, 18 * scale)
      ..lineTo(39 * scale, 24 * scale)
      ..lineTo(29 * scale, 30 * scale)
      ..close();

    canvas.drawPath(playPath, playPaint);
  }

  @override
  bool shouldRepaint(covariant BrandLogoPainter oldDelegate) {
    return oldDelegate.tileColor != tileColor ||
        oldDelegate.streamColor != streamColor ||
        oldDelegate.playColor != playColor;
  }
}

class BrandLogo extends StatelessWidget {
  final bool compact;
  final double size;
  final Color? tileColor;
  final Color? streamColor;
  final Color? playColor;
  final Color? textColor;
  final double? fontSize;

  const BrandLogo({
    super.key,
    this.compact = false,
    this.size = 34,
    this.tileColor,
    this.streamColor,
    this.playColor,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTileColor = tileColor ??
        (isDark ? AppColors.darkAccent : AppColors.lightAccent);
    final effectiveStreamColor = streamColor ??
        (isDark ? AppColors.darkAccentText : AppColors.lightAccentText);
    final effectivePlayColor = playColor ??
        (isDark ? AppColors.darkAccentText : AppColors.lightAccentText);
    final effectiveTextColor = textColor ??
        (isDark ? AppColors.darkText : AppColors.lightText);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: BrandLogoPainter(
              tileColor: effectiveTileColor,
              streamColor: effectiveStreamColor,
              playColor: effectivePlayColor,
            ),
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 9),
          Text(
            'Strreamed',
            style: AppTypography.barlow(
              fontSize: fontSize ?? 22,
              fontWeight: FontWeight.w800,
              color: effectiveTextColor,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ],
    );
  }
}
