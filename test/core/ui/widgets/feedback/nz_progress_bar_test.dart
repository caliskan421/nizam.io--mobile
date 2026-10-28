import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_progress_bar.dart';

import 'feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('tek değer: 4 px, dolgu oranı kırpılır', (t) async {
    await t.pumpWidget(
      testApp(
        SizedBox(
          width: 200,
          child: NzProgressBar(value: 1.4, color: NizamioColors.light.danger),
        ),
      ),
    );
    expect(t.getSize(find.byType(NzProgressBar)).height, NizamioSize.progress);
    expect(
      t
          .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
          .widthFactor,
      1,
    );
  });

  testWidgets('parçalı: 6 px, boş dilim çizilmez, paylar oranlı', (t) async {
    await t.pumpWidget(
      testApp(
        const SizedBox(
          width: 202,
          child: NzProgressBar.segments(
            segments: [
              NzBarSegment(1, Color(0xFF000001)),
              NzBarSegment(0, Color(0xFF000002)),
              NzBarSegment(3, Color(0xFF000003)),
            ],
          ),
        ),
      ),
    );
    expect(
      t.getSize(find.byType(NzProgressBar)).height,
      NizamioSize.progressLg,
    );
    final boxes = find.descendant(
      of: find.byType(NzProgressBar),
      matching: find.byType(ColoredBox),
    );
    expect(boxes, findsNWidgets(2));
    expect(t.getSize(boxes.first).width, closeTo(50, 1));
    expect(t.getSize(boxes.first).height, NizamioSize.progressLg);
  });

  testWidgets('parçalı, hepsi boş: ray', (t) async {
    await t.pumpWidget(
      testApp(
        const SizedBox(width: 100, child: NzProgressBar.segments(segments: [])),
      ),
    );
    expect(t.getSize(find.byType(ColoredBox).last).width, 100);
  });
}
