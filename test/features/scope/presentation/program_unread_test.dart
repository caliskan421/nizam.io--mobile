import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/scope/presentation/scope_page.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

ResponseBody _overview() => jsonResponse(200, {
  'items': [
    {
      'program_id': 'prog-1',
      'program_name': 'Program Bir',
      'unread_chats': 0,
      'mentioned': true,
    },
    {
      'program_id': 'prog-2',
      'program_name': 'Program İki',
      'unread_chats': 4,
      'mentioned': false,
    },
  ],
});

Future<Harness> _open(WidgetTester tester, FakeHandler overview) async {
  final backend = PilotBackend();
  final h = await real(tester, () => pilotHarness(backend, signedIn: true));
  h.backend.handler = (r) =>
      r.path == '/v1/me/chat-unread' ? overview(r) : backend.handle(r);
  await pumpScreen(tester, h, const ScopePage());
  await settle(tester);
  return h;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets(
    'S1: tüm programlar okunmamış ve bahsetme bilgisini ayrı gösterir',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final h = await _open(tester, (_) => _overview());
      expect(h.read(scopeStateProvider).hasProgram, isFalse);
      expect(find.text('@'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp(_l.uiMessagesListsMentioned)),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp('4 ${_l.uiMessagesListsUnreadChats}')),
        findsOneWidget,
      );
      semantics.dispose();
      final request = h.backend.requests.singleWhere(
        (r) => r.path == '/v1/me/chat-unread',
      );
      expect(request.header('X-Nizamio-Program'), isNull);
      await tester.tap(find.text('Program İki'));
      await settle(tester);
      expect(h.read(scopeStateProvider).programId, 'prog-2');
    },
  );

  testWidgets('sayaç yükleme/hatası program seçimini engellemez', (
    tester,
  ) async {
    final pending = Completer<ResponseBody>();
    final h = await _open(tester, (_) => pending.future);
    expect(find.text('Program İki'), findsOneWidget);
    await tester.tap(find.text('Program İki'));
    await settle(tester);
    expect(h.read(scopeStateProvider).programId, 'prog-2');
    pending.complete(envelope(503, 'platform.service_unavailable'));
    await settle(tester);
    await tester.tap(find.text('Program Bir'));
    await settle(tester);
    expect(h.read(scopeStateProvider).programId, 'prog-1');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'aynı hesabın rozetleri yenilemede ve yenileme hatasında korunur',
    (tester) async {
      final pending = Completer<ResponseBody>();
      var refresh = false;
      final h = await _open(
        tester,
        (_) => refresh ? pending.future : _overview(),
      );
      expect(find.text('4'), findsOneWidget);
      refresh = true;
      h.container.invalidate(chatUnreadSnapshotProvider);
      await settle(tester);
      expect(find.text('4'), findsOneWidget);
      pending.complete(envelope(503, 'platform.service_unavailable'));
      await settle(tester);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('@'), findsOneWidget);
    },
  );
}
