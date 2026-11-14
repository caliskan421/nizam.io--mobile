// Yük satırı: ad ve özet tek okuyucu düğümünde; dokunuş geri çağrıya gider.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_load_strip.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_progress_bar.dart';

import 'feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('okuyucu etiketi ve dokunuş', (t) async {
    final handle = t.ensureSemantics();
    var taps = 0;
    await t.pumpWidget(
      testApp(
        NzLoadRow(
          name: 'Kadir Özbek',
          caption: '3 açık · 1 geç',
          segments: const [NzBarSegment(2, Colors.transparent)],
          onTap: () => taps++,
        ),
      ),
    );
    expect(
      find.bySemanticsLabel('Kadir Özbek, 3 açık · 1 geç'),
      findsOneWidget,
    );
    await t.tap(find.byType(NzLoadRow));
    expect(taps, 1);
    handle.dispose();
  });
}
