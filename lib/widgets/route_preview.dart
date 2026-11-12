import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Lightweight offline route preview.
///
/// The MVP does not bundle real map tiles (that would need network access), so
/// this painter draws an abstract, clearly-labelled "demo route" that matches
/// the Figma treatment. It is decorative plus a text alternative.
class RoutePreview extends StatelessWidget {
  const RoutePreview({
    super.key,
    this.distanceLabel,
    this.height = 148,
  });

  final String? distanceLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label:
          'Demo walking route to the evacuation center${distanceLabel == null ? '' : ', $distanceLabel'}.',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const CustomPaint(painter: _RoutePainter()),
              Positioned(
                left: AppSpacing.sm,
                top: AppSpacing.sm,
                child: _MapChip(
                  icon: Icons.directions_walk,
                  label: distanceLabel ?? 'Demo route',
                ),
              ),
              Positioned(
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: _MapChip(
                  icon: Icons.offline_bolt_outlined,
                  label: 'Saved offline',
                  background: AppColors.ink,
                  foreground: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapChip extends StatelessWidget {
  const _MapChip({
    required this.icon,
    required this.label,
    this.background = AppColors.white,
    this.foreground = AppColors.ink,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.progress),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: foreground,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Base map surface.
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.blueSoft,
    );

    // A hint of a waterway on the left, matching the flood scenario.
    final water = Path()
      ..moveTo(0, size.height * 0.68)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.52,
        size.width * 0.12,
        size.height * 0.92,
        size.width * 0.32,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(water, Paint()..color = AppColors.blue.withValues(alpha: 0.10));

    // Simple street grid.
    final roadPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final thinRoad = Paint()
      ..color = AppColors.white.withValues(alpha: 0.75)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.34),
      Offset(size.width, size.height * 0.22),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, 0),
      Offset(size.width * 0.38, size.height),
      thinRoad,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, 0),
      Offset(size.width * 0.64, size.height),
      thinRoad,
    );

    // Dashed walking route from bottom-left to the pin at top-right.
    final route = Path()
      ..moveTo(size.width * 0.14, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.70,
        size.width * 0.42,
        size.height * 0.56,
      )
      ..quadraticBezierTo(
        size.width * 0.54,
        size.height * 0.42,
        size.width * 0.72,
        size.height * 0.34,
      );

    final routePaint = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final metric in route.computeMetrics()) {
      var distance = 0.0;
      const dash = 8.0;
      const gap = 6.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), routePaint);
        distance = next + gap;
      }
    }

    // Start marker.
    final start = Offset(size.width * 0.14, size.height * 0.82);
    canvas.drawCircle(start, 8, Paint()..color = AppColors.white);
    canvas.drawCircle(start, 5, Paint()..color = AppColors.green);

    // Destination marker.
    final end = Offset(size.width * 0.72, size.height * 0.34);
    canvas.drawCircle(end, 13, Paint()..color = AppColors.white);
    canvas.drawCircle(end, 9, Paint()..color = AppColors.blue);
    canvas.drawCircle(end, 3.5, Paint()..color = AppColors.white);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) => false;
}
