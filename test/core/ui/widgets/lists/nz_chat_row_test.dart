// NzChatRow / NzChatAvatar: içerik, okunmamış ve bahsetme rozetleri, tik, grup avatarı,
// dokunma, dar ekran / 2.0 metin.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_chat_row.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  test(
    'baş harfler: ilk iki sözcük, Türkçe büyük harf; tek sözcük tek harf',
    () {
      expect(NzChatAvatar.initialsOf('Kerem Özdal'), 'KÖ');
      expect(NzChatAvatar.initialsOf('Hidrofor teslim ekibi'), 'HT');
      expect(NzChatAvatar.initialsOf('Genel'), 'G');
      expect(NzChatAvatar.initialsOf('ilk iş'), 'İİ');
    },
  );

  testWidgets('okunmamış: saat vurgulu, rozet ve @; dokunma', (t) async {
    final handle = t.ensureSemantics();
    var n = 0;
    await t.pumpWidget(
      testApp(
        NzChatRow(
          name: 'Koordinatörler',
          initials: 'K',
          group: true,
          preview: 'Rıza: trafo onayı',
          time: '09:51',
          unread: 2,
          mention: true,
          semanticHint: '2 okunmamış',
          onTap: () => n++,
        ),
      ),
    );
    expect(find.text('2'), findsOneWidget);
    expect(find.text('@'), findsOneWidget);
    final time = t.widget<Text>(find.text('09:51'));
    expect(time.style!.color, NizamioColors.light.accentText);
    await t.tap(find.byType(NzChatRow));
    expect(n, 1);
    expect(
      t.getSemantics(find.byType(NzChatRow)),
      matchesSemantics(
        label: 'Koordinatörler, Rıza: trafo onayı, 09:51, 2 okunmamış',
        isButton: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('kendi son mesajı: okunduysa vurgulu çift tik; çevrimiçi nokta', (
    t,
  ) async {
    await t.pumpWidget(
      testApp(
        NzChatRow(
          name: 'Kerem Özdal',
          initials: 'KÖ',
          tone: 3,
          online: true,
          preview: 'Sen: Planı onayladım',
          time: '09:14',
          tick: NzChatTick.read,
          onTap: () {},
        ),
      ),
    );
    final tick = t.widget<Icon>(find.byIcon(Icons.done_all_rounded));
    expect(tick.color, NizamioColors.light.accentText);
    expect(find.text('KÖ'), findsOneWidget);
    expect(
      t.widget<Text>(find.text('09:14')).style!.color,
      NizamioColors.light.textFaint,
    );
  });

  testWidgets('360 / 2.0 taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 400);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(
        NzChatRow(
          name: 'Sistem koordinatörlüğü çok uzun ad',
          initials: 'SK',
          group: true,
          preview: 'Sen: Teşekkürler, yarın koordinatörlere duyururum.',
          time: '19 Eki',
          unread: 12,
          mention: true,
          tick: NzChatTick.delivered,
          onTap: () {},
        ),
        dark: true,
      ),
    );
    expect(t.takeException(), isNull);
  });
}
