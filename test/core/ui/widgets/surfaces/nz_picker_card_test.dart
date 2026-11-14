import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_picker_card.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets(
    'etiket + başlık okunur, dokunuş çağrılır; dar genişlikte taşmaz',
    (t) async {
      final handle = t.ensureSemantics();
      var taps = 0;
      await t.pumpWidget(
        testApp(
          SizedBox(
            width: 120,
            child: NzPickerCard(
              label: 'koordinatörlük',
              title: 'Altyapı ve tesisat ve çok uzun bir ad',
              leading: const NzMonoTag('ALT'),
              onTap: () => taps++,
            ),
          ),
        ),
      );
      expect(t.takeException(), isNull);
      await t.tap(find.byType(NzPickerCard));
      expect(taps, 1);
      expect(
        find.bySemanticsLabel(
          'koordinatörlük, Altyapı ve tesisat ve çok uzun bir ad',
        ),
        findsOneWidget,
      );
      handle.dispose();
    },
  );
}
