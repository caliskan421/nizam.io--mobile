import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_page.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/core/ui/widgets/feedback/feedback.dart';
import 'package:nizamio/features/messages/presentation/chat/chat_find_sheets.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../chat_backend.dart';

final _l = AppLocalizationsTr();

Future<Harness> _open(WidgetTester tester, FakeHandler handler) async {
  final backend = ChatBackend();
  final h = await real(tester, () => pilotHarness(backend, signedIn: true));
  h.read(scopeControllerProvider).selectProgram('prog-1');
  h.backend.handler = (r) =>
      r.path.endsWith('/refs') ? handler(r) : backend.handle(r);
  await pumpScreen(
    tester,
    h,
    NzPage(
      title: _l.uiMessagesShared,
      body: Builder(
        builder: (context) => NzButton.primary(
          label: 'open',
          onPressed: () => showChatShared(context, 'koord', onFile: (_, _) {}),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await settle(tester);
  return h;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('tür değişimi cursor sıfırlar; busy more tekrar basılamaz', (
    tester,
  ) async {
    final more = Completer<ResponseBody>();
    final h = await _open(tester, (r) {
      if (r.query['cursor'] != null) return more.future;
      return jsonResponse(200, {
        'items': <Object>[],
        'next_cursor': r.query['kind'] == null ? 'page-two' : null,
      });
    });
    await tester.tap(find.text(_l.uiMessagesMore));
    await settle(tester);
    final button = tester.widget<NzButton>(
      find.widgetWithText(NzButton, _l.uiMessagesMore),
    );
    expect(button.loading, isTrue);
    expect(button.onPressed, isNull);
    await tester.tap(find.text(_l.uiMessagesRefTask));
    await settle(tester);
    final task = h.backend.requests.where((r) => r.path.endsWith('/refs')).last;
    expect(task.query['kind'], 'task');
    expect(task.query['cursor'], isNull);
    more.complete(
      jsonResponse(200, {'items': <Object>[], 'next_cursor': 'old'}),
    );
    await settle(tester);
    expect(find.text(_l.uiMessagesMore), findsNothing);
    await tester.tap(find.text(_l.uiMessagesRefDepartment));
    await settle(tester);
    expect(h.backend.requests.last.query['kind'], 'department');
    await tester.tap(find.text(_l.uiMessagesRefFile));
    await settle(tester);
    expect(h.backend.requests.last.query['kind'], 'file');
  });

  testWidgets('filtre hatada kalır; retry aynı türü yeniden okur', (
    tester,
  ) async {
    var fail = true;
    final h = await _open(tester, (r) {
      if (r.query['kind'] == 'file' && fail) {
        return envelope(503, 'platform.service_unavailable');
      }
      return jsonResponse(200, {'items': <Object>[], 'next_cursor': null});
    });
    await tester.tap(find.text(_l.uiMessagesRefFile));
    await settle(tester);
    expect(find.byType(NzErrorState), findsOneWidget);
    expect(find.text(_l.uiMessagesFilterAll), findsOneWidget);
    fail = false;
    await tester.tap(find.text(_l.uiCommonRetry));
    await settle(tester);
    expect(h.backend.requests.last.query['kind'], 'file');
    expect(find.text(_l.uiMessagesSharedEmpty), findsOneWidget);
  });
}
