// MessagesPage: sunucudan gelen sohbet satırları, süzgeç ve arama, kısayol menüsü ("Tümünü
// okundu say" sunucuda uygular), yeni mesaj (aday → birebir sohbet açılır), taşma.
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
import '../chat_backend.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav, ChatBackend)> _open(
  WidgetTester tester, {
  bool dark = false,
}) async {
  final backend = ChatBackend();
  final h = await real(tester, () => pilotHarness(backend, signedIn: true));
  h.read(scopeControllerProvider).selectProgram('prog-1');
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, const MessagesPage(), nav: nav, dark: dark);
  await settle(tester);
  return (h, nav, backend);
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('satırlar; süzgeç: okunmamış 2, kişiler 1; arama', (
    tester,
  ) async {
    await _open(tester);
    expect(find.byType(NzChatRow), findsNWidgets(3));
    expect(find.textContaining('Sen: Teşekkürler'), findsOneWidget);
    await _tap(tester, find.text(_l.uiMessagesFilterUnread));
    expect(find.byType(NzChatRow), findsNWidgets(2));
    await _tap(tester, find.text(_l.uiMessagesFilterPeople));
    expect(find.byType(NzChatRow), findsNWidgets(1));
    await _tap(tester, find.text(_l.uiMessagesFilterAll));
    await _tap(tester, find.byIcon(Icons.search_rounded).first);
    await tester.enterText(find.byType(TextField).first, 'trafo');
    await settle(tester);
    expect(find.byType(NzChatRow), findsNWidgets(1));
  });

  testWidgets('aşağı çekince sohbet listesi sunucudan yeniden okunur', (
    tester,
  ) async {
    final (_, _, backend) = await _open(tester);
    final before = backend.inboxReads;
    await tester.fling(
      find.byType(NzChatRow).first,
      const Offset(0, 400),
      1000,
    );
    await settle(tester);
    expect(backend.inboxReads, greaterThan(before));
    expect(find.byType(NzChatRow), findsNWidgets(3));
  });

  testWidgets('satır sohbeti açar', (tester) async {
    final (_, nav, _) = await _open(tester);
    await _tap(tester, find.text('Kadir Özbek'));
    expect(nav.calls, ['chat:kadir']);
  });

  testWidgets('yeni mesaj: aday seçimi birebir sohbeti açar', (tester) async {
    final (h, nav, _) = await _open(tester);
    await _tap(tester, find.byIcon(Icons.edit_outlined).first);
    expect(find.text(_l.uiMessagesNewGroup), findsOneWidget);
    expect(find.text(_l.uiMessagesWhyCannotWrite), findsOneWidget);
    await _tap(tester, find.text('Reha Koçak'));
    expect(nav.calls, ['chat:d-acc-rk']);
    expect(
      h.read(messagesNavBadgeProvider),
      2,
      reason: 'yeni sohbet listeye eklendi, okunmamış değişmedi',
    );
  });

  testWidgets('kısayol: tümünü okundu say sunucuda uygulanır', (tester) async {
    final (h, _, backend) = await _open(tester);
    h.read(shellReselectEventsProvider.notifier).fire(MessagesPage.shellTab);
    await settle(tester);
    await tester.tap(find.text(_l.uiMessagesMarkAllRead));
    await settle(tester);
    expect(backend.chats.readAll, 1);
    expect(h.read(messagesNavCaptionProvider), '0 ${_l.uiMessagesUnreadLc}');
  });

  for (final (width, scale) in [(360.0, 1.0), (360.0, 2.0)]) {
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
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
