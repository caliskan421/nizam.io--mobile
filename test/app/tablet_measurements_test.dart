// Tablet gezinme/durum sözleşmesi, host (cihazsız) widget testi: değişmezler (kaynak gezinme
// ve taslak kuralları) ve ölçüye göre bölme kararı (yön değil genişlik). Gerçek `NizamioApp` +
// gerçek bileşim kökü + sahte HTTP; backend yok. Piksel geometrisi ve tema sahneleri burada
// sınanmaz (test kapsamı: yerleşim ölçüsü test edilmez); sahneler cihaz görüntüsü için
// `integration_test/tablet_visual_test.dart`'ta koşar.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_composer.dart';

import '../support/tablet_harness.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('değişmezler 1180×820 (kaynak gezinme/durum kuralları)', () {
    for (final scene in tabletInvariantScenes) {
      testWidgets(scene.name, (tester) async {
        final s = await TabletSession.launch(
          tester,
          hostSize: tabletReferenceSize,
        );
        await s.signIn();
        await scene.run(s);
      });
    }

    testWidgets(
      'modal açıkken görev başlığı taslağı yeniden boyut/dönüşte korunur',
      (tester) async {
        final s = await TabletSession.launch(
          tester,
          hostSize: tabletReferenceSize,
        );
        await s.signIn();
        await s.tapRail(TabletModule.tasks);
        await tester.tap(find.bySemanticsLabel('Yeni görev').first);
        await s.settle();
        final title = find
            .descendant(
              of: find.byType(Dialog),
              matching: find.byType(EditableText),
            )
            .first;
        await tester.enterText(title, 'Dönüş taslağı');
        await s.settle();
        for (final size in const [
          Size(820, 1180),
          Size(1032, 1376),
          Size(1180, 820),
        ]) {
          tester.view.physicalSize = size;
          await s.settle();
          expect(
            find.byType(Dialog),
            findsOneWidget,
            reason: '$size: modal açık',
          );
          expect(
            tester.widget<EditableText>(title).controller.text,
            'Dönüş taslağı',
            reason: '$size: başlık taslağı korunur',
          );
          final card = s.modalRect!;
          expect(
            card.width,
            lessThanOrEqualTo(TabletContract.modalWidth(size.width) + 0.01),
            reason: '$size: modal pencereye sığar',
          );
          expect(card.height, lessThanOrEqualTo(size.height - 64 + 0.01));
        }
      },
    );

    testWidgets(
      'AYNI sohbette resize/dönüş taslağı korur (sohbet değişimi sıfırlar)',
      (tester) async {
        final s = await TabletSession.launch(
          tester,
          hostSize: tabletReferenceSize,
        );
        await s.signIn();
        await openTabletChat(s);
        expectUnreadDivider(s, present: true);
        final field = find.descendant(
          of: find.byType(NzComposer),
          matching: find.byType(TextField),
        );
        await tester.enterText(field.last, 'Resize taslağı');
        await s.settle();
        await startReplyToK2(s);
        final controller = tester.widget<TextField>(field.last).controller;
        for (final size in const [
          Size(1376, 1032),
          Size(1032, 1376),
          Size(820, 1180),
          Size(1180, 820),
        ]) {
          tester.view.physicalSize = size;
          await s.settle();
          expect(
            tester.widget<TextField>(field.last).controller!.text,
            'Resize taslağı',
            reason: 'aynı sohbet, $size: taslak korunur',
          );
          expectUnreadDivider(s, present: true);
          expectReplyChip(present: true);
        }
        expect(
          tester.widget<TextField>(field.last).controller,
          same(controller),
          reason: 'yeniden boyutta yazma alanı yeniden kurulmaz',
        );
      },
    );
  });

  group('ölçüye göre bölme (yön değil genişlik)', () {
    for (final c in tabletHostSizes) {
      testWidgets(
        '${c.name} ${c.size.width.toInt()}×${c.size.height.toInt()}',
        (tester) async {
          final s = await TabletSession.launch(tester, hostSize: c.size);
          await s.signIn();
          // Ana sayfa kökü tam genişliktir; bölme geometrisi her zaman bölmeli Takvim'de.
          if (c.rail) await s.tapRail(TabletModule.calendar);
          expectLayoutForSize(s, split: c.split, rail: c.rail);
        },
      );
    }

    testWidgets('1180×820 → 820×1180 → 1032×1376: tek uygulama, bölme geçişi', (
      tester,
    ) async {
      final s = await TabletSession.launch(
        tester,
        hostSize: tabletReferenceSize,
      );
      await s.signIn();
      await s.tapRail(TabletModule.calendar);
      expectLayoutForSize(s, split: true, rail: true);
      tester.view.physicalSize = const Size(820, 1180);
      await s.settle();
      expectLayoutForSize(s, split: false, rail: true);
      tester.view.physicalSize = const Size(1032, 1376);
      await s.settle();
      expectLayoutForSize(s, split: true, rail: true);
    });
  });
}
