// Kullanım: dart run tool/check_test_presence.dart  (CI ve `make test-presence`)
// ADR-0003 karar 12 (Q2): service/repository/controller (presentation/controllers ve
// application/*_controller.dart)/kit bileşeni için aynı göreli yolda
// test/…/<ad>_test.dart bulunmalı; eksik varsa 1 döner. Üretilmiş dosyalar hariç.
import 'dart:io';

final _patterns = <RegExp>[
  RegExp(r'^features/[^/]+/application/[^/]+_service\.dart$'),
  RegExp(r'^features/[^/]+/data/[^/]+_repository\.dart$'),
  RegExp(r'^features/[^/]+/presentation/controllers/[^/]+\.dart$'),
  // Gerçek yerleşim (ADR-0003 karar 3: ekran/akış controller'ı `@riverpod` AsyncNotifier,
  // application katmanında): `features/<f>/application/<ad>_controller.dart` (Codex 9).
  RegExp(r'^features/[^/]+/application/[^/]+_controller\.dart$'),
  RegExp(r'^core/ui/widgets/(?:.+/)?nz_[^/]+\.dart$'),
];

bool _generated(String rel) =>
    rel.contains('/generated/') ||
    rel.endsWith('.g.dart') ||
    rel.endsWith('.freezed.dart');

/// [libFiles] lib/'e göreli yollar, [testFiles] test/'e göreli yollar.
/// Dönen: testi eksik kaynakların beklenen test yolu (`test/…`), sıralı.
List<String> missingTests(Iterable<String> libFiles, Set<String> testFiles) {
  final missing = <String>[];
  for (final rel in libFiles) {
    if (_generated(rel) || !_patterns.any((p) => p.hasMatch(rel))) continue;
    final expected =
        '${rel.substring(0, rel.length - '.dart'.length)}_test.dart';
    if (!testFiles.contains(expected)) missing.add('test/$expected');
  }
  return missing..sort();
}

Set<String> _relFiles(String dir) =>
    Directory(dir)
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path.replaceAll(r'\', '/').substring(dir.length + 1))
        .where((p) => p.endsWith('.dart'))
        .toSet();

void main() {
  if (!Directory('lib').existsSync() || !Directory('test').existsSync()) {
    stderr.writeln(
      'check_test_presence: lib/ ya da test/ yok (depo kökünden koşun)',
    );
    exit(2);
  }
  final lib = _relFiles('lib');
  final missing = missingTests(lib, _relFiles('test'));
  for (final m in missing) {
    stderr.writeln('EKSİK TEST: $m');
  }
  if (missing.isNotEmpty) {
    stderr.writeln('check_test_presence: ${missing.length} eksik test dosyası');
    exit(1);
  }
  stdout.writeln('check_test_presence: eksik test yok');
}
