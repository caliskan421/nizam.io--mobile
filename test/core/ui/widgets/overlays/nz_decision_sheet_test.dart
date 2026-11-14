// Karar kaplaması: zorunlu sebepte ana düğme sebep yazılana dek pasif; sonuç kırpılmış not ve
// anahtar durumuyla döner; vazgeçince null.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/overlays/nz_decision_sheet.dart';

import '../feedback/feedback_test_support.dart';

class _Host extends StatefulWidget {
  const _Host({this.required = false});
  final bool required;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  NzDecisionResult? result;
  bool closed = false;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton(
        onPressed: () async {
          final r = await NzDecisionSheet.show(
            context,
            title: 'İade et',
            noteLabel: 'Sebep',
            cancelLabel: 'Vazgeç',
            okLabel: 'Gönder',
            noteRequired: widget.required,
            toggleLabel: widget.required ? null : 'Bugüne çek',
            toggleInitial: !widget.required,
          );
          setState(() {
            result = r;
            closed = true;
          });
        },
        child: const Text('aç'),
      ),
      Text(closed ? 'sonuç: ${result?.note}|${result?.toggled}' : 'açık'),
    ],
  );
}

NzButton _ok(WidgetTester t) => t.widget<NzButton>(
  find.ancestor(of: find.text('Gönder'), matching: find.byType(NzButton)),
);

void main() {
  setUpFonts();

  testWidgets('zorunlu sebep yazılana dek gönderilemez; not kırpılır', (
    t,
  ) async {
    await t.pumpWidget(testApp(const _Host(required: true)));
    await t.tap(find.text('aç'));
    await t.pumpAndSettle();
    expect(_ok(t).onPressed, isNull);
    await t.enterText(find.byType(TextField), '   ');
    await t.pump();
    expect(_ok(t).onPressed, isNull);
    await t.enterText(find.byType(TextField), '  eksik kanıt ');
    await t.pump();
    expect(_ok(t).onPressed, isNotNull);
    await t.tap(find.text('Gönder'));
    await t.pumpAndSettle();
    expect(find.text('sonuç: eksik kanıt|false'), findsOneWidget);
  });

  testWidgets('isteğe bağlı notta boş gönderilir; vazgeç null döner', (
    t,
  ) async {
    await t.pumpWidget(testApp(const _Host()));
    await t.tap(find.text('aç'));
    await t.pumpAndSettle();
    await t.tap(find.text('Gönder'));
    await t.pumpAndSettle();
    expect(find.text('sonuç: |true'), findsOneWidget);
    await t.tap(find.text('aç'));
    await t.pumpAndSettle();
    await t.tap(find.text('Vazgeç'));
    await t.pumpAndSettle();
    expect(find.text('sonuç: null|null'), findsOneWidget);
  });
}
