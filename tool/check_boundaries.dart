// Kullanım: dart run tool/check_boundaries.dart  (CI ve `make lint`)
// lib/ altındaki her .dart dosyasına tool/boundaries.dart (sözdizimsel) ve tool/api_surface.dart
// (tip çözümlemeli A2/A3) kurallarını uygular; ihlal varsa 1 döner.
import 'dart:io';

import 'api_surface.dart';
import 'boundaries.dart';

Future<void> main() async {
  final lib = Directory('lib');
  if (!lib.existsSync()) {
    stderr.writeln('check_boundaries: lib/ yok (depo kökünden koşun)');
    exit(2);
  }
  final files =
      lib
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final sources = {
    for (final file in files)
      file.path.replaceAll(r'\', '/').substring('lib/'.length): file
          .readAsStringSync(),
  };
  final violations = <Violation>[
    for (final MapEntry(key: rel, value: content) in sources.entries)
      ...checkSource(rel, content),
    // A2/A3: tip çözümlemeli açık API yüzeyi.
    ...await checkApiSurface('.'),
  ];
  for (final v in violations) {
    stderr.writeln(v);
  }
  if (violations.isNotEmpty) {
    stderr.writeln(
      'check_boundaries: ${violations.length} ihlal (${files.length} dosya)',
    );
    exit(1);
  }
  stdout.writeln('check_boundaries: ${files.length} dosya, ihlal yok');
}
