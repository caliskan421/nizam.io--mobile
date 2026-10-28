import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_icon_button.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_top_bar.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_glass.dart';

import '../feedback/feedback_test_support.dart';

Widget _bar() => CustomScrollView(
  slivers: [
    NzTopBar(
      leading: const NzBrandMark(monogram: 'N'),
      title: 'NIZAM.IO',
      subtitle: 'Uzun bir program adı ki tek satırda kesilsin diye yazıldı',
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
    ),
    SliverList.list(children: [for (var i = 0; i < 40; i++) Text('satır $i')]),
  ],
);

void main() {
  setUpFonts();

  testWidgets(
    'yapışkan cam çubuk: yükseklik 8 + 56 + üst güvenli alan; kaydırınca kalır',
    (t) async {
      await t.pumpWidget(testApp(_bar()));
      expect(find.byType(NzGlass), findsOneWidget);
      expect(
        t.getSize(find.byType(NzGlass)).height,
        NizamioSpacing.space2 + NizamioSize.appbar,
      );
      // Kaydırma sınırına dayanmadan (Android esneme efekti içeriği ölçekler).
      await t.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await t.pumpAndSettle();
      expect(find.text('satır 0'), findsNothing);
      expect(find.text('NIZAM.IO'), findsOneWidget);
      expect(t.getTopLeft(find.byType(NzGlass)).dy, 0);
    },
  );

  testWidgets('2.0 metinde taşma yok (çubuk metni sınırlı ölçekte)', (t) async {
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(360, 800);
    addTearDown(t.view.reset);
    await t.pumpWidget(testApp(_bar()));
    expect(t.takeException(), isNull);
    expect(find.bySemanticsLabel(RegExp('NIZAM.IO')), findsWidgets);
  });

  group('detail', () {
    Widget detail({String? code, String? title, VoidCallback? onBack}) =>
        CustomScrollView(
          slivers: [
            NzTopBar.detail(
              code: code,
              title: title,
              onBack: onBack,
              actions: [
                NzIconButton(
                  icon: Icons.edit_outlined,
                  semanticLabel: 'Düzenle',
                  onPressed: () {},
                ),
                NzIconButton(
                  icon: Icons.more_vert,
                  semanticLabel: 'Diğer',
                  onPressed: () {},
                ),
              ],
            ),
            SliverList.list(
              children: [for (var i = 0; i < 40; i++) Text('satır $i')],
            ),
          ],
        );

    testWidgets('mono kod soluk; geri düğmesi >= 48 ve onBack çağrılır', (
      t,
    ) async {
      var back = 0;
      await t.pumpWidget(testApp(detail(code: 'ALT-7', onBack: () => back++)));
      expect(find.byType(NzGlass), findsOneWidget);
      expect(
        t.getSize(find.byType(NzGlass)).height,
        NizamioSpacing.space2 + NizamioSize.appbar,
      );
      final code = t.widget<Text>(find.text('ALT-7'));
      expect(code.style!.color, NizamioColors.light.textMuted);
      final backBtn = find.bySemanticsLabel('Geri');
      expect(backBtn, findsOneWidget);
      final size = t.getSize(find.byType(IconButton).first);
      expect(size.height, greaterThanOrEqualTo(NizamioSpacing.space12));
      await t.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      expect(back, 1);
    });

    testWidgets('başlık biçimi: başlık okuyucuda header', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(testApp(detail(title: 'İşlem geçmişi')));
      expect(
        t.getSemantics(find.text('İşlem geçmişi')),
        matchesSemantics(label: 'İşlem geçmişi', isHeader: true),
      );
      handle.dispose();
    });

    testWidgets('onBack null → Navigator.maybePop', (t) async {
      await t.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Material(child: detail(code: 'X-1')),
                ),
              ),
              child: const Text('aç'),
            ),
          ),
        ),
      );
      await t.tap(find.text('aç'));
      await t.pumpAndSettle();
      expect(find.text('X-1'), findsOneWidget);
      await t.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await t.pumpAndSettle();
      expect(find.text('X-1'), findsNothing);
    });

    testWidgets('360 / 2.0 metinde taşma yok; koyu tema', (t) async {
      t.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
      t.view.devicePixelRatio = 1;
      t.view.physicalSize = const Size(360, 800);
      addTearDown(t.view.reset);
      await t.pumpWidget(
        testApp(
          detail(title: 'Çok uzun bir ayrıntı sayfası başlığı kesilmeli'),
          dark: true,
        ),
      );
      expect(t.takeException(), isNull);
    });
  });
}
