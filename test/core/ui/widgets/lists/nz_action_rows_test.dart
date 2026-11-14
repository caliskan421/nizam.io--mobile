// Kuyruk ve atanmamış satırları: eylem düğmeleri geri çağrıya bağlı; yetkisiz (null) eylem
// atanmamış satırda gizlenir, kuyruk satırında pasif kalır.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_action_rows.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('kuyruk satırı İade / Onayla ve satır dokunuşu', (t) async {
    final hits = <String>[];
    await t.pumpWidget(
      testApp(
        NzQueueRow(
          title: 'Hidrofor',
          dueText: '2 gün geç',
          dueDanger: true,
          returnLabel: 'İade et',
          approveLabel: 'Onayla',
          onTap: () => hits.add('aç'),
          onReturn: () => hits.add('iade'),
          onApprove: () => hits.add('onay'),
        ),
      ),
    );
    await t.tap(find.text('İade et'));
    await t.tap(find.text('Onayla'));
    await t.tap(find.text('Hidrofor'));
    expect(hits, ['iade', 'onay', 'aç']);
  });

  testWidgets('atanmamış satırda yetkisiz eylem gizlenir', (t) async {
    await t.pumpWidget(
      testApp(
        NzUnassignedRow(
          title: 'Pano',
          claimLabel: 'Üstlen',
          assignLabel: 'Ata',
          onClaim: () {},
        ),
      ),
    );
    expect(find.text('Üstlen'), findsOneWidget);
    expect(find.text('Ata'), findsNothing);
    expect(find.byType(NzButton), findsOneWidget);
  });
}
