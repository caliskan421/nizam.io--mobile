import 'package:flutter/rendering.dart';

import '../../../tasks/tasks.dart' show TaskDependency;

/// Bir bağımlılık okunun uçları: ön görev çubuğu [from], bağımlı görev çubuğu [to]
/// (çizelge koordinatlarında); [cross] başka koordinatörlüğe bağ (soluk çizilir).
typedef TimelineLinkEnds = ({Rect from, Rect to, bool cross});

/// [links] içinden iki ucu da çizelgede olan bağları [rectOf] ile uçlara çevirir.
List<TimelineLinkEnds> timelineLinkEnds(
  Iterable<TaskDependency> links,
  Rect? Function(String code) rectOf,
) => [
  for (final l in links)
    if ((rectOf(l.dependsOnId), rectOf(l.workItemId)) case (
      final from?,
      final to?,
    ))
      (from: from, to: to, cross: l.crossDepartment ?? false),
];

/// Bağımlılık okları (prototip "Bağımlılıkları göster"): ön görevin bitişinden bağımlının
/// başlangıcına dirsekli çizgi ve ok başı. Telefon ve tablet çizelgesi aynı ressamı kullanır.
class TimelineLinksPainter extends CustomPainter {
  TimelineLinksPainter({
    required this.links,
    required this.color,
    required this.crossColor,
  });

  final List<TimelineLinkEnds> links;
  final Color color;
  final Color crossColor;

  static const _out = 8.0;
  static const _head = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    for (final l in links) {
      final paint = Paint()
        ..color = l.cross ? crossColor : color
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      final a = Offset(l.from.right, l.from.center.dy);
      final b = Offset(l.to.left, l.to.center.dy);
      final turn = a.dx + _out <= b.dx - _out ? a.dx + _out : null;
      final path = Path()..moveTo(a.dx, a.dy);
      if (turn != null) {
        path
          ..lineTo(turn, a.dy)
          ..lineTo(turn, b.dy)
          ..lineTo(b.dx, b.dy);
      } else {
        // Bağımlı, ön görev bitmeden başlıyor: çubukların arasından dolaşır.
        final midY = (a.dy + b.dy) / 2;
        path
          ..lineTo(a.dx + _out, a.dy)
          ..lineTo(a.dx + _out, midY)
          ..lineTo(b.dx - _out, midY)
          ..lineTo(b.dx - _out, b.dy)
          ..lineTo(b.dx, b.dy);
      }
      canvas.drawPath(path, paint);
      canvas.drawPath(
        Path()
          ..moveTo(b.dx, b.dy)
          ..lineTo(b.dx - _head, b.dy - _head)
          ..lineTo(b.dx - _head, b.dy + _head)
          ..close(),
        Paint()..color = paint.color,
      );
    }
  }

  @override
  bool shouldRepaint(TimelineLinksPainter old) =>
      old.links != links || old.color != color || old.crossColor != crossColor;
}
