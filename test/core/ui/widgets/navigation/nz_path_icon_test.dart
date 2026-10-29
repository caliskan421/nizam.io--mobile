import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_path_icon.dart';

import '../feedback/feedback_test_support.dart';

/// Çizginin gerçek sınırları (kontrol noktaları değil): yol üstünde örneklenen noktalar.
Rect _drawn(Path path) {
  Rect? r;
  for (final m in path.computeMetrics()) {
    for (var d = 0.0; d <= m.length; d += 0.05) {
      final p = m.getTangentForOffset(d)!.position;
      final dot = Rect.fromPoints(p, p);
      r = r == null ? dot : r.expandToInclude(dot);
    }
  }
  return r!;
}

void main() {
  setUpFonts();

  test('kaynak ray yolları 24×24 viewBox içinde çizilir', () {
    for (final d in [
      NzIconPaths.home,
      NzIconPaths.tasks,
      NzIconPaths.calendar,
      NzIconPaths.coordinatorships,
      NzIconPaths.archive,
      NzIconPaths.messages,
      NzIconPaths.bell,
      NzIconPaths.menu,
      NzIconPaths.assistant,
      NzIconPaths.pickRecord,
    ]) {
      final b = _drawn(NzPathIcon.pathOf(d));
      expect(b.left, greaterThanOrEqualTo(1.9), reason: d);
      expect(b.top, greaterThanOrEqualTo(1.9), reason: d);
      expect(b.right, lessThanOrEqualTo(22.1), reason: d);
      expect(b.bottom, lessThanOrEqualTo(22.1), reason: d);
    }
  });

  test('takvim çerçevesi kaynak koordinatlarında (M4 6h16v14H4z)', () {
    final b = _drawn(NzPathIcon.pathOf(NzIconPaths.calendar));
    expect(b, const Rect.fromLTRB(4, 3, 20, 20));
  });

  test('yol bir kez ayrıştırılır (önbellek)', () {
    expect(
      identical(
        NzPathIcon.pathOf(NzIconPaths.menu),
        NzPathIcon.pathOf(NzIconPaths.menu),
      ),
      isTrue,
    );
  });

  testWidgets('verilen boyutta çizer; renk IconTheme ya da açık renk', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        const Center(
          child: IconTheme(
            data: IconThemeData(color: Color(0xFF00FF00)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                NzPathIcon(NzIconPaths.home, key: ValueKey('a')),
                NzPathIcon(
                  NzIconPaths.bell,
                  key: ValueKey('b'),
                  size: 24,
                  color: Color(0xFFFF0000),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byKey(const ValueKey('a'))), const Size(20, 20));
    expect(tester.getSize(find.byKey(const ValueKey('b'))), const Size(24, 24));
    expect(tester.takeException(), isNull);
  });
}
