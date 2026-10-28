import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_avatar.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

Widget _variants(BuildContext context) => Wrap(
  spacing: NizamioSpacing.space2,
  runSpacing: NizamioSpacing.space2,
  children: [
    for (final size in NzSize.values) ...[
      NzAvatar.initials(name: 'İlker Işık', size: size),
      NzAvatar.icon(size: size),
    ],
  ],
);

void main() {
  setUpFonts();

  group('initialsOf', () {
    test('Türkçe büyük harf: i → İ, ı → I', () {
      expect(NzAvatar.initialsOf('ilker ışık'), 'İI');
      expect(NzAvatar.initialsOf('ışıl'), 'I');
      expect(NzAvatar.initialsOf('ayşe iğdir'), 'Aİ');
    });

    test('tek sözcük bir harf; çok sözcükte ilk ve son', () {
      expect(NzAvatar.initialsOf('Ali'), 'A');
      expect(NzAvatar.initialsOf('Ali Veli Demir'), 'AD');
    });

    test('boşluk kırpılır; boş ad boş döner', () {
      expect(NzAvatar.initialsOf('  mehmet   özkan '), 'MÖ');
      expect(NzAvatar.initialsOf('   '), '');
    });
  });

  testWidgets('initials: baş harfleri gösterir', (tester) async {
    await tester.pumpWidget(
      testApp(const NzAvatar.initials(name: 'ilker ışık')),
    );
    expect(find.text('İI'), findsOneWidget);
  });

  testWidgets('icon: simgeyi gösterir', (tester) async {
    await tester.pumpWidget(testApp(const NzAvatar.icon()));
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('çap boyuta göre; daire primary zemin', (tester) async {
    final diameters = <double>[];
    for (final size in NzSize.values) {
      await tester.pumpWidget(
        testApp(
          Row(
            children: [NzAvatar.initials(name: 'A', size: size)],
          ),
        ),
      );
      final s = tester.getSize(find.byType(NzAvatar));
      expect(s.width, s.height);
      diameters.add(s.width);
    }
    expect(diameters, [32, 40, 64]);
    final deco =
        tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(NzAvatar),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration;
    expect(deco.color, NizamioColors.light.primary);
    expect(deco.shape, BoxShape.circle);
  });

  testWidgets('ağdan görsel çekmez (Image yok)', (tester) async {
    await tester.pumpWidget(testApp(const NzAvatar.initials(name: 'A B')));
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('anlamsal: ad etiket olur; etiketsiz simge gizli', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(testApp(const NzAvatar.initials(name: 'Ali Veli')));
    expect(
      tester.getSemantics(find.byType(NzAvatar)),
      matchesSemantics(label: 'Ali Veli', isImage: true),
    );
    await tester.pumpWidget(
      testApp(const NzAvatar.icon(semanticLabel: 'Kişi')),
    );
    expect(
      tester.getSemantics(find.byType(NzAvatar)),
      matchesSemantics(label: 'Kişi', isImage: true),
    );
    handle.dispose();
  });

  testWidgets('metin ölçeği 2.0: taşma yok', (tester) async {
    await tester.pumpWidget(
      testApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: NzAvatar.initials(name: 'Mm Mm', size: NzSize.sm),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('piksel: tabaka 1024 geniş, primary daire', (tester) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.primary,
      NizamioColors.dark.primary,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_avatar.png'),
      );
    },
  );

  group('tone / extent', () {
    BoxDecoration deco(WidgetTester t) =>
        t
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(NzAvatar),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration;

    test('toneOf kararlı ve 0–4 aralığında', () {
      for (final n in ['Kadir Özbek', 'Ali Avcı', 'Merve Koçoğlu', '']) {
        final a = NzAvatar.toneOf(n);
        expect(a, inInclusiveRange(0, NzAvatar.toneCount - 1));
        expect(NzAvatar.toneOf(n), a);
      }
    });

    testWidgets('tone → avatarN dolgu, onAvatar yazı; nötr → overlay + ink', (
      t,
    ) async {
      final c = NizamioColors.light;
      final fills = [c.avatar1, c.avatar2, c.avatar3, c.avatar4, c.avatar5];
      for (var i = 0; i < 5; i++) {
        await t.pumpWidget(
          testApp(
            Center(
              child: NzAvatar.initials(name: 'Ali Veli', tone: i),
            ),
          ),
        );
        expect(deco(t).color, fills[i]);
        expect(t.widget<Text>(find.text('AV')).style!.color, c.onAvatar);
      }
      await t.pumpWidget(
        testApp(
          const Center(
            child: NzAvatar.initials(
              name: 'Ali Veli',
              tone: NzAvatar.neutralTone,
            ),
          ),
        ),
      );
      expect(deco(t).color, c.surfaceOverlay);
      expect(t.widget<Text>(find.text('AV')).style!.color, c.text);
    });

    testWidgets('extent çapları 26/32/44/52', (t) async {
      for (final e in NzAvatarSize.values) {
        await t.pumpWidget(
          testApp(
            Center(
              child: NzAvatar.initials(name: 'Ali', extent: e),
            ),
          ),
        );
        expect(t.getSize(find.byType(NzAvatar)), Size.square(e.diameter));
      }
      expect(NzAvatarSize.values.map((e) => e.diameter), [26, 32, 44, 52]);
    });

    testWidgets('extent 2.0 metinde taşma yok', (t) async {
      t.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
      await t.pumpWidget(
        testApp(
          const Center(
            child: NzAvatar.initials(name: 'Mm Mm', extent: NzAvatarSize.sm),
          ),
        ),
      );
      expect(t.takeException(), isNull);
    });
  });
}
