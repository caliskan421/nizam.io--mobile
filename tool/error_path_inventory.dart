// Kullanım:
//   dart run tool/error_path_inventory.dart          → docs/yurutme/hata-takibi-kapsam.md'yi yazar
//   dart run tool/error_path_inventory.dart --check  → dosya güncel değilse 1 döner
//
// Envanter KAYNAKTAN üretilir (elle yazılmaz): her catch/onError/catchError/handleError/
// AsyncValue.guard/AsyncError/ham Dio yolu için dosya + işlev + tür + sahip. Satır numarası
// yoktur; bu yüzden yalnız bir yolun sahibi ya da sayısı değişince dosya değişir.
import 'dart:io';

import 'error_path_exceptions.dart';
import 'error_paths.dart';

String render(Map<String, String> sources) {
  final entries = <ErrorPathEntry>[];
  for (final MapEntry(key: rel, value: src) in sources.entries) {
    checkErrorPaths(rel, src, inventory: entries);
  }
  final rows = <String, int>{};
  for (final e in entries) {
    final key = '${e.path}|${e.enclosing}|${e.kind}|${e.owner}';
    rows[key] = (rows[key] ?? 0) + 1;
  }
  final byOwner = <String, int>{};
  for (final e in entries) {
    byOwner[e.owner] = (byOwner[e.owner] ?? 0) + 1;
  }
  final sortedRows = rows.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  final b = StringBuffer()
    ..writeln('# Hata takibi — hata yolu envanteri ve kapsam')
    ..writeln()
    ..writeln(
      '> ÜRETİLMİŞTİR — elle düzenlenmez. `dart run tool/error_path_inventory.dart` ile '
      'yeniden yazılır; `--check` (test/tool/error_paths_test.dart) güncel olduğunu doğrular.',
    )
    ..writeln()
    ..writeln(
      'Kapsam kapısı (`tool/error_paths.dart`, `make boundaries`): `lib/` altındaki her el '
      'yazımı Dart dosyasında hatayı yutan ya da başka hataya çeviren yol, **rapor cephesine** '
      '(`reportUnexpected` / `toReportedApiError` / `reportApiFailure` / `streamApiError`) '
      'YAKALANAN hata değişkeniyle, HATA konumunda ve `catch` GİRİŞİNDE koşulsuz (önceki '
      '`return`/`if`-çıkışı, `if`, `?:`, `&&`, kapanış olmadan) bağlanmak, girişte koşulsuz '
      '**iletilmek**, aynı dosyada `implements ExpectedFailure` taşıyan beklenen bir sınıf olmak '
      'ya da aşağıdaki **istisna** tablosunda gerekçeli durmak zorundadır. `on ApiError` ve özel '
      '(`_`) sınıflar tür adıyla muaf DEĞİLDİR; ApiError de politika yardımcısından geçer. '
      'Rapor cephesi adlarını yerel olarak yeniden bildirmek (gölgeleme) E6 ihlalidir. '
      'Üretilmiş dosyalar ve `core/telemetry`, `app/telemetry` (raporlayıcı kendi hatasını '
      'raporlayamaz: döngü) ölçüt dışıdır.',
    )
    ..writeln()
    ..writeln('## Sahip dağılımı')
    ..writeln()
    ..writeln('| Sahip | Yol sayısı |')
    ..writeln('|---|---|');
  for (final o in byOwner.keys.toList()..sort()) {
    b.writeln('| $o | ${byOwner[o]} |');
  }
  b
    ..writeln()
    ..writeln(
      'Sahip anlamları: `rapor` = hata çevrilmeden/yutulmadan ÖNCE sınıflandırılıp raporlanır '
      '(beklenen sınıflar süzülür); `iletilir` = `rethrow`/aynı hata yeniden fırlatılır '
      '(üst sınır raporlar); `denetim akışı` = aynı dosyadaki `ExpectedFailure` işaretli beklenen '
      'sonuç sınıfı; `istisna` = aşağıdaki gerekçe.',
    )
    ..writeln()
    ..writeln(
      'Küresel ağlar (yutulmayan ya da kaçan hatalar için): `FlutterError.onError` '
      '(`framework`), `PlatformDispatcher.onError` (`uncaught`), Riverpod '
      '`ErrorReportingProviderObserver` (`provider`; `AsyncError` durumları, `AsyncValue.guard`, '
      'build/stream hataları). Küresel kaynaklarda işlem **bilinmez**: `op=none` yazılır, '
      'sahte atıf yapılmaz.',
    )
    ..writeln()
    ..writeln('## İstisnalar (her biri gerekçeli, sayısı sınırlı)')
    ..writeln()
    ..writeln('| Anahtar (`dosya::işlev#tür`) | En çok | Gerekçe |')
    ..writeln('|---|---|---|');
  for (final k in errorPathExceptions.keys.toList()..sort()) {
    final e = errorPathExceptions[k]!;
    b.writeln('| `$k` | ${e.max} | ${e.reason.replaceAll('|', '/')} |');
  }
  b
    ..writeln()
    ..writeln('## Tüm yollar (dosya → işlev → tür → sahip)')
    ..writeln()
    ..writeln('| Dosya | İşlev | Tür | Sahip | Adet |')
    ..writeln('|---|---|---|---|---|');
  for (final r in sortedRows) {
    final p = r.key.split('|');
    b.writeln('| `${p[0]}` | `${p[1]}` | ${p[2]} | ${p[3]} | ${r.value} |');
  }
  return b.toString();
}

Map<String, String> readLib() {
  final out = <String, String>{};
  final files =
      Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    out[f.path.replaceAll(r'\', '/').substring('lib/'.length)] = f
        .readAsStringSync();
  }
  return out;
}

const docPath = 'docs/yurutme/hata-takibi-kapsam.md';

void main(List<String> args) {
  final text = render(readLib());
  final file = File(docPath);
  if (args.contains('--check')) {
    if (!file.existsSync() || file.readAsStringSync() != text) {
      stderr.writeln(
        'error_path_inventory: $docPath güncel değil '
        '(dart run tool/error_path_inventory.dart)',
      );
      exit(1);
    }
    stdout.writeln('error_path_inventory: güncel');
    return;
  }
  file.writeAsStringSync(text);
  stdout.writeln('error_path_inventory: yazıldı ($docPath)');
}
