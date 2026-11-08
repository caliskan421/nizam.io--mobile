// NzAlertIcon: yalnız erişilebilirlik davranışı (etiket varsa tek düğüm, yoksa sessiz). Çizim,
// renk ve ölçü test edilmez (CLAUDE.md test kapsamı: görsel sabitler).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/nz_alert_icon.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Center(child: child),
);

void main() {
  for (final tinted in [false, true]) {
    testWidgets(
      'etiket verilince ekran okuyucuya tek etiket (tinted: $tinted)',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _host(
            NzAlertIcon(
              color: const Color(0xFFE53935),
              tinted: tinted,
              semanticLabel: '2 gecikme',
            ),
          ),
        );
        expect(find.bySemanticsLabel('2 gecikme'), findsOneWidget);
        handle.dispose();
      },
    );
  }

  testWidgets('etiketsiz simge ekran okuyucuya etiket vermez', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(const NzAlertIcon(color: Color(0xFFE53935), tinted: true)),
    );
    final node = tester.getSemantics(find.byType(NzAlertIcon));
    expect(node.label, isEmpty);
    handle.dispose();
  });
}
