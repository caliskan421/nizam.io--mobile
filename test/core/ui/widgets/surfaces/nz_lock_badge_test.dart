// Kilit rozeti okuyucuya etiketiyle okunur.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_lock_badge.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('etiket okuyucuda', (t) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(testApp(const NzLockBadge(label: 'Kilitli')));
    expect(find.bySemanticsLabel('Kilitli'), findsOneWidget);
    handle.dispose();
  });
}
