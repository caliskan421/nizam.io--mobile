// Karar kaplaması: zorunlu sebepte ana düğme sebep yazılana dek pasif; sonuç kırpılmış not ve
// anahtar durumuyla döner; vazgeçince null.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/overlays/nz_decision_sheet.dart';

import '../feedback/feedback_test_support.dart';

class _Host extends StatefulWidget {
  const _Host({this.required = false, this.detailed = false});
  final bool required;
  final bool detailed;

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
            facts: widget.detailed
                ? const [
                    NzDecisionFact(
                      'Sorumlu',
                      'Bahar Kılıç, Muhammet Ali Çalışkan',
                    ),
                    NzDecisionFact('Kanıt', '1 dosya'),
                  ]
                : const [],
            comparison: widget.detailed
                ? (_) => const [
                    NzDecisionFact('Önceki bitiş', '15.06.2026'),
                    NzDecisionFact('İşlem sonrası bitiş', '15.06.2026'),
                    NzDecisionFact('Tamamlanma tarihi', '16.11.2026'),
                    NzDecisionFact('Sonuç', '154 gün geç', danger: true),
                  ]
                : null,
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

  for (final width in [320.0, 1024.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('karar içeriği taşmaz: genişlik $width, metin $scale', (
        t,
      ) async {
        t.view.devicePixelRatio = 1;
        t.view.physicalSize = Size(width, 900);
        addTearDown(t.view.resetDevicePixelRatio);
        addTearDown(t.view.resetPhysicalSize);
        await t.pumpWidget(
          MaterialApp(
            theme: theme(true),
            locale: const Locale('tr'),
            supportedLocales: const [Locale('tr')],
            localizationsDelegates: testLocalizationDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const Scaffold(body: _Host(detailed: true)),
          ),
        );
        await t.tap(find.text('aç'));
        await t.pumpAndSettle();
        expect(t.takeException(), isNull);
        await t.ensureVisible(find.byType(TextField));
        await t.enterText(find.byType(TextField), 'Karar notu');
        await t.pumpAndSettle();
        expect(t.takeException(), isNull);
        await t.tap(find.text('Gönder'));
        await t.pumpAndSettle();
        expect(find.text('sonuç: Karar notu|true'), findsOneWidget);
      });
    }
  }
}
