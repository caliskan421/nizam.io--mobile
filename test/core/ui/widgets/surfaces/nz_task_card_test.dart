import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_pressable.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_progress_bar.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_avatar_stack.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_status_label.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_task_card.dart';

import '../feedback/feedback_test_support.dart';

NzTaskCard _card({VoidCallback? onTap, bool sub = false}) => NzTaskCard(
  code: 'ALT-5',
  group: 'Altyapı ve tesisat',
  title:
      'Su deposu temel betonunun yapılması ve uzun başlık iki satırda kesilir',
  statusLabel: 'Devam ediyor',
  statusTone: NzTone.progress,
  start: const NzTaskCardDate(caption: 'başlangıç', value: '16.06.2026'),
  end: const NzTaskCardDate(
    caption: 'bitiş',
    value: '15.07.2026',
    overdue: true,
  ),
  priorityCaption: 'öncelik',
  priority: 'Yüksek',
  priorityLevel: 3,
  subtaskProgress: sub ? 2 / 3 : null,
  subtaskText: sub ? '2/3 alt görev' : null,
  assignees: const ['Kadir Özbek'],
  assigneeText: 'Kadir Özbek',
  badge: '98 gün gecikti',
  onTap: onTap,
  semanticLabel: 'ALT-5 Su deposu',
);

void main() {
  setUpFonts();

  testWidgets('içerik: kod, grup, durum, tarihler, öncelik, kişi, rozet', (
    t,
  ) async {
    await t.pumpWidget(testApp(SingleChildScrollView(child: _card(sub: true))));
    for (final s in [
      'ALT-5',
      'Altyapı ve tesisat',
      'Devam ediyor',
      'başlangıç',
      '16.06.2026',
      'bitiş',
      'öncelik',
      'Yüksek',
      'Kadir Özbek',
      '98 gün gecikti',
      '2/3 alt görev',
    ]) {
      expect(find.text(s), findsOneWidget, reason: s);
    }
    expect(find.byType(NzAvatarStack), findsOneWidget);
    expect(find.byType(NzProgressBar), findsOneWidget);
    expect(find.byType(NzPriorityBars), findsOneWidget);
    final title = t.widget<Text>(find.textContaining('Su deposu'));
    expect(title.maxLines, 2);
  });

  testWidgets('geçmiş bitiş danger; döşeme bg-raised (açık/koyu)', (t) async {
    for (final dark in [false, true]) {
      final c = dark ? NizamioColors.dark : NizamioColors.light;
      await t.pumpWidget(
        testApp(SingleChildScrollView(child: _card()), dark: dark),
      );
      await t.pumpAndSettle();
      expect(t.widget<Text>(find.text('15.07.2026')).style!.color, c.danger);
      expect(t.widget<Text>(find.text('16.06.2026')).style!.color, c.text);
      final tile = find.byWidgetPredicate(
        (w) =>
            w is DecoratedBox &&
            (w.decoration as BoxDecoration?)?.color == c.surfaceRaised,
      );
      expect(tile, findsOneWidget);
    }
  });

  testWidgets('dokunuş; basma ölçeği kart (.985); okuyucu etiketi', (t) async {
    final handle = t.ensureSemantics();
    var n = 0;
    await t.pumpWidget(
      testApp(SingleChildScrollView(child: _card(onTap: () => n++))),
    );
    await t.tap(find.text('ALT-5'));
    expect(n, 1);
    expect(
      t.widget<NzPressable>(find.byType(NzPressable)).scale,
      NizamioMotion.pressCard,
    );
    expect(find.bySemanticsLabel('ALT-5 Su deposu'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('öncelik çubukları: level kadar ink', (t) async {
    await t.pumpWidget(testApp(const Center(child: NzPriorityBars(level: 2))));
    final c = NizamioColors.light;
    final colors = t
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((d) => (d.decoration as BoxDecoration).color)
        .toList();
    expect(colors, [c.text, c.text, c.borderStrong]);
  });

  testWidgets('360 / 2.0 taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 1200);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _card(sub: true, onTap: () {}),
          ),
        ),
      ),
    );
    expect(t.takeException(), isNull);
  });
}
