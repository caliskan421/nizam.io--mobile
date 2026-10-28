// ArchiveFolderPage: başlık bilgisi, sekmeler, görev klasörü → dosya süzgeci, etiket süzgeci,
// önizleme (önceki/sonraki, indir, sil), koordinatörlük ve ZIP, kısayol menüsü, taşma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_folder.dart';
import 'package:nizamio/features/archive/archive.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  String code = 'ALT',
  bool dark = false,
}) async {
  final h = await real(tester, () => pilotHarness(PilotBackend()));
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    ArchiveFolderPage(code: code),
    nav: nav,
    dark: dark,
  );
  await settle(tester);
  return (h, nav);
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('başlık bilgisi ve sekmeler; koordinatörlük, ZIP', (
    tester,
  ) async {
    final (_, nav) = await _open(tester);
    expect(find.text('${_l.uiArchiveTitle} / ALT'), findsOneWidget);
    expect(find.text('Altyapı ve tesisat'), findsOneWidget);
    expect(
      find.text('Deniz Aydemir, Kaan Erol, Kerem Özdal · 15 dosya · 9,8 MB'),
      findsOneWidget,
    );
    expect(find.text(_l.uiArchiveTabTasks), findsOneWidget);
    expect(find.byType(NzFolder), findsWidgets);
    await _tap(tester, find.text(_l.uiArchiveCoordinatorship));
    expect(nav.calls, ['coord:ALT']);
    await _tap(tester, find.byIcon(Icons.download_rounded));
    expect(
      find.text('Altyapı ve tesisat ${_l.uiArchiveZipToast}'),
      findsOneWidget,
    );
  });

  testWidgets('görev klasörü dosyaları süzer; etiket; önizleme ve silme', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, find.byType(NzFolder).first);
    expect(find.byTooltip(_l.uiArchiveRemoveTaskFilter), findsOneWidget);
    await _tap(tester, find.byTooltip(_l.uiArchiveRemoveTaskFilter));
    await _tap(tester, find.text(_l.uiArchiveTagDataShort));
    expect(find.text(_l.uiArchiveEmptyFiles), findsNothing);
    await _tap(tester, find.text(_l.uiArchiveFilterAll));
    await _tap(tester, find.textContaining('WhatsApp Image').first);
    expect(find.text(_l.uiArchivePreview), findsOneWidget);
    expect(find.text('1 / 15'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveNext));
    expect(find.text('2 / 15'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(_l.uiArchivePrev));
    await _tap(tester, find.bySemanticsLabel(_l.uiArchivePrev));
    expect(find.text('15 / 15'), findsOneWidget);
    await _tap(tester, find.byIcon(Icons.delete_outline_rounded));
    expect(find.text(_l.uiArchiveDeleted), findsOneWidget);
    expect(find.text(_l.uiArchivePreview), findsNothing);
    expect(find.textContaining('· 14 dosya ·'), findsOneWidget);
  });

  testWidgets('kısayol menüsü: diğer klasör ve tüm arşiv', (tester) async {
    final (h, nav) = await _open(tester);
    h
        .read(shellReselectEventsProvider.notifier)
        .fire(ArchiveFolderPage.shellTab);
    await settle(tester);
    await tester.tap(find.text('Operasyon'));
    await settle(tester);
    h
        .read(shellReselectEventsProvider.notifier)
        .fire(ArchiveFolderPage.shellTab);
    await settle(tester);
    await _tap(tester, find.text(_l.uiArchiveAllArchive));
    expect(nav.calls, ['folder:OPE', 'archive']);
  });

  for (final (width, scale) in [(360.0, 1.0), (360.0, 2.0), (390.0, 2.0)]) {
    for (final dark in [false, true]) {
      testWidgets(
        'taşma yok: ${width.toInt()} geniş, ${scale}x, ${dark ? 'koyu' : 'açık'}',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 844);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await _open(tester, code: 'OPE', dark: dark);
          await _tap(tester, find.text(_l.uiArchiveTabFiles));
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 6; i++) {
            await tester.drag(scrollable, const Offset(0, -300));
            await tester.pump();
          }
          await _tap(tester, find.textContaining('_Rapor_').first);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
