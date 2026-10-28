import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_form_rows.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_switch.dart';

import '../feedback/feedback_test_support.dart';

/// Denetimli kap: açık satır dışarıda tutulur (ekran controller'ı gibi).
class _Host extends StatefulWidget {
  const _Host();

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  int? open;
  var proof = false;
  var taps = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: NzFormRows(
      expandedIndex: open,
      onToggle: (i) => setState(() => open = open == i ? null : i),
      rows: [
        const NzFormRow(
          icon: Icons.apartment_outlined,
          label: 'Koordinatörlük',
          value: 'Seçilmedi',
          content: Text('koordinatörlük seçenekleri'),
        ),
        const NzFormRow(
          icon: Icons.person_outline,
          label: 'Atanan',
          value: 'Kadir Özbek',
          valueSet: true,
          content: Text('kişi seçenekleri'),
        ),
        NzFormRow(
          icon: Icons.event_outlined,
          label: 'Bitiş',
          value: '15 Tem',
          onTap: () => setState(() => taps++),
        ),
        NzFormRow.toggle(
          icon: Icons.attach_file,
          label: 'Kanıt dosyası zorunlu',
          value: proof,
          onChanged: (v) => setState(() => proof = v),
        ),
        const NzFormRow.custom(label: 'Öncelik', trailing: Text('Yüksek')),
      ],
    ),
  );
}

void main() {
  setUpFonts();

  testWidgets('dokununca yerinde açılır; aynı anda tek satır açık', (t) async {
    await t.pumpWidget(testApp(const _Host()));
    expect(find.text('koordinatörlük seçenekleri'), findsNothing);
    await t.tap(find.text('Koordinatörlük'));
    await t.pumpAndSettle();
    expect(find.text('koordinatörlük seçenekleri'), findsOneWidget);
    await t.tap(find.text('Atanan'));
    await t.pumpAndSettle();
    expect(find.text('koordinatörlük seçenekleri'), findsNothing);
    expect(find.text('kişi seçenekleri'), findsOneWidget);
    await t.tap(find.text('Atanan'));
    await t.pumpAndSettle();
    expect(find.text('kişi seçenekleri'), findsNothing);
  });

  testWidgets('açılış animasyonlu (yükseklik ara değer alır)', (t) async {
    await t.pumpWidget(testApp(const _Host()));
    final h0 = t.getSize(find.byType(NzFormRows)).height;
    await t.tap(find.text('Koordinatörlük'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 60));
    final mid = t.getSize(find.byType(NzFormRows)).height;
    await t.pumpAndSettle();
    final h1 = t.getSize(find.byType(NzFormRows)).height;
    expect(mid, greaterThan(h0));
    expect(mid, lessThan(h1));
  });

  testWidgets('onTap satırı, anahtar satırı ve değer rengi', (t) async {
    await t.pumpWidget(testApp(const _Host()));
    await t.tap(find.text('Bitiş'));
    await t.tap(find.text('Kanıt dosyası zorunlu'));
    await t.pump();
    final state = t.state<_HostState>(find.byType(_Host));
    expect(state.taps, 1);
    expect(state.proof, isTrue);
    expect(t.widget<NzToggle>(find.byType(NzToggle)).value, isTrue);
    final c = NizamioColors.light;
    expect(t.widget<Text>(find.text('Seçilmedi')).style!.color, c.textMuted);
    expect(t.widget<Text>(find.text('Kadir Özbek')).style!.color, c.text);
  });

  testWidgets('satır >= 52; kart bg-raised (açık/koyu)', (t) async {
    for (final dark in [false, true]) {
      await t.pumpWidget(testApp(const _Host(), dark: dark));
      await t.pumpAndSettle();
      final c = dark ? NizamioColors.dark : NizamioColors.light;
      final box = t.widget<ColoredBox>(
        find
            .descendant(
              of: find.byType(NzFormRows),
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      expect(box.color, c.surfaceRaised);
      final row = t.getRect(
        find.ancestor(of: find.text('Bitiş'), matching: find.byType(InkWell)),
      );
      expect(row.height, greaterThanOrEqualTo(NizamioSize.row));
    }
  });

  testWidgets('anlamsal: açılır satır düğme + expanded durumu', (t) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(testApp(const _Host()));
    final finder = find.bySemanticsLabel('Koordinatörlük, Seçilmedi');
    var flags = t.getSemantics(finder).getSemanticsData().flagsCollection;
    expect(flags.isExpanded.toBoolOrNull(), isFalse);
    await t.tap(find.text('Koordinatörlük'));
    await t.pumpAndSettle();
    flags = t.getSemantics(finder).getSemanticsData().flagsCollection;
    expect(flags.isExpanded.toBoolOrNull(), isTrue);
    handle.dispose();
  });

  testWidgets('360 / 2.0 metinde taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 800);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(testApp(const _Host()));
    await t.tap(find.text('Atanan'));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });
}
