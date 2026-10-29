import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';

import '../feedback/feedback_test_support.dart';

Widget _nav(
  int current,
  ValueChanged<int> onSelect, {
  VoidCallback? onAction,
}) => Scaffold(
  extendBody: true,
  body: const SizedBox.expand(),
  bottomNavigationBar: NzFloatingNav(
    currentIndex: current,
    onSelect: onSelect,
    semanticLabel: 'Ana gezinme',
    items: const [
      NzNavItem(icon: Icons.home, label: 'Ana sayfa', caption: 'bugün'),
      NzNavItem(icon: Icons.list, label: 'Görevler'),
      NzNavItem(icon: Icons.person, label: 'Profil'),
    ],
    action: NzNavAction(
      icon: Icons.smart_toy_outlined,
      semanticLabel: 'Asistana sor',
      onPressed: onAction ?? () {},
    ),
  ),
);

void main() {
  setUpFonts();

  testWidgets(
    'etkin öğe etiket + alt yazı; diğerleri yalnız ikon; seçim ve yeniden dokunma',
    (t) async {
      final picked = <int>[];
      var asked = 0;
      await t.pumpWidget(
        MaterialAppWrap(child: _nav(0, picked.add, onAction: () => asked++)),
      );
      expect(find.text('Ana sayfa'), findsOneWidget);
      expect(find.text('bugün'), findsOneWidget);
      expect(find.text('Görevler'), findsNothing);
      await t.tap(find.byIcon(Icons.list));
      await t.tap(find.byIcon(Icons.home));
      await t.tap(find.byIcon(Icons.smart_toy_outlined));
      expect(picked, [1, 0]);
      expect(asked, 1);
    },
  );

  testWidgets('etkin öğe basıldığı an tetiklenir; bırakış tekrar tetiklemez', (
    t,
  ) async {
    final picked = <int>[];
    await t.pumpWidget(MaterialAppWrap(child: _nav(0, picked.add)));
    final g = await t.startGesture(t.getCenter(find.byIcon(Icons.home)));
    await t.pump();
    expect(picked, [0], reason: 'parmak kalkmadan');
    await g.up();
    await t.pump();
    expect(picked, [0]);
    // Etkin olmayan öğe bırakınca geçer.
    final g2 = await t.startGesture(t.getCenter(find.byIcon(Icons.list)));
    await t.pump();
    expect(picked, [0]);
    await g2.up();
    await t.pump();
    expect(picked, [0, 1]);
  });

  testWidgets(
    'vurgu yeni sekmeye kayar; 360 genişlikte sığar; 2.0 metinde taşma yok',
    (t) async {
      t.view.devicePixelRatio = 1;
      t.view.physicalSize = const Size(360, 800);
      t.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(t.view.reset);
      addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
      await t.pumpWidget(MaterialAppWrap(child: _nav(0, (_) {})));
      await t.pumpWidget(MaterialAppWrap(child: _nav(1, (_) {})));
      await t.pumpAndSettle();
      expect(find.text('Görevler'), findsOneWidget);
      expect(t.takeException(), isNull);
      final action = t.getRect(find.byIcon(Icons.smart_toy_outlined));
      expect(action.right, lessThanOrEqualTo(360 - NizamioSpacing.gutter));
    },
  );

  testWidgets(
    'kapsül ve asistan camı tek BackdropGroup içinde; anahtar kurulumlar arasında sabit',
    (t) async {
      await t.pumpWidget(MaterialAppWrap(child: _nav(0, (_) {})));
      final groups = find.byType(BackdropGroup);
      expect(groups, findsOneWidget);
      final key = t.widget<BackdropGroup>(groups).backdropKey;
      expect(
        find.descendant(of: groups, matching: find.byType(BackdropFilter)),
        findsNWidgets(2),
      );
      await t.pumpWidget(MaterialAppWrap(child: _nav(1, (_) {})));
      expect(t.widget<BackdropGroup>(groups).backdropKey, same(key));
    },
  );

  testWidgets(
    'ayrılan yükseklik: kapsül + güvenli alan + space2 (ev çubuğu üstü)',
    (t) async {
      late double reserved;
      await t.pumpWidget(
        MaterialAppWrap(
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(bottom: 34)),
            child: Builder(
              builder: (context) {
                reserved = NzFloatingNav.reservedHeight(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(reserved, NizamioSize.nav + 34 + NizamioSpacing.space2);
    },
  );

  testWidgets('güvenli alan yoksa kapsül kenardan gapXl içeride', (t) async {
    late double reserved;
    await t.pumpWidget(
      MaterialAppWrap(
        child: Builder(
          builder: (context) {
            reserved = NzFloatingNav.reservedHeight(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(reserved, NizamioSize.nav + NizamioSpacing.gapXl);
  });
}

/// Scaffold'u kendisi kuran sarmalayıcı (testApp ikinci Scaffold eklemesin).
class MaterialAppWrap extends StatelessWidget {
  const MaterialAppWrap({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => testApp(child);
}
