import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/ui/extensions/context_ext.dart';

class TablesUnitTile extends StatelessWidget {
  const TablesUnitTile({
    super.key,
    required this.name,
    required this.count,
    required this.caption,
    required this.onTap,
    this.when,
  });
  final String name;
  final int count;
  final String caption;
  final String? when;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(14);
    final empty = count == 0;
    Widget layer(double offset, Color color) => Positioned.fill(
      left: offset,
      right: -offset,
      top: -offset,
      bottom: offset,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius,
          border: Border.all(color: c.borderStrong),
        ),
      ),
    );
    return Semantics(
      button: true,
      label: '$name, ${empty ? 'boş' : '$count $caption'}',
      child: SizedBox(
        height: 132,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (count >= 3) layer(10, c.surface),
            if (count >= 2) layer(5, c.surfaceRaised),
            Positioned.fill(
              child: Material(
                color: empty ? Colors.transparent : c.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: radius,
                  side: empty ? BorderSide.none : BorderSide(color: c.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onTap,
                  child: CustomPaint(
                    painter: _TableTilePainter(
                      grid: c.text.withValues(alpha: .06),
                      border: c.border,
                      tint: Color.lerp(
                        c.surfaceRaised,
                        const Color(0xff74c27a),
                        .26,
                      )!,
                      surface: c.surface,
                      empty: empty,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 40, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 42),
                            child: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.bodyMd.copyWith(
                                fontSize: 15,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                                color: empty ? c.textMuted : c.text,
                              ),
                            ),
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              Text(
                                empty ? 'boş' : '$count $caption',
                                style: context.text.monoSm.copyWith(
                                  fontSize: 12,
                                  color: empty ? c.textMuted : c.text,
                                ),
                              ),
                              if (!empty && when != null) ...[
                                const Gap(8),
                                Expanded(
                                  child: Text(
                                    when!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: context.text.monoSm.copyWith(
                                      fontSize: 11,
                                      color: c.textFaint,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableTilePainter extends CustomPainter {
  const _TableTilePainter({
    required this.grid,
    required this.border,
    required this.tint,
    required this.surface,
    required this.empty,
  });
  final Color grid, border, tint, surface;
  final bool empty;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    if (!empty) {
      for (var y = 24.0; y < size.height; y += 24) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
    for (var i = 1; i < 3; i++) {
      final x = size.width * i / 3;
      canvas.drawLine(
        Offset(x, empty ? 0 : 24),
        Offset(x, empty ? 24 : size.height),
        paint,
      );
    }
    if (empty) {
      final dash = Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      final path = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Offset.zero & size,
            const Radius.circular(14),
          ),
        );
      for (final metric in path.computeMetrics()) {
        for (var d = 0.0; d < metric.length; d += 6) {
          canvas.drawPath(
            metric.extractPath(d, (d + 3).clamp(0, metric.length)),
            dash,
          );
        }
      }
      for (var x = 0.0; x < size.width; x += 6) {
        canvas.drawLine(
          Offset(x, 24),
          Offset((x + 3).clamp(0, size.width), 24),
          dash,
        );
      }
    } else {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, 24),
        Paint()..color = tint,
      );
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              surface.withValues(alpha: 0),
              surface.withValues(alpha: 0),
              surface,
            ],
            stops: const [0, .4, .92],
          ).createShader(Offset.zero & size),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TableTilePainter old) =>
      old.grid != grid ||
      old.border != border ||
      old.tint != tint ||
      old.surface != surface ||
      old.empty != empty;
}

class TablesTemplateTile extends StatelessWidget {
  const TablesTemplateTile({
    super.key,
    required this.name,
    required this.caption,
    required this.icon,
    required this.onTap,
  });
  final String name;
  final String caption;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: context.colors.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: context.colors.surfaceRaised,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: context.colors.textMuted),
            ),
            const Gap(6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.caption.copyWith(fontWeight: FontWeight.w600),
            ),
            const Gap(4),
            Text(
              caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.caption.copyWith(
                color: context.colors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
