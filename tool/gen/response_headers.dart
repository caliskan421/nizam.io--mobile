// Yanıt başlığı bildiren operasyonların istemci metotlarını `HttpResponse<T>` ile sarar
// (Codex 10 / A8: `X-Result-Truncated` okunur).
//
// swagger_parser'ın `original_http_response` ayarı global'dir (bütün metotların dönüşünü
// değiştirir; IdentityClient ve oturum yenileme yolunu kırar). Bu yüzden ayar kapalı kalır ve
// yalnız openapi'nin 2xx yanıtında [truncationHeader] bildiren operasyonları sarılır: liste
// openapi'den türetilir (elle liste yok), başlıksız operasyonların imzası değişmez.
// `HttpResponse` retrofit paketindedir; üretilmiş istemciler zaten `retrofit.dart`'ı içe aktarır.
import 'package:yaml/yaml.dart';

/// Sözleşmedeki kesilme başlığı (openapi `components/headers/ResultTruncated`).
const truncationHeader = 'X-Result-Truncated';

/// openapi'de herhangi bir 2xx yanıtında [header] bildiren operasyonların `operationId`
/// kümesi (sıralı).
List<String> operationsDeclaringHeader(
  String specText, {
  String header = truncationHeader,
}) {
  final spec = loadYaml(specText) as YamlMap;
  final paths = spec['paths'] as YamlMap;
  const methods = ['get', 'post', 'put', 'patch', 'delete'];
  final wanted = header.toLowerCase();
  final ids = <String>{};
  for (final item in paths.values) {
    for (final method in methods) {
      final op = (item as YamlMap)[method] as YamlMap?;
      if (op == null) continue;
      final responses = op['responses'] as YamlMap?;
      if (responses == null) continue;
      for (final entry in responses.entries) {
        if (!entry.key.toString().startsWith('2')) continue;
        final headers = (entry.value as YamlMap)['headers'] as YamlMap?;
        if (headers == null) continue;
        if (headers.keys.any((k) => k.toString().toLowerCase() == wanted)) {
          final id = op['operationId'] as String?;
          if (id == null) {
            throw const FormatException('spec: operationId eksik');
          }
          ids.add(id);
        }
      }
    }
  }
  return ids.toList()..sort();
}

/// [clients] (yol → kaynak) içinde [operationIds]'in her birini TAM BİR metotta bulup dönüş
/// tipini `Future<T>` → `Future<HttpResponse<T>>` yapar. Bulunamayan, birden çok eşleşen ya da
/// zaten sarılı operasyon düşer (üretici biçimi değişti: fail-closed). Diğer metotlara dokunulmaz.
Map<String, String> wrapHeaderResponses(
  Map<String, String> clients,
  Iterable<String> operationIds,
) {
  final out = Map<String, String>.of(clients);
  for (final id in operationIds) {
    final pattern = RegExp(
      '^(  Future<)(.+)(> ${RegExp.escape(id)}\\()',
      multiLine: true,
    );
    final hits = <String>[
      for (final e in out.entries)
        if (pattern.hasMatch(e.value)) e.key,
    ];
    if (hits.length != 1 || pattern.allMatches(out[hits.single]!).length != 1) {
      throw StateError(
        'istemcide $id metodu tam bir kez bulunamadı (${hits.length} dosya); '
        'tool/gen/response_headers.dart güncellenmeli',
      );
    }
    final path = hits.single;
    final match = pattern.firstMatch(out[path]!)!;
    if (match.group(2)!.startsWith('HttpResponse<')) {
      throw StateError('$id zaten HttpResponse ile sarılı');
    }
    out[path] = out[path]!.replaceFirstMapped(
      pattern,
      (m) => '${m[1]}HttpResponse<${m[2]}>${m[3]}',
    );
  }
  return out;
}
