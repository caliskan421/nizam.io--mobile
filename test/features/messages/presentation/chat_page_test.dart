// ChatPage (sunucu biçimli fikstürle): açılışta okunmamış ayırıcısı ve okundu imleci, gönderim
// (`client_message_id`, tek balon), gönderilemeyen mesajın aynı kimlikle tekrarı, düzenleme
// çakışmasının görünür olması, silme, "yakında" eylemleri, taşma ve yazarken yeniden kurulum.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets show debugOnRebuildDirtyWidget;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_composer.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_chat_bubble.dart';
import 'package:nizamio/features/messages/messages.dart';

import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../chat_backend.dart';

final _l = AppLocalizationsTr();

Future<(Harness, ChatBackend)> _open(
  WidgetTester tester, {
  String id = 'koord',
  bool dark = false,
}) async {
  tester.view.devicePixelRatio = 1;
  if (tester.view.physicalSize.width > 500) {
    tester.view.physicalSize = const Size(390, 844);
  }
  addTearDown(tester.view.reset);
  final backend = ChatBackend();
  final h = await real(tester, () => pilotHarness(backend, signedIn: true));
  h.read(scopeControllerProvider).selectProgram('prog-1');
  await pumpScreen(tester, h, ChatPage(id: id), dark: dark);
  await settle(tester);
  return (h, backend);
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(
    find
        .descendant(
          of: find.byType(NzComposer),
          matching: find.byType(TextField),
        )
        .last,
    text,
  );
  await settle(tester);
}

Future<void> _send(WidgetTester tester) =>
    _tap(tester, find.bySemanticsLabel(_l.uiMessagesSend).last);

Finder _bubble(String text) => find.ancestor(
  of: find.textContaining(text, findRichText: true),
  matching: find.byType(NzChatBubble),
);

Future<void> _longPress(WidgetTester tester, String text) async {
  await tester.longPress(find.textContaining(text, findRichText: true).first);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('açılış: ayırıcı, okundu imleci sunucuya', (tester) async {
    final (_, backend) = await _open(tester);
    expect(find.text(_l.uiMessagesNewMessages), findsOneWidget);
    expect(_bubble('trafo onayı'), findsOneWidget);
    expect(backend.chats.reads['koord'], 'm2');
  });

  testWidgets('gönder: tek balon; tekrar aynı istemci kimliğiyle', (
    tester,
  ) async {
    final (_, backend) = await _open(tester);
    backend.chats.sendError = (503, 'platform.unavailable');
    await _type(tester, 'Toplantı saat 15:00');
    await _send(tester);
    expect(find.textContaining(_l.uiMessagesSendFailed), findsOneWidget);
    await _longPress(tester, 'Toplantı saat 15:00');
    await _tap(tester, find.text(_l.uiMessagesRetrySend));
    expect(_bubble('Toplantı saat 15:00'), findsOneWidget);
    expect(find.textContaining(_l.uiMessagesSendFailed), findsNothing);
    final sent = backend.chats.messages['koord']!.last;
    expect(sent['body'], 'Toplantı saat 15:00');
    expect((sent['client_message_id']! as String).length, 22);
  });

  testWidgets('düzenleme çakışması görünür; silme', (tester) async {
    final (_, backend) = await _open(tester, id: 'kadir');
    backend.chats.editError = (409, 'messaging.edit_conflict');
    await _longPress(tester, 'Planı onayladım');
    await _tap(tester, find.text(_l.uiMessagesEdit));
    await _type(tester, 'Planı onayladım, güncel.');
    await _send(tester);
    expect(find.text(_l.errMessagingEditConflict), findsOneWidget);
    backend.chats.editError = null;
    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
    await _send(tester);
    expect(_bubble('güncel.'), findsOneWidget);
    expect(find.textContaining(_l.uiMessagesEdited), findsOneWidget);
    await _longPress(tester, 'güncel.');
    await _tap(tester, find.text(_l.uiMessagesDelete));
    expect(_bubble('güncel.'), findsNothing);
  });

  testWidgets('sonraki paket eylemleri "yakında"', (tester) async {
    await _open(tester);
    await _longPress(tester, 'trafo onayı');
    await _tap(tester, find.text(_l.uiMessagesToTask));
    expect(find.text(_l.uiMessagesActionSoon), findsOneWidget);
  });

  testWidgets('yazarken balonlar yeniden kurulmaz', (tester) async {
    await _open(tester);
    var n = 0;
    widgets.debugOnRebuildDirtyWidget = (e, builtOnce) {
      if (builtOnce && e.widget is NzChatBubble) n++;
    };
    try {
      await _type(tester, 'Merhaba');
      await _type(tester, 'Merhaba dünya');
    } finally {
      widgets.debugOnRebuildDirtyWidget = null;
    }
    expect(n, 0, reason: 'tuş vuruşu yalnız yazma alanını kurar');
  });

  for (final (width, scale) in [(360.0, 1.0), (360.0, 2.0)]) {
    for (final dark in [false, true]) {
      testWidgets(
        'taşma yok: ${width.toInt()} geniş, ${scale}x, ${dark ? 'koyu' : 'açık'}',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 844);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await _open(tester, dark: dark);
          await _type(tester, 'uzun bir taslak ' * 6);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
