// U4 (MediaQuery.of/maybeOf) istisnası: yalnız tablet ölçeği dosyası; komşusu ve izinsiz koşu
// yasak kalır. Gerçek dosyada tek ihlal bu istisnadır.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/boundaries.dart';

void main() {
  const scale = 'core/ui/layout/nz_tablet_scale.dart';
  List<String> rules(String path, String src, {bool allowances = true}) => [
    for (final v in checkSource(path, src, allowances: allowances)) v.rule,
  ];

  test('izinli tek dosya: tablet ölçeği; komşusu serbest değil', () {
    const src = 'final s = MediaQuery.of(c); final m = MediaQuery.maybeOf(c);';
    expect(rules(scale, src), isEmpty);
    expect(rules('core/ui/layout/other.dart', src), ['U4', 'U4']);
    expect(rules('app/$scale', src), ['U4', 'U4']);
    expect(rules(scale, src, allowances: false), ['U4', 'U4']);
  });

  test('gerçek dosya: izin kalkınca tek U4, izinle ihlal yok', () {
    final src = File('lib/$scale').readAsStringSync();
    expect(rules(scale, src, allowances: false), ['U4']);
    expect(rules(scale, src), isEmpty);
  });
}
