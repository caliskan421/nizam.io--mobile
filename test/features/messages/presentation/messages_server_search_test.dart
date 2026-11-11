import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/feedback/feedback.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_chat_row.dart';
import 'package:nizamio/features/messages/messages.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../chat_backend.dart';

final _l = AppLocalizationsTr();

Future<(Harness, ChatBackend)> _open(WidgetTester tester) async {
  final backend = ChatBackend();
  final h = await real(tester, () => pilotHarness(backend, signedIn: true));
  h.read(scopeControllerProvider).selectProgram('prog-1');
  await pumpScreen(tester, h, const MessagesPage());
  await settle(tester);
  await tester.tap(find.byIcon(Icons.search_rounded).first);
  await settle(tester);
  return (h, backend);
}

Future<void> _query(WidgetTester tester, String query) async {
  await tester.enterText(find.byType(TextField).first, query);
  await tester.pump(const Duration(milliseconds: 301));
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('geçmiş eşleşmesi son mesajda görünmese de server sonucu kalır', (
    tester,
  ) async {
    final (h, _) = await _open(tester);
    await _query(tester, 'Pompalar');
    expect(find.byType(NzChatRow), findsOneWidget);
    expect(find.text('Genel'), findsOneWidget);
    expect(find.textContaining('Teşekkürler'), findsOneWidget);
    expect(
      h.backend.requests.where((r) => r.path == '/v1/chats').last.query['q'],
      'Pompalar',
    );
    await tester.tap(find.text(_l.uiMessagesFilterPeople));
    await settle(tester);
    expect(find.byType(NzChatRow), findsNothing);
    await tester.tap(find.text(_l.uiMessagesFilterAll));
    await settle(tester);
    expect(find.text('Genel'), findsOneWidget);
  });

  testWidgets('debounce, loading, hata, retry ve clear normal kutuya dönüş', (
    tester,
  ) async {
    final (h, backend) = await _open(tester);
    final reply = Completer<ResponseBody>();
    var failed = false;
    h.backend.handler = (r) {
      if (r.path == '/v1/chats' && r.query['q'] == 'ara') {
        if (!failed) return reply.future;
        return backend.handle(r);
      }
      return backend.handle(r);
    };
    int searches() => h.backend.requests
        .where((r) => r.path == '/v1/chats' && r.query.containsKey('q'))
        .length;
    final before = searches();
    await tester.enterText(find.byType(TextField).first, 'a');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField).first, 'ara');
    await tester.pump(const Duration(milliseconds: 299));
    expect(searches(), before);
    await tester.pump(const Duration(milliseconds: 2));
    await settle(tester);
    expect(searches(), before + 1);
    expect(find.byType(NzLoader), findsOneWidget);
    expect(find.byType(NzChatRow), findsNothing);
    failed = true;
    reply.complete(envelope(503, 'platform.service_unavailable'));
    await settle(tester);
    expect(find.byType(NzErrorState), findsOneWidget);
    await tester.tap(find.text(_l.uiCommonRetry));
    await settle(tester);
    expect(find.text(_l.uiMessagesListsSearchEmpty), findsOneWidget);
    await _query(tester, '');
    expect(find.byType(NzChatRow), findsNWidgets(3));
  });

  testWidgets('eski query yanıtı yeniyi ezmez; resize aynı aramayı korur', (
    tester,
  ) async {
    final (h, backend) = await _open(tester);
    final old = Completer<ResponseBody>();
    h.backend.handler = (r) =>
        r.path == '/v1/chats' && r.query['q'] == 'Pompalar'
        ? old.future
        : backend.handle(r);
    await _query(tester, 'Pompalar');
    await _query(tester, 'Hidrofor');
    expect(find.text('Kadir Özbek'), findsOneWidget);
    old.complete(
      backend.handle(
        Seen('GET', '/v1/chats', {}, null, query: const {'q': 'Pompalar'}),
      ),
    );
    await settle(tester);
    expect(find.text('Kadir Özbek'), findsOneWidget);
    expect(find.text('Genel'), findsNothing);
    final reads = backend.inboxReads;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1180, 820);
    addTearDown(tester.view.reset);
    await settle(tester);
    expect(find.widgetWithText(TextField, 'Hidrofor'), findsOneWidget);
    expect(backend.inboxReads, reads);
    expect(tester.takeException(), isNull);
  });
}
