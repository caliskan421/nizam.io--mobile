// Hızlı işlem alt sayfaları: yeni görev (doğrulama sırası, satırlar, takvim, kataloğa ekleme,
// sonuç bildirimi), toplantı (takvim, saat çarkı, davetli, gündem), davet (e-posta, rol);
// tarih satırı açılınca sayfa kendiliğinden büyür; dar ekran × 2.0 metin taşma yok.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_page.dart';
import 'package:nizamio/core/ui/widgets/feedback/feedback.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/core/ui/widgets/overlays/overlays.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/harness.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

class _Host extends StatelessWidget {
  const _Host();

  @override
  Widget build(BuildContext context) => NzPage(
    title: 'host',
    body: Column(
      children: [
        TextButton(
          onPressed: () => showNewTaskSheet(context, resetTarget: true),
          child: const Text('görev'),
        ),
        TextButton(
          onPressed: () => showNewTaskSheet(context),
          child: const Text('ana görev'),
        ),
        TextButton(
          onPressed: () => showNewTaskSheet(
            context,
            coordinatorship: 'ALT',
            title: '  ${'Pompa basıncını ölç ' * 10}',
          ),
          child: const Text('mesajdan görev'),
        ),
        TextButton(
          onPressed: () => showMeetingSheet(context),
          child: const Text('toplantı'),
        ),
        TextButton(
          onPressed: () => showInviteSheet(context, coordinatorship: 'ALT'),
          child: const Text('davet'),
        ),
      ],
    ),
  );
}

Future<Harness> _open(WidgetTester tester, {bool dark = false}) async {
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram('prog-1');
  await pumpScreen(tester, h, const _Host(), dark: dark);
  await settle(tester);
  await h.container.read(taskCatalogControllerProvider.future);
  return h;
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('yeni görev: doğrulama, satırlar, oluşturma', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final h = await _open(tester);
    await _tap(tester, find.text('görev'));
    expect(find.text(_l.uiTasksNtDesc), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksCreate));
    expect(find.text(_l.uiTasksErrTitle), findsOneWidget);
    await tester.enterText(find.byType(EditableText).first, 'Pompa testi');
    await _tap(tester, find.text(_l.uiTasksCreate));
    expect(find.text(_l.uiTasksErrCoord), findsOneWidget);
    // Koordinatörlük seçilmeden Atanan → koordinatörlük satırı açılır.
    await _tap(tester, find.text(_l.uiTasksAssignee));
    await _tap(tester, find.text('Altyapı ve tesisat'));
    await _tap(tester, find.text('Kadir Özbek'));
    expect(find.text(_l.uiTasksRoleMemberLc), findsOneWidget);

    final sheet = find.byType(NzBottomSheetContent);
    final before = tester.getSize(sheet).height;
    await _tap(tester, find.text(_l.uiTasksRowDate));
    expect(find.text('Ekim 2026'), findsOneWidget);
    expect(tester.getSize(sheet).height, greaterThan(before));
    await _tap(tester, find.text('23'));
    await _tap(tester, find.text('30').last);
    expect(
      find.textContaining('23 Eki → 30 Eki · 1 ${_l.uiTasksWeeksLc}'),
      findsOneWidget,
    );
    await _tap(tester, find.text(_l.uiTasksPrioHigh));
    await _tap(tester, find.text(_l.uiTasksCreate));
    expect(find.text(_l.uiTasksNtDesc), findsNothing);
    final t = h.read(taskCatalogControllerProvider).value!.tasks.first;
    expect(t.code, startsWith('ALT-'));
    expect(
      find.text(
        '${t.code} ${_l.uiTasksTCreatedTail} · 1 ${_l.uiTasksTNotifiedTail}',
      ),
      findsOneWidget,
    );
    // Sonuç tostu onay işaretli (prototip `hs.toast`).
    expect(
      tester.widget<NzToastBubble>(find.byType(NzToastBubble)).tone,
      NzToastTone.success,
    );
    expect(t.title, 'Pompa testi');
    expect(t.priority, TaskPriority.high);
    expect(t.start, DateTime(2026, 10, 23));
  });

  testWidgets(
    'yeni görev: ana sayfadan taslak korunur, listeden hedef sıfırlanır',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await _open(tester);
      // Ana sayfa hızlı işlemi: ilk koordinatörlük seçili açılır (prototip `tk.coord`).
      await _tap(tester, find.text('ana görev'));
      expect(find.text('Altyapı ve tesisat'), findsOneWidget);
      await _tap(tester, find.text(_l.uiTasksAssignee));
      await _tap(tester, find.text('Abdullah Ateş'));
      await tester.tapAt(const Offset(20, 20));
      await settle(tester);
      await _tap(tester, find.text('ana görev'));
      expect(find.text('Abdullah Ateş'), findsOneWidget);
      await tester.tapAt(const Offset(20, 20));
      await settle(tester);
      // Görev listesinden: koordinatörlük seçilmemiş, atanan yok.
      await _tap(tester, find.text('görev'));
      expect(find.text(_l.uiTasksPick), findsOneWidget);
      expect(find.text(_l.uiTasksCoordFirst), findsOneWidget);
    },
  );

  testWidgets('yeni görev: başlık önceden doldurulur (ilk 120 karakter)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final h = await _open(tester);
    await _tap(tester, find.text('mesajdan görev'));
    final title = h.read(newTaskFormControllerProvider).title;
    expect(title.length, 120);
    expect(title, startsWith('Pompa basıncını ölç'));
    expect(find.text(title), findsOneWidget);
  });

  testWidgets('toplantı: başlık, davetli, saat çarkı, gündem', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _open(tester);
    await _tap(tester, find.text('toplantı'));
    expect(find.text(_l.uiTasksMtTitle), findsOneWidget);
    expect(find.text('2 ${_l.uiTasksItemsLc}'), findsOneWidget);
    await tester.enterText(find.byType(EditableText).first, 'Saha toplantısı');
    await _tap(tester, find.text(_l.uiTasksCreate));
    expect(find.text(_l.uiTasksErrMtCoords), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksRowTime));
    expect(find.byType(NzTimeWheel), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksRowInvitees));
    await _tap(tester, find.text('Fuar'));
    await _tap(tester, find.text(_l.uiTasksRowAgenda));
    expect(
      find.text('Güvenlik ve tahliye planının fuar alanına uyarlanması'),
      findsOneWidget,
    );
    await _tap(tester, find.text(_l.uiTasksCreate));
    expect(
      find.text(
        '${_l.uiTasksTMeeting} · 22 Eki 10:00 · 1 ${_l.uiTasksTCoordsInvited}',
      ),
      findsOneWidget,
    );
  });

  testWidgets('davet: e-posta doğrulaması, rol ve gönderim', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _open(tester);
    await _tap(tester, find.text('davet'));
    expect(find.text(_l.uiTasksIvTitle), findsOneWidget);
    expect(find.text('Altyapı ve tesisat'), findsOneWidget);
    await tester.enterText(find.byType(EditableText).at(0), 'Ayşe Deneme');
    await tester.enterText(find.byType(EditableText).at(1), 'ayse');
    await _tap(tester, find.text(_l.uiTasksIvSend));
    expect(find.text(_l.uiTasksErrEmail), findsOneWidget);
    await tester.enterText(
      find.byType(EditableText).at(1),
      'ayse.deneme@ornek.test',
    );
    await _tap(tester, find.text(_l.uiTasksRoleAdmin));
    expect(find.text(_l.uiTasksRdAdmin), findsOneWidget);
    expect(find.text(_l.uiTasksViewAll), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksIvSend));
    expect(
      find.text('${_l.uiTasksTInvited} ayse.deneme@ornek.test'),
      findsOneWidget,
    );
  });

  for (final (width, scale) in [(360.0, 2.0), (390.0, 1.0)]) {
    for (final dark in [false, true]) {
      testWidgets(
        'taşma yok: ${width.toInt()} geniş, ${scale}x, ${dark ? 'koyu' : 'açık'}',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 844);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await _open(tester, dark: dark);
          await _tap(tester, find.text('görev'));
          await _tap(tester, find.text(_l.uiTasksRowDate));
          await _tap(tester, find.text(_l.uiTasksFieldCoord));
          await _tap(tester, find.byTooltip(_l.uiCommonClose).last);
          await _tap(tester, find.text('toplantı'));
          await _tap(tester, find.text(_l.uiTasksRowTime));
          await _tap(tester, find.text(_l.uiTasksRowInvitees));
          await _tap(tester, find.text(_l.uiTasksModePeople));
          await _tap(tester, find.byTooltip(_l.uiCommonClose).last);
          await _tap(tester, find.text('davet'));
          await _tap(tester, find.text(_l.uiTasksFieldCoord));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
