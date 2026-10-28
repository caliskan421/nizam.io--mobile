import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
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
}
