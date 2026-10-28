import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_icon_button.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_page_header.dart';

import '../feedback/feedback_test_support.dart';

Widget _header({String? subtitle, String title = 'Görevler'}) => NzPageHeader(
  title: title,
  subtitle: subtitle,
  actions: [
    NzIconButton.circle(
      icon: Icons.search,
      semanticLabel: 'Ara',
      onPressed: () {},
    ),
    NzIconButton.circle(
      icon: Icons.tune,
      semanticLabel: 'Filtreler',
      onPressed: () {},
    ),
    NzIconButton.circleAccent(
      icon: Icons.add,
      semanticLabel: 'Yeni görev',
      onPressed: () {},
    ),
  ],
);

void main() {
  setUpFonts();

  testWidgets('başlık m-h1 ve header; düğmeler sağda', (t) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(testApp(_header()));
    final title = t.widget<Text>(find.text('Görevler'));
    expect(title.style!.fontSize, NizamioTypography.h1.size);
    expect(
      t.getSemantics(find.text('Görevler')),
      matchesSemantics(label: 'Görevler', isHeader: true),
    );
    final titleRight = t.getRect(find.text('Görevler')).left;
    final firstButton = t.getRect(find.byType(NzIconButton).first).left;
    expect(firstButton, greaterThan(titleRight));
    handle.dispose();
  });

  testWidgets('alt yazı caption ink-muted (koyu)', (t) async {
    await t.pumpWidget(
      testApp(_header(subtitle: '11 koordinatörlük · 76 görev'), dark: true),
    );
    await t.pumpAndSettle();
    final s = t.widget<Text>(find.text('11 koordinatörlük · 76 görev'));
    expect(s.style!.color, NizamioColors.dark.textMuted);
  });

  testWidgets('360 / 2.0 taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 600);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(
        _header(
          title: 'Koordinatörlükler',
          subtitle: '7 koordinatörlükte gecikme',
        ),
      ),
    );
    expect(t.takeException(), isNull);
  });
}
