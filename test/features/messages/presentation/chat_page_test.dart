// ChatPage: üst çubuk (yazıyor → üye sayısı), sabit şerit, gün hapları, okunmamış ayırıcısı,
// gönderme (tik durumları), öneriler, ek paneli ve atıf hapı, basılı tutma işlemleri (yanıtla,
// sabitle, sil), tepki ve anket, görev atfı gezinmesi, sohbet bilgisi, klavye, taşma.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets show debugOnRebuildDirtyWidget;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_composer.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_chat_bubble.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/messages.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<(Harness, RecordingAppNav)> _open(
  WidgetTester tester, {
  String id = 'gen',
  bool dark = false,
}) async {
  tester.view.devicePixelRatio = 1;
  if (tester.view.physicalSize.width > 500) {
    tester.view.physicalSize = const Size(390, 844);
  }
  addTearDown(tester.view.reset);
  final h = await real(tester, () => pilotHarness(PilotBackend()));
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    ChatPage(id: id),
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

Finder _bubble(String text) => find.ancestor(
  of: find.textContaining(text, findRichText: true),
  matching: find.byType(NzChatBubble),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets(
    'üst çubuk, sabit şerit, gün hapları, okunmamış ayırıcısı; okundu',
    (tester) async {
      final (h, _) = await _open(tester);
      expect(find.text('Genel'), findsOneWidget);
      expect(find.text('Rıza ${_l.uiMessagesTyping}'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      expect(find.text('18 ${_l.uiMessagesMembersLc}'), findsOneWidget);
      expect(find.text('${_l.uiMessagesPinned} 1/2'), findsOneWidget);
      await _tap(tester, find.text('${_l.uiMessagesPinned} 1/2'));
      expect(find.text('${_l.uiMessagesPinned} 2/2'), findsOneWidget);
      // Akış tembel ve ters: eski uç (dün) yukarı kaydırınca kurulur.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 3000));
      await settle(tester);
      expect(find.text(_l.uiMessagesYesterday), findsOneWidget);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
      await settle(tester);
      expect(find.text(_l.uiMessagesToday), findsOneWidget);
      expect(find.text(_l.uiMessagesNewMessages), findsOneWidget);
      expect(
        find.text('Kapanış yemeği için hangi günler uygun?'),
        findsWidgets,
      );
      expect(h.read(messagesNavCaptionProvider), '4 ${_l.uiMessagesUnreadLc}');
    },
  );

  testWidgets('gönder: yazınca etkin; tek tik → çift tik → okundu', (
    tester,
  ) async {
    await _open(tester, id: 'sis');
    await _type(tester, 'Toplantı saat 15:00');
    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      find.textContaining('Toplantı saat 15:00', findRichText: true),
      findsOneWidget,
    );
    final bubble = _bubble('Toplantı saat 15:00');
    expect(
      find.descendant(of: bubble, matching: find.byIcon(Icons.done_rounded)),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 600));
    expect(
      find.descendant(
        of: bubble,
        matching: find.byIcon(Icons.done_all_rounded),
      ),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 2));
    await settle(tester);
  });

  testWidgets('öneriler: #görev ve @kişi taslağa yazılır; görev atfı açılır', (
    tester,
  ) async {
    final (_, nav) = await _open(tester, id: 'kadir');
    await _type(tester, 'Bak #ALT-1');
    await _tap(tester, find.text('ALT-1').last);
    final field = tester.widget<TextField>(
      find.descendant(
        of: find.byType(NzComposer),
        matching: find.byType(TextField),
      ),
    );
    expect(field.controller!.text, 'Bak #ALT-1 ');
    await _type(tester, '@ker');
    await _tap(
      tester,
      find.text('Kerem Özdal · ${_l.uiMessagesRoleCoordinator}'),
    );
    expect(field.controller!.text, '@Kerem Özdal ');
    await _tap(tester, find.text('#ALT-7').last);
    expect(nav.calls, ['task:ALT-7']);
  });

  testWidgets(
    'ek paneli: görev atfı hapı; cihaz fotoğrafı; gönderilince balonda',
    (tester) async {
      await _open(tester, id: 'sis');
      await _tap(tester, find.byIcon(Icons.add_rounded).first);
      expect(find.text(_l.uiMessagesPhotoVideo), findsOneWidget);
      await _tap(tester, find.text(_l.uiMessagesRefCoordinatorship));
      await _tap(tester, find.text('Altyapı ve tesisat').last);
      expect(find.byType(NzRefChip), findsOneWidget);
      await _tap(tester, find.text(_l.uiMessagesPhotoVideo));
      expect(find.text(_l.uiMessagesPhotoVideo), findsNothing);
      expect(find.byType(NzRefChip), findsNWidgets(2));
      await _tap(tester, find.byIcon(Icons.arrow_upward_rounded));
      expect(find.byType(NzRefChip), findsNothing);
      expect(
        find.textContaining('IMG_2042.jpeg', findRichText: true),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 2));
      await settle(tester);
    },
  );

  testWidgets(
    'basılı tut: yanıtla bağlamı; sabitle; tepki; kendi mesajını sil',
    (tester) async {
      await _open(tester, id: 'kadir');
      await tester.longPress(_bubble('Hidrofor için yeni tarih'));
      await settle(tester);
      // Prototip: işlem sayfası başlıksız; ad semantikte.
      expect(find.text(_l.uiMessagesMessageActions), findsNothing);
      expect(find.bySemanticsLabel(_l.uiMessagesMessageActions), findsWidgets);
      await _tap(tester, find.text(_l.uiMessagesReply));
      expect(find.text('Kerem Özdal ${_l.uiMessagesReplyTo}'), findsOneWidget);
      await _tap(tester, find.byTooltip(_l.uiMessagesCancel));

      await tester.longPress(_bubble('Hidrofor için yeni tarih'));
      await settle(tester);
      await _tap(tester, find.text(_l.uiMessagesPin));
      expect(find.text(_l.uiMessagesPinnedToast), findsOneWidget);
      expect(find.text(_l.uiMessagesPinned), findsOneWidget);

      await tester.longPress(_bubble('Hidrofor için yeni tarih'));
      await settle(tester);
      await _tap(tester, find.bySemanticsLabel(_l.uiMessagesReactHeart));
      expect(find.text('1'), findsOneWidget);

      await tester.longPress(_bubble('Planı onayladım'));
      await settle(tester);
      expect(find.text(_l.uiMessagesEdit), findsOneWidget);
      await _tap(tester, find.text(_l.uiMessagesDelete));
      expect(find.text(_l.uiMessagesDeleted), findsOneWidget);
      expect(_bubble('Planı onayladım'), findsNothing);
    },
  );

  testWidgets('düzenle: metin alana gelir, gönderince "düzenlendi"', (
    tester,
  ) async {
    await _open(tester, id: 'kadir');
    await tester.longPress(_bubble('Planı onayladım'));
    await settle(tester);
    await _tap(tester, find.text(_l.uiMessagesEdit));
    expect(find.text(_l.uiMessagesEditMessage), findsOneWidget);
    await _type(tester, 'Planı onayladım, takvim güncel.');
    await _tap(tester, find.byIcon(Icons.arrow_upward_rounded));
    expect(find.text('${_l.uiMessagesEdited} ·'), findsOneWidget);
  });

  testWidgets('anket: oy ver; sonuçlar sayfası ve anketi bitir', (
    tester,
  ) async {
    await _open(tester);
    await tester.tap(find.text('31 Ekim Cumartesi'));
    await settle(tester);
    expect(find.text('10 ${_l.uiMessagesVotedTail}'), findsOneWidget);
    await tester.longPress(_bubble('Kapanış yemeği için gün seçelim').first);
    await settle(tester);
    await _tap(tester, find.text(_l.uiMessagesPollResults));
    expect(find.text('${_l.uiMessagesNotVoted} · 8'), findsOneWidget);
    expect(find.text(_l.uiMessagesPollResultsLc), findsOneWidget);
    await _tap(tester, find.text(_l.uiMessagesEndPoll));
    expect(find.text(_l.uiMessagesPollConcluded), findsOneWidget);
    expect(find.textContaining(_l.uiMessagesConcluded), findsWidgets);
  });

  testWidgets(
    'sohbet bilgisi: paylaşılanlar ve üyeler; dosya arşiv klasörünü açar',
    (tester) async {
      final (_, nav) = await _open(tester);
      await _tap(tester, find.text('Genel'));
      expect(find.text('${_l.uiMessagesShared} · 5'), findsOneWidget);
      expect(find.text('${_l.uiMessagesMembers} · 18'), findsOneWidget);
      await _tap(tester, find.text('Vardiya_taslak.xlsx'));
      expect(nav.calls, ['folder:OPE']);
      await _tap(tester, find.text('Genel').first);
      await _tap(tester, find.text(_l.uiMessagesMute));
      expect(find.text('Genel ${_l.uiMessagesMutedTail}'), findsOneWidget);
    },
  );

  testWidgets('klavye: yazma alanı klavyenin üstüne kalkar', (tester) async {
    await _open(tester, id: 'sis');
    final before = tester.getBottomLeft(find.byType(TextField).last).dy;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await settle(tester);
    final after = tester.getBottomLeft(find.byType(TextField).last).dy;
    expect(before - after, greaterThan(250));
    expect(after, lessThanOrEqualTo(844 - 300));
  });

  for (final (width, scale) in [(360.0, 1.0), (360.0, 2.0), (390.0, 2.0)]) {
    for (final dark in [false, true]) {
      testWidgets(
        'taşma yok: ${width.toInt()} geniş, ${scale}x, ${dark ? 'koyu' : 'açık'}',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 844);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await _open(tester, dark: dark);
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 6; i++) {
            await tester.drag(scrollable, const Offset(0, 300));
            await tester.pump();
          }
          await _tap(tester, find.byIcon(Icons.add_rounded).first);
          await _type(tester, '#ALT');
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  group('performans', () {
    /// Ölçüm süresince yeniden kurulan [NzChatBubble] öğeleri.
    Future<int> bubbleRebuilds(Future<void> Function() body) async {
      var n = 0;
      widgets.debugOnRebuildDirtyWidget = (e, builtOnce) {
        if (builtOnce && e.widget is NzChatBubble) n++;
      };
      try {
        await body();
      } finally {
        widgets.debugOnRebuildDirtyWidget = null;
      }
      return n;
    }

    testWidgets('yazarken balonlar yeniden kurulmaz', (tester) async {
      await _open(tester);
      expect(find.byType(NzChatBubble), findsWidgets);
      final n = await bubbleRebuilds(() async {
        await _type(tester, 'Merhaba');
        await _type(tester, 'Merhaba #AL');
      });
      expect(n, 0, reason: 'tuş vuruşu yalnız yazma alanını kurar');
    });

    testWidgets(
      'uzun akış tembel; yeni mesajda eski balonlar yeniden kurulmaz; sabite atlar',
      (tester) async {
        final (h, _) = await _open(tester);
        final chats = h.read(chatsControllerProvider.notifier);
        for (var i = 0; i < 80; i++) {
          chats.send(
            'gen',
            from: 'ma',
            at: DateTime(2026, 10, 21, 11, i % 60),
            text: 'Uzun akış mesajı $i',
          );
        }
        await settle(tester);
        final built = find.byType(NzChatBubble).evaluate().length;
        expect(built, lessThan(40), reason: '86 mesajın yalnız görünenleri');
        expect(
          find.textContaining('Uzun akış mesajı 79', findRichText: true),
          findsOneWidget,
          reason: 'akış en yenide (altta) açık',
        );
        final n = await bubbleRebuilds(() async {
          chats.send(
            'gen',
            from: 'ma',
            at: DateTime(2026, 10, 21, 12),
            text: 'Bir tane daha',
          );
          await tester.pump();
        });
        expect(n, lessThan(4), reason: 'anahtarlı öğeler yer değiştirir');
        // Sabit şerit en eski uçtaki sabit mesaja kaydırır (ekran dışında kurulmamıştı).
        await _tap(tester, find.textContaining(_l.uiMessagesPinned));
        await tester.pump(const Duration(seconds: 1));
        await settle(tester);
        expect(find.byType(NzChatBubble), findsWidgets);
        expect(
          find.textContaining('Uzun akış mesajı 79', findRichText: true),
          findsNothing,
          reason: 'akış eski uca kaydı',
        );
      },
    );
  });
}
