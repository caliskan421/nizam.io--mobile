import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_switch.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      NzSwitch(
        label: 'Açık ${size.name}',
        value: true,
        onChanged: (_) {},
        size: size,
      ),
      NzSwitch(
        label: 'Kapalı ${size.name} ve oldukça uzun bir etiket metni',
        description: 'Açıklama',
        value: false,
        onChanged: (_) {},
        size: size,
      ),
    ],
    NzSwitch(
      label: 'Simgeli',
      value: true,
      onChanged: (_) {},
      leading: const Icon(Icons.notifications_none),
    ),
    const NzSwitch(label: 'Devre dışı', value: true, onChanged: null),
  ],
);

void main() {
  setUpFonts();

  testWidgets('dokunuş değeri tersler (denetimli) ve onChanged çağrılır', (
    tester,
  ) async {
    final values = <bool>[];
    var value = false;
    await tester.pumpWidget(
      testApp(
        StatefulBuilder(
          builder: (context, setState) => NzSwitch(
            label: 'Bildirim',
            value: value,
            onChanged: (v) {
              values.add(v);
              setState(() => value = v);
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Bildirim'));
    await tester.pump();
    expect(values, [true]);
    expect(tester.widget<NzToggle>(find.byType(NzToggle)).value, isTrue);
    await tester.tap(find.byType(NzToggle));
    await tester.pump();
    expect(values, [true, false]);
  });

  testWidgets('devre dışı: dokunuş çalışmaz', (tester) async {
    await tester.pumpWidget(
      testApp(const NzSwitch(label: 'K', value: false, onChanged: null)),
    );
    await tester.tap(find.text('K'));
    await tester.pump();
    expect(tester.widget<NzToggle>(find.byType(NzToggle)).value, isFalse);
  });

  testWidgets('satır >= 48; açıklama ve leading çizilir', (tester) async {
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(
          NzSwitch(
            label: 'K',
            description: 'Açıklama',
            value: false,
            onChanged: (_) {},
            leading: const Icon(Icons.notifications_none),
            size: size,
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(NzSwitch)).height,
        greaterThanOrEqualTo(NizamioSpacing.space12),
        reason: size.name,
      );
      expect(find.text('Açıklama'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none), findsOneWidget);
    }
  });

  testWidgets('anlamsal: etiket ve durum tek düğümde', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(NzSwitch(label: 'Bildirim', value: true, onChanged: (_) {})),
    );
    final node = tester.getSemantics(find.byType(NzSwitch));
    expect(node.label, contains('Bildirim'));
    expect(node.getSemanticsData().flagsCollection.isToggled, Tristate.isTrue);
    handle.dispose();
  });

  testWidgets(
    'NzToggle: ray açık accent / kapalı overlay, baş switchKnob; >= 48',
    (tester) async {
      for (final dark in [false, true]) {
        final c = dark ? NizamioColors.dark : NizamioColors.light;
        for (final on in [true, false]) {
          await tester.pumpWidget(
            testApp(
              Center(
                child: NzToggle(value: on, onChanged: (_) {}),
              ),
              dark: dark,
            ),
          );
          await tester.pumpAndSettle();
          final track = tester.widget<AnimatedContainer>(
            find.descendant(
              of: find.byType(NzToggle),
              matching: find.byType(AnimatedContainer),
            ),
          );
          expect(
            (track.decoration! as BoxDecoration).color,
            on ? c.primary : c.surfaceOverlay,
          );
          final knob = tester.widget<DecoratedBox>(
            find
                .descendant(
                  of: find.byType(NzToggle),
                  matching: find.byType(DecoratedBox),
                )
                .last,
          );
          expect((knob.decoration as BoxDecoration).color, c.switchKnob);
          final size = tester.getSize(find.byType(NzToggle));
          expect(size.width, greaterThanOrEqualTo(NizamioSpacing.space12));
          expect(size.height, greaterThanOrEqualTo(NizamioSpacing.space12));
        }
      }
    },
  );

  testWidgets('NzToggle: etiketliyse anahtar düğümü, değilse gizli', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var v = false;
    await tester.pumpWidget(
      testApp(
        StatefulBuilder(
          builder: (context, setState) => NzToggle(
            value: v,
            semanticLabel: 'Kanıt',
            onChanged: (x) => setState(() => v = x),
          ),
        ),
      ),
    );
    final node = tester.getSemantics(find.byType(NzToggle));
    expect(node.label, 'Kanıt');
    await tester.tap(find.byType(NzToggle));
    await tester.pumpAndSettle();
    expect(v, isTrue);
    await tester.pumpWidget(testApp(NzToggle(value: false, onChanged: (_) {})));
    expect(find.bySemanticsLabel('Kanıt'), findsNothing);
    handle.dispose();
  });

  testWidgets('piksel: tabaka 1024 geniş, açık anahtar dolgusu (primary)', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.primary,
      NizamioColors.dark.primary,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_switch.png'),
      );
    },
  );
}
