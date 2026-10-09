// make gen — üretilmiş bütün kodu kaynaklarından yeniden üretir (F14 kapsam 3, 7, 8).
//
// Kaynaklar YALNIZ api-pin.json'daki pinlerden okunur (çalışma ağacı okunmaz):
//   backend  : `git show refs/tags/<backendTag>:<yol>` — openapi.yaml, error-codes.json
//              (dizin: NIZAMIO_BACKEND_DIR, yoksa ../nizam.io--backend; CI'da .backend/)
//   web      : `git show <web.commit>:<yol>` — tokens.json, TR hata metinleri
//              (dizin: NIZAMIO_FRONTEND_DIR, yoksa ../nizam.io--frontend; CI'da .frontend/)
//   mobil    : i18n/client_errors.tr.json (istemci kodları), pubspec.yaml version
//
// Çıktılar (commit'lenir; CI yeniden üretip `git diff --exit-code` + porcelain boş ister):
//   lib/core/api/generated/            swagger_parser (freezed modeller + retrofit istemciler),
//                                      operations.gen.dart (operationId → kapsam sınıfı haritası),
//                                      error_catalog.gen.dart
//   lib/core/i18n/arb/app_tr.arb       TR metinler (sunucu kodları web'den, client.* mobilden)
//   lib/core/i18n/generated/           gen-l10n çıktısı, error_messages.gen.dart,
//                                      client_error_codes.gen.dart
//   lib/core/theme/generated/tokens.gen.dart
//   lib/core/config/generated/app_version.gen.dart
//   **/*.g.dart, **/*.freezed.dart     build_runner (freezed, json_serializable, retrofit, riverpod)
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'gen/emit.dart';
import 'gen/sources.dart';

Future<void> main(List<String> args) async {
  final root = Directory.current.path;
  if (!File(p.join(root, 'api-pin.json')).existsSync()) {
    fail('depo kökünden koşun (api-pin.json yok)');
  }
  final pin = jsonDecode(
    File(p.join(root, 'api-pin.json')).readAsStringSync(),
  ) as Map<String, Object?>;
  final tag = pin['backendTag']! as String;
  final web = pin['web']! as Map<String, Object?>;
  final webCommit = web['commit']! as String;
  if (!RegExp(r'^[0-9a-f]{40}$').hasMatch(webCommit)) {
    fail('web.commit tam SHA olmalı');
  }

  final backendDir = _dir('NIZAMIO_BACKEND_DIR', '../nizam.io--backend', root);
  final frontendDir = _dir(
    'NIZAMIO_FRONTEND_DIR',
    '../nizam.io--frontend',
    root,
  );

  // Kaynak çözümleme — etiket/commit yoksa düş.
  final backendCommit = await _git(
    backendDir,
    ['rev-parse', '--verify', 'refs/tags/$tag^{commit}'],
    onError:
        "'$tag' etiketi $backendDir içinde yok (git fetch --tags ya da NIZAMIO_BACKEND_DIR)",
  );
  await _git(
    frontendDir,
    ['cat-file', '-e', '$webCommit^{commit}'],
    onError:
        'web commit $webCommit $frontendDir içinde yok (git fetch ya da NIZAMIO_FRONTEND_DIR)',
  );

  final specText = await _git(backendDir, [
    'show',
    'refs/tags/$tag:${pin['specPath']}',
  ], trim: false);
  final catalogText = await _git(backendDir, [
    'show',
    'refs/tags/$tag:${pin['errorCatalogPath']}',
  ], trim: false);
  final tokensText = await _git(frontendDir, [
    'show',
    '$webCommit:${web['tokensPath']}',
  ], trim: false);
  final webTrText = await _git(frontendDir, [
    'show',
    '$webCommit:${web['trErrorsPath']}',
  ], trim: false);

  final backendSrc = 'nizam.io--backend etiket $tag ($backendCommit)';
  final webSrc = '${web['repository']} commit $webCommit';

  // 1) swagger_parser — freezed modeller + retrofit istemciler.
  final work = Directory(p.join(root, '.dart_tool', 'nizamio_gen'))
    ..createSync(recursive: true);
  final specFile = File(p.join(work.path, 'openapi.yaml'))
    ..writeAsStringSync(specText);
  final apiOut = Directory(p.join(root, 'lib/core/api/generated'));
  if (apiOut.existsSync()) apiOut.deleteSync(recursive: true);
  final config = File(p.join(work.path, 'swagger_parser.yaml'))
    ..writeAsStringSync('''
swagger_parser:
  schema_path: ${specFile.path}
  output_directory: lib/core/api/generated
  name: nizamio_api
  language: dart
  json_serializer: freezed
  use_freezed3: true
  root_client: true
  root_client_name: NizamioApi
  export_file: true
  put_clients_in_folder: true
  extras_parameter_by_default: true
  add_openapi_metadata: true
  original_http_response: false
  unknown_enum_value: true
  mark_files_as_generated: true
  # Bu başlıkları istemci ara katmanı (lib/core/http) koyar; çağıran elle vermez.
  skipped_parameters:
    - X-Requested-With
    - X-Nizamio-Program
    - X-Nizamio-Department
    - X-Nizamio-Client
    - nizamio_web_refresh
''');
  await _run('dart', ['run', 'swagger_parser', '-f', config.path], root);

  // 2) operasyon ve hata kataloğu haritaları.
  final spec = summarizeSpec(specText);
  final catalog = parseCatalog(catalogText);
  _write(
    root,
    'lib/core/api/generated/operations.gen.dart',
    emitOperations(spec, '$backendSrc — ${pin['specPath']}'),
  );
  _write(
    root,
    'lib/core/api/generated/error_catalog.gen.dart',
    emitErrorCatalog(catalog, '$backendSrc — ${pin['errorCatalogPath']}'),
  );

  // 3) TR metinler → ARB → gen-l10n; kod → metin eşlemesi; istemci kod sabitleri.
  final clientText = File(p.join(root, 'i18n/client_errors.tr.json'))
      .readAsStringSync();
  final client = parseClientErrors(clientText);
  final messages = buildTrMessages(
    catalog,
    parseWebTrErrors(webTrText),
    client,
  );
  final arbDir = Directory(p.join(root, 'lib/core/i18n/arb'))
    ..createSync(recursive: true);
  File(p.join(arbDir.path, 'app_tr.arb')).writeAsStringSync(
    buildArb(
      messages,
      'BU DOSYA ÜRETİLMİŞTİR (make gen). Sunucu kodları: $webSrc ${web['trErrorsPath']} '
      '(katalog: $backendSrc); istemci kodları: i18n/client_errors.tr.json',
    ),
  );
  final l10nOut = Directory(p.join(root, 'lib/core/i18n/generated'));
  if (l10nOut.existsSync()) l10nOut.deleteSync(recursive: true);
  await _run('flutter', ['gen-l10n'], root);
  _write(
    root,
    'lib/core/i18n/generated/error_messages.gen.dart',
    emitErrorMessages(messages, 'lib/core/i18n/arb/app_tr.arb'),
  );
  _write(
    root,
    'lib/core/i18n/generated/client_error_codes.gen.dart',
    emitClientErrorCodes(client, 'i18n/client_errors.tr.json'),
  );

  // 4) tasarım token'ları ve uygulama sürümü.
  _write(
    root,
    'lib/core/theme/generated/tokens.gen.dart',
    emitTokens(resolveTokens(tokensText), '$webSrc — ${web['tokensPath']}'),
  );
  _write(
    root,
    'lib/core/config/generated/app_version.gen.dart',
    emitAppVersion(
      appVersionFromPubspec(
        File(p.join(root, 'pubspec.yaml')).readAsStringSync(),
      ),
    ),
  );

  // 5) build_runner (freezed, json_serializable, retrofit, riverpod) ve biçim.
  await _run('dart', [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ], root);
  await _run('dart', [
    'format',
    'lib/core/api/generated',
    'lib/core/i18n/generated',
    'lib/core/theme/generated',
    'lib/core/config/generated',
  ], root);

  stdout.writeln(
    'gen: $tag (${backendCommit.substring(0, 12)}) → ${spec.operations.length} operasyon, '
    '${catalog.entries.length} hata kodu, ${messages.length} TR metin; web ${webCommit.substring(0, 12)}',
  );
}

Never fail(String message) {
  stderr.writeln('gen: $message');
  exit(1);
}

String _dir(String env, String fallback, String root) {
  final v = Platform.environment[env];
  return p.normalize(
    p.isAbsolute(v ?? fallback) ? v ?? fallback : p.join(root, v ?? fallback),
  );
}

Future<String> _git(
  String dir,
  List<String> args, {
  String? onError,
  bool trim = true,
}) async {
  final r = await Process.run('git', [
    '-C',
    dir,
    ...args,
  ], stdoutEncoding: utf8);
  if (r.exitCode != 0) fail(onError ?? 'git ${args.join(' ')}: ${r.stderr}');
  final out = r.stdout as String;
  return trim ? out.trim() : out;
}

Future<void> _run(String exe, List<String> args, String root) async {
  final proc = await Process.start(
    exe,
    args,
    workingDirectory: root,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await proc.exitCode;
  if (code != 0) fail('$exe ${args.join(' ')} → çıkış $code');
}

void _write(String root, String rel, String content) {
  File(p.join(root, rel))
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(content);
}
