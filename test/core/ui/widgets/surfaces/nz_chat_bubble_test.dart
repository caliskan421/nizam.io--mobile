// NzChatBubble: kendi/başkası rengi ve hizası, köşeler, ad + rol, alıntı dokunuşu, tik,
// tepkiler, basılı tutma (480 ms; kayma iptal), gün hapı ve ayırıcı, 2.0 metin.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_chat_row.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_chat_bubble.dart';

import '../feedback/feedback_test_support.dart';

BoxDecoration _decoration(WidgetTester t) {
  final box = t.widget<AnimatedContainer>(find.byType(AnimatedContainer));
  return box.decoration! as BoxDecoration;
}

void main() {
  setUpFonts();

  testWidgets(
    'kendi mesajı: bubble-mine, sağda; son balon köşesi; okundu tik',
    (t) async {
      await t.pumpWidget(
        testApp(
          const NzChatBubble(
            mine: true,
            body: Text('Merhaba'),
            time: '10:02',
            semanticLabel: 'Sen, Merhaba',
            tick: NzChatTick.read,
            editedLabel: 'düzenlendi',
            pinned: true,
          ),
        ),
      );
      final d = _decoration(t);
      expect(d.color, NizamioColors.light.bubbleMine);
      final r = d.borderRadius! as BorderRadius;
      expect(r.bottomRight.x, NizamioRadius.bubbleTail);
      expect(r.topRight.x, NizamioRadius.row);
      expect(find.text('düzenlendi ·'), findsOneWidget);
      expect(find.byIcon(Icons.push_pin_outlined), findsOneWidget);
      expect(
        t.widget<Icon>(find.byIcon(Icons.done_all_rounded)).color,
        NizamioColors.light.accentText,
      );
      final row = t.widget<Row>(find.byType(Row).first);
      expect(row.mainAxisAlignment, MainAxisAlignment.end);
    },
  );

  testWidgets(
    'başkası: ad + rol, alıntı dokunuşu, tepki dokunuşu, avatar yuvası',
    (t) async {
      var quote = 0;
      var react = 0;
      await t.pumpWidget(
        testApp(
          NzChatBubble(
            mine: false,
            last: false,
            body: const Text('Vardiya taslağı arşivde'),
            time: '18:20',
            semanticLabel: 'Yunus Çiftçioğlu',
            senderName: 'Yunus Çiftçioğlu',
            senderRole: 'Koordinatör',
            showAvatarSlot: true,
            avatar: const NzChatAvatar(initials: 'YÇ', extent: 30),
            quote: NzChatQuote(
              who: 'Sen',
              text: '@herkes Fuar haftası',
              color: NizamioColors.light.accentText,
              semanticLabel: 'Alıntılanan mesaja git',
              onTap: () => quote++,
            ),
            reactions: [
              NzChatReactionChip(
                kind: NzReaction.like,
                count: 8,
                mine: true,
                semanticLabel: 'Beğen',
                onTap: () => react++,
              ),
            ],
          ),
        ),
      );
      expect(_decoration(t).color, NizamioColors.light.bubbleOther);
      expect(find.textContaining('Yunus Çiftçioğlu'), findsOneWidget);
      // Dizinin son balonu değil: avatar gizli.
      expect(find.text('YÇ'), findsNothing);
      await t.tap(find.text('Sen'));
      expect(quote, 1);
      await t.tap(find.text('8'));
      expect(react, 1);
    },
  );

  testWidgets('basılı tutma 480 ms sonra işlem; kısa dokunuş ve kayma iptal', (
    t,
  ) async {
    var n = 0;
    await t.pumpWidget(
      testApp(
        Center(
          child: NzChatBubble(
            mine: false,
            body: const Text('Basılı tut'),
            time: '09:00',
            semanticLabel: 'mesaj',
            onLongPress: () => n++,
          ),
        ),
      ),
    );
    final center = t.getCenter(find.text('Basılı tut'));
    var g = await t.startGesture(center);
    await t.pump(const Duration(milliseconds: 300));
    await g.up();
    await t.pump(const Duration(milliseconds: 400));
    expect(n, 0);
    g = await t.startGesture(center);
    await t.pump(const Duration(milliseconds: 100));
    await g.moveBy(const Offset(0, 20));
    await t.pump(const Duration(milliseconds: 500));
    await g.up();
    expect(n, 0);
    g = await t.startGesture(center);
    await t.pump(const Duration(milliseconds: 200));
    expect(t.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 0.97);
    await t.pump(const Duration(milliseconds: 300));
    expect(n, 1);
    await g.up();
    await t.pumpAndSettle();
  });

  testWidgets('gün hapı ve okunmamış ayırıcısı; 360 / 2.0 taşma yok', (
    t,
  ) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 800);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(
        const Column(
          children: [
            NzChatDayChip('Bugün'),
            NzChatNewDivider('okunmamış mesajlar'),
            NzChatBubble(
              mine: false,
              body: Text(
                'Konaklama listesini güncelledim, eksik olan varsa yazın.',
              ),
              time: '09:40',
              semanticLabel: 'mesaj',
              senderName: 'Bahar Kılıç',
              senderRole: 'Üye',
              editedLabel: 'düzenlendi',
              showAvatarSlot: true,
              avatar: NzChatAvatar(initials: 'BK', extent: 30),
            ),
          ],
        ),
        dark: true,
      ),
    );
    expect(find.text('Bugün'), findsOneWidget);
    expect(find.text('okunmamış mesajlar'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
