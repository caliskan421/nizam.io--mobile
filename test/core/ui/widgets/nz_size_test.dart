import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

void main() {
  test('NzSize küçükten büyüğe sm · md · lg', () {
    expect(NzSize.values, [NzSize.sm, NzSize.md, NzSize.lg]);
  });
}
