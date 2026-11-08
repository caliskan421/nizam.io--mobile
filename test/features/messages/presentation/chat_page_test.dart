// ChatPage (sunucu biçimli fikstürle): açılışta okunmamış ayırıcısı ve okundu imleci, gönderim
// (`client_message_id`, tek balon), gönderilemeyen mesajın aynı kimlikle tekrarı, düzenleme
// çakışmasının görünür olması, silme, tepki ve sabitleme, grup bilgisi (üyeler, ayrılma), taşma
// ve yazarken yeniden kurulum.
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
  ChatBackend? server,
}) async {
  tester.view.devicePixelRatio = 1;
  if (tester.view.physicalSize.width > 500) {
    tester.view.physicalSize = const Size(390, 844);
  }
  addTearDown(tester.view.reset);
  final backend = server ?? ChatBackend();
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

  testWidgets('tepki ve sabitleme: sunucuya gider, şerit sunucudan', (
    tester,
  ) async {
    final (_, backend) = await _open(tester, id: 'kadir');
    await _longPress(tester, 'Planı onayladım');
    await _tap(tester, find.bySemanticsLabel(_l.uiMessagesReactHeart).last);
    await tester.pump(const Duration(milliseconds: 500));
    await settle(tester);
    expect(backend.chats.writes, ['PUT /v1/chats/kadir/messages/m6/reaction']);
    await _longPress(tester, 'Planı onayladım');
    await _tap(tester, find.text(_l.uiMessagesPin));
    expect(backend.chats.writes.last, 'PUT /v1/chats/kadir/messages/m6/pin');
    expect(find.text(_l.uiMessagesPinned), findsOneWidget);
  });

  testWidgets('grup bilgisi: üyeler listeden; gruptan ayrılma onaylı', (
    tester,
  ) async {
    final (_, backend) = await _open(tester);
    await _tap(tester, find.bySemanticsLabel(RegExp(_l.uiMessagesGroupInfo)));
    expect(find.text('${_l.uiMessagesMembers} (2)'), findsOneWidget);
    await _tap(tester, find.text(_l.uiMessagesLeaveGroup));
    await _tap(tester, find.text(_l.uiMessagesLeaveGroup).last);
    expect(backend.chats.writes, ['DELETE /v1/chats/koord/members/$chatMe']);
  });

  testWidgets('arama: sonuç sayfası, sonuca gidilir; paylaşılan kart', (
    tester,
  ) async {
    await _open(tester);
    expect(find.text('Rapor.pdf'), findsOneWidget, reason: 'balondaki kart');
    await _tap(tester, find.bySemanticsLabel(_l.uiMessagesSearchChat).first);
    await tester.enterText(find.byType(TextField).last, 'haftalık');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await settle(tester);
    await _tap(tester, find.textContaining('haftalık raporu').last);
    expect(_bubble('haftalık raporu'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(RegExp(_l.uiMessagesGroupInfo)));
    await _tap(tester, find.text(_l.uiMessagesShared));
    expect(find.text('Rapor.pdf'), findsWidgets);
  });

  testWidgets('anket: ek menüsünden oluşturulur; sonuçlar sayfası', (
    tester,
  ) async {
    final (_, backend) = await _open(tester);
    await _tap(tester, find.bySemanticsLabel(_l.uiMessagesAttach).last);
    await _tap(tester, find.text(_l.uiMessagesAttachPoll));
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(fields.evaluate().length - 3), 'Hangisi?');
    await tester.enterText(
      fields.at(fields.evaluate().length - 2),
      'Pazartesi',
    );
    await tester.enterText(fields.last, 'Salı');
    await settle(tester);
    await _tap(tester, find.text(_l.uiMessagesPollAddOption));
    await _tap(tester, find.text(_l.uiMessagesSend).last);
    final sent = backend.chats.messages['koord']!.last;
    expect(sent['body'], 'Hangisi?');
    expect((sent['poll']! as Map<String, Object?>)['results'], hasLength(2));
    await _longPress(tester, 'Hangisi?');
    await _tap(tester, find.text(_l.uiMessagesPollResults));
    expect(find.text(_l.uiMessagesPollNoVotes), findsWidgets);
  });

  testWidgets('grup yöneticisi: ad, üye ekleme ve yöneticilik', (tester) async {
    final backend0 = ChatBackend()..chats.role = 'admin';
    final (_, backend) = await _open(tester, server: backend0);
    await _tap(tester, find.bySemanticsLabel(RegExp(_l.uiMessagesGroupInfo)));
    await _tap(tester, find.text(_l.uiMessagesRename));
    await tester.enterText(find.byType(TextField).last, 'Koordinasyon');
    await settle(tester);
    await _tap(tester, find.text(_l.uiMessagesSave));
    expect(backend.chats.writes, ['PATCH /v1/chats/koord']);
    await _tap(tester, find.bySemanticsLabel(RegExp(_l.uiMessagesGroupInfo)));
    await _tap(tester, find.bySemanticsLabel(_l.uiMessagesAddMembers));
    await _tap(tester, find.text('Reha Koçak').last);
    await _tap(tester, find.text(_l.uiMessagesAdd));
    expect(backend.chats.writes.last, 'POST /v1/chats/koord/members');
    await _tap(tester, find.bySemanticsLabel('Reha Koçak').last);
    await _tap(tester, find.text(_l.uiMessagesMakeAdmin));
    expect(backend.chats.writes.last, 'PUT /v1/chats/koord/admins/acc-rk');
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
