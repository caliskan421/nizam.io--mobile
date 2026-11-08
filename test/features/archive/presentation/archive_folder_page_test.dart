// ArchiveFolderPage: başlık bilgisi, sekmeler, görev klasörü → dosya süzgeci, etiket süzgeci,
// önizleme (önceki/sonraki, indir, sil), koordinatörlük ve ZIP, kısayol menüsü, taşma.
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
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
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram('prog-1');
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

  testWidgets('kısayol menüsü: diğer klasör ve tüm arşiv', (tester) async {
    final (h, nav) = await _open(tester);
    h
        .read(shellReselectEventsProvider.notifier)
        .fire(ArchiveFolderPage.shellTab);
    await settle(tester);
    expect(find.text('78'), findsOneWidget, reason: 'satır sayacı');
    await tester.tap(find.text('Operasyon'));
    await settle(tester);
    h
        .read(shellReselectEventsProvider.notifier)
        .fire(ArchiveFolderPage.shellTab);
    await settle(tester);
    await _tap(tester, find.text(_l.uiArchiveAllArchive));
    expect(nav.calls, ['folder:OPE', 'archive']);
  });
}
