import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

typedef _Make = NzButton Function({
  required String label,
  required VoidCallback? onPressed,
  NzSize size,
  bool loading,
  IconData? icon,
  bool expand,
});

final _makers = <String, _Make>{
  'primary': NzButton.primary,
  'secondary': NzButton.secondary,
  'ghost': NzButton.ghost,
  'danger': NzButton.danger,
};

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final make in _makers.values) ...[
      Wrap(
        spacing: NizamioSpacing.space2,
        runSpacing: NizamioSpacing.space2,
        children: [
          for (final size in NzSize.values)
            make(label: 'Kaydet', onPressed: () {}, size: size),
          make(label: 'Ekle', onPressed: () {}, icon: Icons.add),
          make(label: 'Yükleniyor', onPressed: () {}, loading: true),
          make(label: 'Devre dışı', onPressed: null),
        ],
      ),
      cellGap,
      make(label: 'Tam genişlik', onPressed: () {}, expand: true),
      cellGap,
    ],
  ],
);

void main() {
  setUpFonts();

  for (final entry in _makers.entries) {
    group(entry.key, () {
      final make = entry.value;

      testWidgets('etiket gösterilir, dokunuşta çağrılır', (tester) async {
        var n = 0;
        await tester.pumpWidget(
          testApp(make(label: 'Kaydet', onPressed: () => n++)),
        );
        expect(find.text('Kaydet'), findsOneWidget);
        await tester.tap(find.text('Kaydet'));
        expect(n, 1);
      });

      testWidgets('onPressed null → devre dışı, dokunuş etkisiz', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          testApp(make(label: 'Kaydet', onPressed: null)),
        );
        await tester.tap(find.text('Kaydet'), warnIfMissed: false);
        expect(
          tester.getSemantics(find.byType(NzButton)),
          matchesSemantics(
            label: 'Kaydet',
            isButton: true,
            hasEnabledState: true,
            isEnabled: false,
          ),
        );
        handle.dispose();
      });

      testWidgets('loading: onPressed çağrılmaz, anlamsal durum meşgul', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        var n = 0;
        await tester.pumpWidget(
          testApp(make(label: 'Kaydet', onPressed: () => n++, loading: true)),
        );
        await tester.tap(find.text('Kaydet'), warnIfMissed: false);
        await tester.pump();
        expect(n, 0);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(
          tester.getSemantics(find.byType(NzButton)),
          matchesSemantics(
            label: 'Kaydet',
            value: 'Meşgul',
            isButton: true,
            hasEnabledState: true,
            isEnabled: false,
          ),
        );
        handle.dispose();
      });

      testWidgets('anlamsal: etkin düğme etiketli, dokunulabilir', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          testApp(make(label: 'Kaydet', onPressed: () {})),
        );
        expect(
          tester.getSemantics(find.byType(NzButton)),
          matchesSemantics(
            label: 'Kaydet',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            isFocusable: true,
            hasTapAction: true,
          ),
        );
        handle.dispose();
      });

      testWidgets('dokunma alanı her boyutta >= 48', (tester) async {
        for (final size in NzSize.values) {
          await tester.pumpWidget(
            testApp(
              Center(
                child: make(label: 'K', onPressed: () {}, size: size),
              ),
            ),
          );
          final box = tester.getSize(find.byType(NzButton));
          expect(box.height, greaterThanOrEqualTo(NizamioSpacing.space12));
          expect(box.width, greaterThanOrEqualTo(NizamioSpacing.space12));
        }
      });

      testWidgets('icon: ikon çizilir; loading ikonun yerini gösterge alır', (
        tester,
      ) async {
        await tester.pumpWidget(
          testApp(make(label: 'Ekle', onPressed: () {}, icon: Icons.add)),
        );
        expect(find.byIcon(Icons.add), findsOneWidget);
        await tester.pumpWidget(
          testApp(
            make(
              label: 'Ekle',
              onPressed: () {},
              icon: Icons.add,
              loading: true,
            ),
          ),
        );
        expect(find.byIcon(Icons.add), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('expand: üst kısıt genişliğini kaplar; varsayılan kaplamaz', (
        tester,
      ) async {
        await tester.pumpWidget(
          testApp(
            Align(
              alignment: Alignment.topLeft,
              child: make(label: 'K', onPressed: () {}, expand: true),
            ),
          ),
        );
        expect(tester.getSize(find.byType(NzButton)).width, 800);
        await tester.pumpWidget(
          testApp(
            Align(
              alignment: Alignment.topLeft,
              child: make(label: 'K', onPressed: () {}),
            ),
          ),
        );
        expect(tester.getSize(find.byType(NzButton)).width, lessThan(400));
      });

      testWidgets('metin ölçeği 2.0: taşma yok, uzun etiket sarılır', (
        tester,
      ) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: testApp(
              SizedBox(
                width: 200,
                child: make(
                  label: 'Çok uzun bir düğme etiketi',
                  onPressed: () {},
                  icon: Icons.add,
                  expand: true,
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      });
    });
  }

  testWidgets('varyantlar farklı çizilir: dolgu rengi rolden', (tester) async {
    final expected = {
      'primary': NizamioColors.light.primary,
      'danger': NizamioColors.light.danger,
    };
    for (final name in expected.keys) {
      await tester.pumpWidget(
        testApp(_makers[name]!(label: 'K', onPressed: () {})),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(
        button.style!.backgroundColor!.resolve(<WidgetState>{}),
        expected[name],
        reason: name,
      );
    }
    await tester.pumpWidget(
      testApp(NzButton.secondary(label: 'K', onPressed: () {})),
    );
    expect(find.byType(OutlinedButton), findsOneWidget);
    await tester.pumpWidget(
      testApp(NzButton.ghost(label: 'K', onPressed: () {})),
    );
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('piksel: tabaka 1024 geniş, dolgu renkleri', (tester) async {
    await pumpSheet(tester, _variants);
    await expectSheetPixels(tester, [
      NizamioColors.light.primary,
      NizamioColors.light.danger,
      NizamioColors.light.border,
      NizamioColors.dark.primary,
      NizamioColors.dark.danger,
      NizamioColors.dark.border,
    ]);
  });

  goldenTestWidgets(
    'golden: bütün varyantlar × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_button.png'),
      );
    },
  );
}
