import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/layout/layout.dart';

import '../../../support/screen_matrix.dart';

Widget _probe(void Function(NzLayout) onBuild, {Key? key}) => Directionality(
  textDirection: TextDirection.ltr,
  child: Builder(
    key: key,
    builder: (context) {
      onBuild(NzLayout.of(context));
      return const SizedBox();
    },
  ),
);

void main() {
  test('pagePadding token değerleri: 16/24/32; columns 4/8/12', () {
    final c = NzLayout.fromWidth(360);
    final m = NzLayout.fromWidth(700);
    final e = NzLayout.fromWidth(1024);
    expect(c.pagePadding, NizamioSpacing.space4);
    expect(m.pagePadding, NizamioSpacing.space6);
    expect(e.pagePadding, NizamioSpacing.space8);
    expect([c.columns, m.columns, e.columns], [4, 8, 12]);
  });

  test('contentMaxWidth: form 480, okuma 720, liste 960', () {
    final l = NzLayout.fromWidth(360);
    expect(l.contentMaxWidth(NzContentWidth.form), 480);
    expect(l.contentMaxWidth(NzContentWidth.reading), 720);
    expect(l.contentMaxWidth(NzContentWidth.list), 960);
  });

  test('pick: eksik sınıf bir küçüğüne düşer', () {
    expect(NzLayout.fromWidth(360).pick(compact: 1, expanded: 3), 1);
    expect(NzLayout.fromWidth(700).pick(compact: 1, expanded: 3), 1);
    expect(NzLayout.fromWidth(1024).pick(compact: 1, expanded: 3), 3);
    expect(NzLayout.fromWidth(700).pick(compact: 1, medium: 2, expanded: 3), 2);
  });

  test('eşitlik değer tabanlı', () {
    expect(NzLayout.fromWidth(360), NzLayout.fromWidth(360));
    expect(NzLayout.fromWidth(360), isNot(NzLayout.fromWidth(700)));
  });

  testScreens('NzLayout.of matristeki boyuta göre sınıf ve değer verir', (
    tester,
    screen,
  ) async {
    late NzLayout seen;
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData.fromView(tester.view),
        child: _probe((l) => seen = l),
      ),
    );
    expect(seen.width, screen.size.width);
    expect(seen.resolvedClass, screen.windowClass);
    expect(seen.pagePadding, switch (screen.windowClass) {
      WindowClass.compact => 16,
      WindowClass.medium => 24,
      WindowClass.expanded => 32,
    });
  });

  testWidgets('klavye/inset değişiminde yeniden çizilmez; genişlikte çizilir', (
    tester,
  ) async {
    var builds = 0;
    // Aynı widget örneği: yeniden çizimi yalnız MediaQuery bağımlılığı tetikleyebilir.
    final probe = _probe((_) => builds++);
    Widget app(MediaQueryData data) => MediaQuery(data: data, child: probe);

    const base = MediaQueryData(size: Size(360, 800));
    await tester.pumpWidget(app(base));
    expect(builds, 1);

    await tester.pumpWidget(
      app(base.copyWith(viewInsets: const EdgeInsets.only(bottom: 300))),
    );
    await tester.pumpWidget(
      app(base.copyWith(padding: const EdgeInsets.only(top: 40))),
    );
    expect(builds, 1, reason: 'inset/padding yeniden çizim tetiklememeli');

    await tester.pumpWidget(app(base.copyWith(size: const Size(700, 800))));
    expect(builds, 2);
  });
}
