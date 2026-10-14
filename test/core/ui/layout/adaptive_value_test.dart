import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/layout.dart';

void main() {
  test('tam verilen değerler sınıfa göre çözülür', () {
    const v = AdaptiveValue(compact: 1, medium: 2, expanded: 3);
    expect(v.resolve(WindowClass.compact), 1);
    expect(v.resolve(WindowClass.medium), 2);
    expect(v.resolve(WindowClass.expanded), 3);
  });

  test('eksik sınıf bir küçüğüne düşer', () {
    const noMedium = AdaptiveValue(compact: 1, expanded: 3);
    expect(noMedium.resolve(WindowClass.medium), 1);
    const onlyMedium = AdaptiveValue(compact: 1, medium: 2);
    expect(onlyMedium.resolve(WindowClass.expanded), 2);
    const onlyCompact = AdaptiveValue(compact: 1);
    expect(onlyCompact.resolve(WindowClass.expanded), 1);
  });
}
