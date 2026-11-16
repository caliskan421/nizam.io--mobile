// Karar bloğu: uyarı yalnız verildiğinde; İade et / Onayla geri çağrıları.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_decision_block.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('uyarı ve karar düğmeleri', (t) async {
    final hits = <String>[];
    Widget block({String? warning}) => testApp(
      NzDecisionBlock(
        title: 'Karar bekliyor',
        warning: warning,
        returnLabel: 'İade et',
        approveLabel: 'Onayla',
        onReturn: () => hits.add('iade'),
        onApprove: () => hits.add('onay'),
      ),
    );
    await t.pumpWidget(block());
    expect(find.text('Kanıt yok'), findsNothing);
    await t.pumpWidget(block(warning: 'Kanıt yok'));
    expect(find.text('Kanıt yok'), findsOneWidget);
    await t.tap(find.text('İade et'));
    await t.tap(find.text('Onayla'));
    expect(hits, ['iade', 'onay']);
  });
}
