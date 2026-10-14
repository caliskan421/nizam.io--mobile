import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

void main() {
  test('NzSize küçükten büyüğe sm · md · lg', () {
    expect(NzSize.values, [NzSize.sm, NzSize.md, NzSize.lg]);
  });

  test('pick boyuta karşılık gelen değeri seçer', () {
    for (final (size, want) in [
      (NzSize.sm, 'a'),
      (NzSize.md, 'b'),
      (NzSize.lg, 'c'),
    ]) {
      expect(size.pick(sm: 'a', md: 'b', lg: 'c'), want);
    }
  });
}
