// NzCheckCircle: okuyucuda onay kutusu (etiket, işaret, etkinlik); dokunuş geri çağrıyı çalıştırır,
// salt okunurda çalıştırmaz; dokunma alanı 36 × tap.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_check_circle.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  testWidgets('işaret, etiket, dokunuş ve salt okunur', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(
      testApp(
        Column(
          children: [
            NzCheckCircle(value: true, label: 'Bütçe', onChanged: () => taps++),
            const NzCheckCircle(value: false, label: 'Takvim'),
          ],
        ),
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Bütçe')),
      matchesSemantics(
        label: 'Bütçe',
        hasCheckedState: true,
        isChecked: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Takvim')),
      matchesSemantics(
        label: 'Takvim',
        hasCheckedState: true,
        hasEnabledState: true,
      ),
    );

    await tester.tap(find.bySemanticsLabel('Bütçe'));
    await tester.tap(find.bySemanticsLabel('Takvim'));
    await tester.pumpAndSettle();
    expect(taps, 1);
    final size = tester.getSize(find.byType(NzCheckCircle).first);
    expect((size.width, size.height), (36, NizamioSize.tap));
    handle.dispose();
  });
}
