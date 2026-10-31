// MessagesPage: sohbet satırları, süzgeç hapları (Okunmamış 5), arama, sohbet açma, yeni
// mesaj alt sayfası, kısayol menüsü ("Tümünü okundu say" uygular), taşma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_chat_row.dart';
import 'package:nizamio/features/messages/messages.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  bool dark = false,
  bool tall = false,
}) async {
  if (tall) {
    // Satırlar tembel kurulur: 8 sohbetin hepsi görünsün.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 1400);
    addTearDown(tester.view.reset);
  }
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram('prog-2');
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, const MessagesPage(), nav: nav, dark: dark);
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

  testWidgets('satırlar: son mesaj, saat, okunmamış; sohbet açılır', (
    tester,
  ) async {
    final (_, nav) = await _open(tester, tall: true);
    expect(find.text(_l.uiMessagesTitle), findsOneWidget);
    expect(find.byType(NzChatRow), findsNWidgets(8));
    expect(find.text('Genel'), findsOneWidget);
    expect(
      find.text(
        'Sen: Kapanış yemeği için gün seçelim, 25 Ekim akşamına kadar oy verin.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Reha: @Muhammet Ali trafo onayı bugün bekleniyor, son durumu #ELE-4 kartına yazdım.',
      ),
      findsOneWidget,
    );
    // Kaynak başlangıcı: koord 1 okunmamış + anma.
    expect(find.text('@'), findsOneWidget);
    await _tap(tester, find.text('Koordinatörler'));
    expect(nav.calls, ['chat:koord']);
  });

  testWidgets('süzgeç: okunmamış 5, kişiler 3; arama', (tester) async {
    await _open(tester);
    await _tap(tester, find.text(_l.uiMessagesFilterUnread));
    expect(find.byType(NzChatRow), findsNWidgets(5));
    await _tap(tester, find.text(_l.uiMessagesFilterPeople));
    expect(find.byType(NzChatRow), findsNWidgets(3));
    await _tap(tester, find.text(_l.uiMessagesFilterAll));
    await _tap(tester, find.byIcon(Icons.search_rounded).first);
    await tester.enterText(find.byType(TextField).first, 'trafo');
    await settle(tester);
    expect(find.byType(NzChatRow), findsNWidgets(2));
    await tester.enterText(find.byType(TextField).first, 'hiçbiri');
    await settle(tester);
    expect(find.text(_l.uiMessagesEmpty), findsOneWidget);
  });

  testWidgets('yeni mesaj: prototip yer tutucu bildirimi', (tester) async {
    final (_, nav) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.edit_outlined).first);
    expect(find.text(_l.uiMessagesNewChatSoon), findsOneWidget);
    expect(nav.calls, isEmpty);
  });

  testWidgets('geri dönüşte süzgeç ve arama korunur', (tester) async {
    final (h, _) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.search_rounded).first);
    await tester.enterText(find.byType(TextField).first, 'trafo');
    await settle(tester);
    await pumpScreen(tester, h, const SizedBox.shrink());
    await settle(tester);
    await pumpScreen(tester, h, const MessagesPage());
    await settle(tester);
    expect(find.text('trafo'), findsOneWidget);
    expect(find.byType(NzChatRow), findsNWidgets(2));
  });

  testWidgets('kısayol: okunmamışlar süzgeci; tümünü okundu say', (
    tester,
  ) async {
    final (h, _) = await _open(tester, tall: true);
    h.read(shellReselectEventsProvider.notifier).fire(MessagesPage.shellTab);
    await settle(tester);
    await tester.tap(find.text(_l.uiMessagesUnreadOnly));
    await settle(tester);
    expect(find.byType(NzChatRow), findsNWidgets(5));
    h.read(shellReselectEventsProvider.notifier).fire(MessagesPage.shellTab);
    await settle(tester);
    await tester.tap(find.text(_l.uiMessagesMarkAllRead));
    await settle(tester);
    expect(find.byType(NzChatRow), findsNWidgets(8));
    expect(find.text('@'), findsNothing);
    expect(h.read(messagesNavCaptionProvider), '0 ${_l.uiMessagesUnreadLc}');
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
          await _open(tester, dark: dark);
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 8; i++) {
            await tester.drag(scrollable, const Offset(0, -300));
            await tester.pump();
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
