// Kullanım: dart run tool/check_coverage.dart [coverage/lcov.info]  (CI ve `make coverage`)
// lcov.info'yu ayrıştırır, ADR-0003 karar 10 (Q1) dizin eşiklerini uygular; eşik altı ya da
// kapsamasız dosya varsa 1 döner. Üretilmiş dosyalar (generated/, *.g.dart, *.freezed.dart)
// hariçtir. lcov'da hiç görünmeyen eşikli dizin dosyası kapsamasız sayılır (karar 11,
// fail-closed); yalnız yönerge (import/export/part/library) içeren dosya hariç.
import 'dart:io';

/// ADR-0003 karar 10. Yalnız ADR ile değişir.
const coverageThresholds = <String, double>{
  'core': 80,
  'application': 80,
  'data': 80,
  'presentation': 60,
  'widgets': 70,
};

const _groupLabels = <String, String>{
  'core': 'lib/core/** (widgets hariç)',
  'application': 'lib/features/*/application/**',
  'data': 'lib/features/*/data/**',
  'presentation': 'lib/features/*/presentation/**',
  'widgets': 'lib/core/ui/widgets/**',
};

bool isGenerated(String rel) =>
    rel.contains('/generated/') ||
    rel.startsWith('generated/') ||
    rel.endsWith('.g.dart') ||
    rel.endsWith('.freezed.dart');

/// [rel] `lib/`e göreli yol. Eşikli grup adı ya da (eşiksiz/üretilmiş) null.
String? coverageGroup(String rel) {
  if (isGenerated(rel)) return null;
  if (rel.startsWith('core/ui/widgets/')) return 'widgets';
  if (rel.startsWith('core/')) return 'core';
  final m = RegExp(r'^features/[^/]+/(application|data|presentation)/')
      .firstMatch(rel);
  return m?.group(1);
}

/// lcov yolunu `lib/`e göreli hale getirir; lib/ dışıysa null.
String? libRelative(String sf, String root) {
  var p = sf.replaceAll(r'\', '/');
  final r = root.replaceAll(r'\', '/');
  if (p.startsWith('$r/')) p = p.substring(r.length + 1);
  if (p.startsWith('./')) p = p.substring(2);
  return p.startsWith('lib/') ? p.substring(4) : null;
}

/// lcov metni → {lib-göreli yol: {satır: isabet}} (aynı dosya tekrarlanırsa birleşir).
Map<String, Map<int, int>> parseLcov(String text, {String root = ''}) {
  final out = <String, Map<int, int>>{};
  Map<int, int>? current;
  for (final raw in text.split('\n')) {
    final line = raw.trim();
    if (line.startsWith('SF:')) {
      final rel = libRelative(line.substring(3), root);
      current = rel == null ? null : out.putIfAbsent(rel, () => {});
    } else if (line.startsWith('DA:') && current != null) {
      final parts = line.substring(3).split(',');
      if (parts.length < 2) continue;
      final no = int.tryParse(parts[0]);
      final hits = int.tryParse(parts[1]);
      if (no == null || hits == null) continue;
      current[no] = (current[no] ?? 0) + hits;
    } else if (line == 'end_of_record') {
      current = null;
    }
  }
  return out;
}

/// Yorum, boş satır ve yönergeler çıkarıldıktan sonra kalan satır sayısı.
int codeLineCount(String source) {
  var s = source.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
  s = s.replaceAll(RegExp(r'//[^\n]*'), '');
  s = s.replaceAll(
    RegExp(r'^\s*(import|export|part|library)\b[^;]*;', multiLine: true),
    '',
  );
  return s.split('\n').where((l) => l.trim().isNotEmpty).length;
}

class GroupResult {
  GroupResult(this.name);
  final String name;
  int covered = 0;
  int total = 0;
  final uncovered = <String>[];
  double? get percent => total == 0 ? null : covered * 100 / total;
  bool get belowThreshold {
    final p = percent;
    return p != null && p < coverageThresholds[name]!;
  }
}

class CoverageReport {
  final groups = {for (final g in coverageThresholds.keys) g: GroupResult(g)};
  bool get failed =>
      groups.values.any((g) => g.belowThreshold || g.uncovered.isNotEmpty);
}

/// [sources] diskteki bütün lib/ dosyaları (lib-göreli yol → içerik).
CoverageReport evaluateCoverage(
  Map<String, Map<int, int>> lcov,
  Map<String, String> sources,
) {
  final report = CoverageReport();
  for (final MapEntry(key: rel, value: lines) in lcov.entries) {
    final g = coverageGroup(rel);
    if (g == null) continue;
    final r = report.groups[g]!;
    r.total += lines.length;
    r.covered += lines.values.where((h) => h > 0).length;
  }
  for (final MapEntry(key: rel, value: src) in sources.entries) {
    final g = coverageGroup(rel);
    if (g == null || lcov.containsKey(rel)) continue;
    final n = codeLineCount(src);
    if (n == 0) continue; // yalnız yönerge/yorum
    final r = report.groups[g]!;
    r.total += n;
    r.uncovered.add(rel);
  }
  return report;
}

String formatReport(CoverageReport report) {
  final b = StringBuffer();
  for (final MapEntry(key: name, value: r) in report.groups.entries) {
    final th = coverageThresholds[name]!.toStringAsFixed(0);
    final p = r.percent;
    final head = '${_groupLabels[name]}';
    if (p == null) {
      b.writeln('  $head: dosya yok (eşik %$th geçer)');
    } else {
      final pct = p.toStringAsFixed(2).replaceAll('.', ',');
      final mark = r.belowThreshold ? 'EŞİK ALTI' : 'tamam';
      b.writeln('  $head: ${r.covered}/${r.total} %$pct (eşik %$th) $mark');
    }
    for (final f in r.uncovered) {
      b.writeln(
        '    KAPSAMASIZ (lcov\'da yok, hiçbir test yüklemiyor): lib/$f',
      );
    }
  }
  return b.toString();
}

void main(List<String> args) {
  final path = args.isNotEmpty ? args.first : 'coverage/lcov.info';
  final file = File(path);
  final lib = Directory('lib');
  if (!file.existsSync() || !lib.existsSync()) {
    stderr.writeln(
      'check_coverage: $path ya da lib/ yok '
      '(depo kökünden `flutter test --coverage` sonrası koşun)',
    );
    exit(2);
  }
  final root = Directory.current.path;
  final sources = {
    for (final f
        in lib
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart')))
      f.path.replaceAll(r'\', '/').substring('lib/'.length): f
          .readAsStringSync(),
  };
  final report = evaluateCoverage(
    parseLcov(file.readAsStringSync(), root: root),
    sources,
  );
  stdout.write('check_coverage:\n${formatReport(report)}');
  if (report.failed) {
    stderr.writeln('check_coverage: KAPI KIRMIZI');
    exit(1);
  }
  stdout.writeln('check_coverage: tamam');
}
