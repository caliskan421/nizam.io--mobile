// Kullanım: dart run tool/check_error_paths.dart  (make boundaries)
// lib/ altındaki her el yazımı dosyaya tool/error_paths.dart hata yolu kapsam kuralını uygular
// (E1–E4); ihlal varsa 1 döner. Kullanılmayan istisna anahtarı da ihlaldir.
import 'dart:io';

import 'error_path_exceptions.dart';
import 'error_paths.dart';

void main() {
  final lib = Directory('lib');
  if (!lib.existsSync()) {
    stderr.writeln('check_error_paths: lib/ yok (depo kökünden koşun)');
    exit(2);
  }
  final usage = <String, int>{};
  final out = <String>[];
  var files = 0;
  final paths =
      lib
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final f in paths) {
    files++;
    final rel = f.path.replaceAll(r'\', '/').substring('lib/'.length);
    for (final v in checkErrorPaths(rel, f.readAsStringSync(), usage: usage)) {
      out.add(v.toString());
    }
  }
  for (final key in errorPathExceptions.keys) {
    if (!usage.containsKey(key)) out.add('bayat istisna anahtarı: $key');
  }
  for (final line in out) {
    stderr.writeln(line);
  }
  if (out.isNotEmpty) {
    stderr.writeln('check_error_paths: ${out.length} ihlal ($files dosya)');
    exit(1);
  }
  stdout.writeln('check_error_paths: $files dosya, ihlal yok');
}
