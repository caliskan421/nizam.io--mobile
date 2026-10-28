import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_kicker.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('etiket başlık, mono kicker, ink-muted; emphasis → ink', (
    t,
  ) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(testApp(const NzKicker('tüm görevler · 76')));
    final style = t.widget<Text>(find.text('tüm görevler · 76')).style!;
    expect(style.color, NizamioColors.light.textMuted);
    expect(style.fontSize, NizamioTypography.kicker.size);
    expect(
      t.getSemantics(find.text('tüm görevler · 76')),
      matchesSemantics(label: 'tüm görevler · 76', isHeader: true),
    );
    await t.pumpWidget(
      testApp(const NzKicker('ekip', emphasis: true), dark: true),
    );
    await t.pumpAndSettle();
    expect(
      t.widget<Text>(find.text('ekip')).style!.color,
      NizamioColors.dark.text,
    );
    handle.dispose();
  });

  testWidgets('sağ açıklama ya da sağ eylem', (t) async {
    await t.pumpWidget(testApp(const NzKicker('ekip', trailing: '20 kişi')));
    expect(find.text('20 kişi'), findsOneWidget);
    var n = 0;
    await t.pumpWidget(
      testApp(
        NzKicker(
          'liste',
          action: TextButton(onPressed: () => n++, child: const Text('Sırala')),
        ),
      ),
    );
    await t.tap(find.text('Sırala'));
    expect(n, 1);
  });

  testWidgets('360 / 2.0 taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 400);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(
        const NzKicker(
          'çok uzun bir bölüm etiketi',
          trailing: 'iki koordinatör, on beş üye, üç yönetici',
        ),
      ),
    );
    expect(t.takeException(), isNull);
  });
}
