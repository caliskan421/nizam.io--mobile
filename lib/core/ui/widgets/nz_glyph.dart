import 'package:flutter/widgets.dart';

/// Tasarım çizgi ikonu (RoketPortal ana sayfa ikon seti): 24×24 görünüm kutusunda tek SVG yolu,
/// çizgi 1.75, yuvarlak uç ve birleşim; dolgu yok. Yol verisi pakete bağlı kalmadan [NzGlyphIcon]
/// içinde çizilir (M/L/H/V/C/S/A/Z, mutlak ve göreli).
@immutable
final class NzGlyph {
  const NzGlyph(this.path);

  final String path;
}

/// Ana sayfada kullanılan ikonlar (kaynak: tasarım ikon zip'i, dosya adı yorumda).
abstract final class NzGlyphs {
  /// onay-tik
  static const done = NzGlyph('M5 12.5l4.5 4.5L19 7');

  /// devam-eden-simsek
  static const inProgress = NzGlyph('M13 2 4 14h7l-1 8 9-12h-7z');

  /// onay-bekleyen-saat
  static const review = NzGlyph(
    'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 7v5l3 2',
  );

  /// baslamadi
  static const notStarted = NzGlyph(
    'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM9 12h6',
  );

  /// gecikme-uyari
  static const late = NzGlyph('M12 3 2 20h20zM12 10v4M12 17h.01');

  /// tarih-talebi
  static const dateRequest = NzGlyph(
    'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4M12 13v4M10 15h4',
  );

  /// ok-capraz
  static const northEast = NzGlyph('M7 17L17 7M9 7h8v8');

  /// islem-gecmisi
  static const history = NzGlyph(
    'M3 12a9 9 0 1 0 3-6.7L3 8M3 3v5h5M12 7v5l3 2',
  );

  /// toplanti
  static const meeting = NzGlyph('M15 10l5-3v10l-5-3zM3 7h12v10H3z');

  /// silinenler
  static const deleted = NzGlyph(
    'M4 7h16M10 11v6M14 11v6M5 7l1 13h12l1-13M9 7V4h6v3',
  );

  /// rapor
  static const report = NzGlyph(
    'M14 3H6a1 1 0 0 0-1 1v16a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V8zM14 3v5h5M9 13h6M9 17h6',
  );

  /// yeni-ekle
  static const add = NzGlyph('M12 5v14M5 12h14');

  /// uye-ekle
  static const personAdd = NzGlyph(
    'M15 19a6 6 0 0 0-12 0M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM19 8v6M16 11h6',
  );
}

/// [NzGlyph]'i [IconTheme] boyut ve rengiyle (ya da verilenle) çizer; görseldir.
class NzGlyphIcon extends StatelessWidget {
  const NzGlyphIcon(this.glyph, {super.key, this.size, this.color});

  final NzGlyph glyph;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final side = size ?? theme.size ?? 24;
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(side),
        painter: _GlyphPainter(
          glyphPath(glyph.path),
          color ?? theme.color ?? const Color(0xFF000000),
        ),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  const _GlyphPainter(this.path, this.color);

  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.75
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.path != path || old.color != color;
}

final _cache = <String, Path>{};

/// SVG yol verisini [Path]'e çevirir (24 birimlik görünüm kutusunda). Sonuç önbelleklenir.
Path glyphPath(String data) => _cache.putIfAbsent(data, () => _parse(data));

Path _parse(String data) {
  final tokens = RegExp(
    r'[MmLlHhVvCcSsAaZz]|-?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?',
  ).allMatches(data).map((m) => m[0]!).toList();
  final path = Path();
  var i = 0;
  var cmd = '';
  var x = 0.0, y = 0.0, startX = 0.0, startY = 0.0;
  // Son kübik kontrol noktası (S yansıtması için).
  double? cx2, cy2;
  bool isCmd(String t) => RegExp(r'^[A-Za-z]$').hasMatch(t);
  double n() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    if (isCmd(tokens[i])) cmd = tokens[i++];
    final rel = cmd == cmd.toLowerCase();
    final ox = rel ? x : 0.0, oy = rel ? y : 0.0;
    switch (cmd.toUpperCase()) {
      case 'M':
        x = ox + n();
        y = oy + n();
        path.moveTo(x, y);
        startX = x;
        startY = y;
        // Ardışık çiftler örtük L'dir.
        cmd = rel ? 'l' : 'L';
        cx2 = null;
      case 'L':
        x = ox + n();
        y = oy + n();
        path.lineTo(x, y);
        cx2 = null;
      case 'H':
        x = ox + n();
        path.lineTo(x, y);
        cx2 = null;
      case 'V':
        y = oy + n();
        path.lineTo(x, y);
        cx2 = null;
      case 'C':
        final x1 = ox + n(), y1 = oy + n();
        final x2 = ox + n(), y2 = oy + n();
        x = ox + n();
        y = oy + n();
        path.cubicTo(x1, y1, x2, y2, x, y);
        cx2 = x2;
        cy2 = y2;
      case 'S':
        final x1 = cx2 == null ? x : 2 * x - cx2;
        final y1 = cy2 == null ? y : 2 * y - cy2;
        final x2 = ox + n(), y2 = oy + n();
        x = ox + n();
        y = oy + n();
        path.cubicTo(x1, y1, x2, y2, x, y);
        cx2 = x2;
        cy2 = y2;
      case 'A':
        final rx = n(), ry = n(), rotation = n();
        final large = n() != 0, sweep = n() != 0;
        x = ox + n();
        y = oy + n();
        path.arcToPoint(
          Offset(x, y),
          radius: Radius.elliptical(rx, ry),
          rotation: rotation,
          largeArc: large,
          clockwise: sweep,
        );
        cx2 = null;
      case 'Z':
        path.close();
        x = startX;
        y = startY;
        cx2 = null;
      default:
        // Desteklenmeyen komut: yolun kalanı çizilmez.
        return path;
    }
  }
  return path;
}
