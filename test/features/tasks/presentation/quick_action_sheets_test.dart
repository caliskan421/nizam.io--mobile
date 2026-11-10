// Hızlı işlem alt sayfaları (yeni görev, toplantı, davet): dar ekran × 2.0 metin taşma yok.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_page.dart';
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
  await real(
    tester,
    () => h.container.read(taskCatalogControllerProvider.future),
  );
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

  testWidgets('küçük telefonda yeni görev alanları erişilebilir', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);
    await _open(tester);
    await _tap(tester, find.text('görev'));
    expect(find.text(_l.uiTasksFieldCoord), findsOneWidget);
    expect(find.text(_l.uiTasksEvidenceRequired), findsOneWidget);
    await _tap(tester, find.text(_l.uiTasksEvidenceRequired));
    expect(tester.takeException(), isNull);
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
