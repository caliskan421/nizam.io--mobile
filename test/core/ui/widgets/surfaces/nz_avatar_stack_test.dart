import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_avatar.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_avatar_stack.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  const names = [
    'Abdullah Ateş',
    'Ali Avcı',
    'Kadir Özbek',
    'Merve Koç',
    'Reha Koçak',
  ];

  testWidgets('en çok max avatar; fazlası +N; üst üste 8 binme', (t) async {
    await t.pumpWidget(
      testApp(const Center(child: NzAvatarStack(names: names, max: 3))),
    );
    expect(find.byType(NzAvatar), findsNWidgets(2));
    expect(find.text('+3'), findsOneWidget);
    final a = t.getRect(find.byType(NzAvatar).at(0));
    final b = t.getRect(find.byType(NzAvatar).at(1));
    expect(b.left - a.left, NzAvatarSize.sm.diameter - NzAvatarStack.overlap);
  });

  testWidgets('max sığarsa +N yok; renkli → kararlı ton', (t) async {
    await t.pumpWidget(
      testApp(
        const Center(
          child: NzAvatarStack(
            names: ['Ali Avcı', 'Kadir Özbek'],
            colored: true,
          ),
        ),
      ),
    );
    expect(find.byType(NzAvatar), findsNWidgets(2));
    expect(find.textContaining('+'), findsNothing);
    final first = t.widget<NzAvatar>(find.byType(NzAvatar).first);
    expect(first.tone, NzAvatar.toneOf('Ali Avcı'));
  });

  testWidgets('halka yüzey rengi (koyu tema); okuyucuda adlar', (t) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(
      testApp(
        const Center(child: NzAvatarStack(names: ['Ali Avcı', 'Kadir Özbek'])),
        dark: true,
      ),
    );
    await t.pumpAndSettle();
    final ring = find.byWidgetPredicate(
      (w) =>
          w is DecoratedBox &&
          (w.decoration as BoxDecoration?)?.color == NizamioColors.dark.surface,
    );
    expect(ring, findsNWidgets(2));
    expect(find.bySemanticsLabel('Ali Avcı, Kadir Özbek'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('2.0 metinde taşma yok', (t) async {
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(const Center(child: NzAvatarStack(names: names, max: 2))),
    );
    expect(t.takeException(), isNull);
  });
}
