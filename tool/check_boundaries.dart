// Kullanım: dart run tool/check_boundaries.dart  (CI ve `make lint`)
// lib/ altındaki her .dart dosyasına tool/boundaries.dart kurallarını uygular; ihlal varsa 1 döner.
import 'dart:io';

import 'boundaries.dart';

void main() {
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
  final violations = <Violation>[];
  for (final file in files) {
    final rel = file.path.replaceAll(r'\', '/').substring('lib/'.length);
    violations.addAll(checkSource(rel, file.readAsStringSync()));
  }
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
