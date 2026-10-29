// Tablet ölçüm sözleşmesi, host (cihazsız) widget testi. Kanonik yüzey 1180×820 (prototip
// artboard, dpr 1); `screen_matrix.dart` büyütülmez. Beklentiler `tablet_harness.dart`'taki
// HTML literal sözleşmesidir (ray 100 · liste 390 + 1 kenar · sağ kalan; TB_DEF varsayılanları;
// merkezi modal 560). Gerçek `NizamioApp` + gerçek bileşim kökü + sahte HTTP; backend yok.
//
// Henüz uygulanmamış özellikler (takvim, yatay Gantt, merkezi modal…) testi KIRMIZI bırakır;
// atlanmaz. Cihaz görüntüleri bu dosyanın işi değildir: `integration_test/tablet_visual_test.dart`.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_composer.dart';

import '../support/tablet_harness.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('kanonik 1180×820: sahneler (koyu)', () {
    for (final scene in tabletScenes) {
      testWidgets(scene.name, (tester) async {
        final s = await TabletSession.launch(
          tester,
          hostSize: tabletReferenceSize,
        );
        if (scene.needsSignIn) await s.signIn();
        await scene.run(s);
        final m = s.measurements(scene.name);
        expect(
          (m['logicalSize']! as Map)['w'],
          tabletReferenceSize.width,
          reason: 'host yüzeyi prototip artboard',
        );
      });
    }
  });

  group('kanonik 1180×820: açık tema', () {
    for (final scene in tabletScenes.where(
      (s) => const {'home', 'tasks', 'task-create', 'drawer'}.contains(s.name),
    )) {
      testWidgets('${scene.name}-light', (tester) async {
        final s = await TabletSession.launch(
          tester,
          hostSize: tabletReferenceSize,
          theme: ThemeMode.light,
        );
        await s.signIn();
        await scene.run(s);
        expect(s.measurements(scene.name)['theme'], 'light');
      });
    }
  });

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
        await s.tapRail(TabletModule.messages);
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
