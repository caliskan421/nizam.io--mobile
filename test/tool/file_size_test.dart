// El yazımı Dart dosyası en çok 600 satır (CLAUDE.md "Kurallar"). Üretilmiş dosyalar ölçüt
// dışıdır. Sınırı aşan eski dosyalar [_legacy]'de bugünkü satır sayısıyla tavanlanır:
// büyüyemez; 600'e inince listeden çıkarılmalıdır (liste yalnız küçülür).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _limit = 600;

const _roots = ['lib', 'test', 'tool', 'test_integration'];

bool _generated(String path) =>
    path.contains('/generated/') ||
    path.endsWith('.g.dart') ||
    path.endsWith('.freezed.dart') ||
    path.endsWith('.gen.dart');

/// Sınırı aşan eski dosyalar → tavan (bölünene kadar). Yeni giriş eklenmez.
const _legacy = <String, int>{
  'test/support/tablet_harness.dart': 1183,
  'test/tool/boundaries_test.dart': 1055,
  'tool/boundaries.dart': 973,
  'tool/api_surface.dart': 919,
  'test/features/tasks/application/task_detail_writes_p3_test.dart': 769,
  'lib/features/tasks/application/task_detail_controller.dart': 768,
  'tool/gen/sources.dart': 900,
  'test/app/composition_test.dart': 744,
  'test/core/http/api_stack_test.dart': 766,
  'lib/features/tasks/domain/task_catalog.dart': 765,
  'lib/features/tasks/presentation/detail/detail_actions.dart': 742,
  'lib/features/timeline/presentation/chart/timeline_painters.dart': 746,
  'test/tool/gen_test.dart': 732,
  'test/tool/api_surface_test.dart': 644,
};

int _lines(File f) {
  final s = f.readAsStringSync();
  if (s.isEmpty) return 0;
  final n = '\n'.allMatches(s).length;
  return s.endsWith('\n') ? n : n + 1;
}

void main() {
  test(
    'el yazımı dosyalar $_limit satırı geçmez (eski dosyalar tavanında)',
    () {
      final problems = <String>[];
      final seen = <String>{};
      for (final root in _roots) {
        final dir = Directory(root);
        if (!dir.existsSync()) continue;
        for (final f in dir.listSync(recursive: true).whereType<File>()) {
          final path = f.path.replaceAll(r'\', '/');
          if (!path.endsWith('.dart') || _generated(path)) continue;
          final n = _lines(f);
          final cap = _legacy[path];
          if (cap != null) {
            seen.add(path);
            if (n > cap) problems.add('$path: $n > tavan $cap (büyüdü; böl)');
            if (n <= _limit) {
              problems.add('$path: $n ≤ $_limit (listeden çıkar)');
            }
          } else if (n > _limit) {
            problems.add('$path: $n > $_limit (böl)');
          }
        }
      }
      for (final path in _legacy.keys.where((p) => !seen.contains(p))) {
        problems.add('$path: dosya yok (listeden çıkar)');
      }
      expect(problems, isEmpty, reason: problems.join('\n'));
    },
  );
}
