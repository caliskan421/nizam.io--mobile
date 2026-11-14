import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/nz_glyph.dart';

void main() {
  test('ana sayfa ikonlarının yolları 24 birimlik kutuya düşer', () {
    for (final g in [
      NzGlyphs.done,
      NzGlyphs.inProgress,
      NzGlyphs.review,
      NzGlyphs.notStarted,
      NzGlyphs.late,
      NzGlyphs.dateRequest,
      NzGlyphs.northEast,
      NzGlyphs.history,
      NzGlyphs.meeting,
      NzGlyphs.deleted,
      NzGlyphs.report,
      NzGlyphs.add,
      NzGlyphs.personAdd,
      NzGlyphs.team,
    ]) {
      // Çizilen noktalar (kontrol noktaları değil) kutunun içinde.
      const box = Rect.fromLTRB(-.5, -.5, 24.5, 24.5);
      var points = 0;
      for (final m in glyphPath(g.path).computeMetrics()) {
        for (var d = 0.0; d <= m.length; d += .5) {
          final p = m.getTangentForOffset(d)!.position;
          expect(box.contains(p), isTrue, reason: '${g.path} → $p');
          points++;
        }
      }
      expect(points, greaterThan(0), reason: g.path);
    }
  });

  test('göreli komutlar ve örtük tekrar mutlak eşdeğeriyle aynı', () {
    final rel = glyphPath('M5 12.5l4.5 4.5L19 7').getBounds();
    final abs = glyphPath('M5 12.5L9.5 17L19 7').getBounds();
    expect(rel, abs);
    final implicit = glyphPath('M13 2 4 14h7').getBounds();
    expect(implicit, const Rect.fromLTRB(4, 2, 13, 14));
  });

  test('yay (A/a) çemberi tam çizer', () {
    final b = glyphPath('M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18z').getBounds();
    expect(b.left, closeTo(3, .01));
    expect(b.right, closeTo(21, .01));
    expect(b.top, closeTo(3, .01));
    expect(b.bottom, closeTo(21, .01));
  });
}
