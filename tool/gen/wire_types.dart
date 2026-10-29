// swagger_parser'ın iki tel tipi hatasını üretim sonrası düzeltir.
//
// 1) İkili yanıt (PDF, ZIP, dosya): swagger_parser `format: binary` yanıtı `Stream<String>` +
//    `ResponseType.stream` üretir; gövde UTF-8 olarak çözülür ve ikili veri bozulur. Bu
//    operasyonlar `Future<HttpResponse<List<int>>>` + `ResponseType.bytes` olur (başlıklar —
//    `Content-Disposition`, `Content-Type` — `HttpResponse` ile okunur).
// 2) Gün alanı (`type: string, format: date`): `DateTime` alanı json_serializable ile
//    `toIso8601String()` (`2026-11-03T00:00:00.000`) yazılır; sunucu yalnız `YYYY-MM-DD` kabul
//    eder. Bu alanlara `lib/core/api/date_only.dart` dönüştürücüsü eklenir.
//
// İki liste de openapi'den türetilir (elle liste yok).
import 'package:yaml/yaml.dart';

const _methods = ['get', 'post', 'put', 'patch', 'delete'];

/// 2xx yanıtında `format: binary` gövde bildiren operasyonların `operationId` kümesi.
Set<String> operationsWithBinaryResponse(String specText) {
  final spec = loadYaml(specText) as YamlMap;
  final ids = <String>{};
  for (final item in (spec['paths'] as YamlMap).values) {
    for (final method in _methods) {
      final op = (item as YamlMap)[method] as YamlMap?;
      final responses = op?['responses'] as YamlMap?;
      if (responses == null) continue;
      for (final entry in responses.entries) {
        if (!entry.key.toString().startsWith('2')) continue;
        final content = (entry.value as YamlMap)['content'] as YamlMap?;
        if (content == null) continue;
        for (final media in content.values) {
          final schema = (media as YamlMap)['schema'] as YamlMap?;
          if (schema?['format'] == 'binary')
            ids.add(op!['operationId'] as String);
        }
      }
    }
  }
  return ids;
}

final _streamMethod = RegExp(
  r'@DioResponseType\(ResponseType\.stream\)(\s+)Stream<String> (\w+)\(',
);

/// [ops] içindeki operasyonların istemci imzasını ikili yanıta çevirir. Kümedeki bir operasyon
/// bu dosyada `Stream<String>` olarak bulunamazsa (üretici değişti) [rewritten]'e girmez;
/// çağıran eksikleri denetler.
String rewriteBinaryResponses(
  String source,
  Set<String> ops,
  Set<String> rewritten,
) => source.replaceAllMapped(_streamMethod, (m) {
  final name = m[2]!;
  if (!ops.contains(name)) return m[0]!;
  rewritten.add(name);
  return '@DioResponseType(ResponseType.bytes)${m[1]}'
      'Future<HttpResponse<List<int>>> $name(';
});

/// Spec'te `format: date` olan özellik adları. Aynı ad başka yerde `date-time` olarak da
/// geçiyorsa (iki taraf da `DateTime` üretir) ad tek başına ayırt edici değildir → hata.
/// Biçimsiz `string` aynı adla geçebilir: Dart'ta `String` olur, dönüştürücü ona eklenmez.
Set<String> dateOnlyPropertyNames(String specText) {
  final spec = loadYaml(specText);
  final formats = <String, Set<String>>{};
  void walk(Object? node) {
    if (node is YamlMap) {
      final props = node['properties'];
      if (props is YamlMap) {
        for (final e in props.entries) {
          final v = e.value;
          if (v is YamlMap && v['type'] == 'string') {
            (formats[e.key as String] ??= {}).add('${v['format'] ?? ''}');
          }
        }
      }
      node.values.forEach(walk);
    } else if (node is YamlList) {
      node.forEach(walk);
    }
  }

  walk(spec);
  final out = <String>{};
  for (final MapEntry(:key, :value) in formats.entries) {
    if (!value.contains('date')) continue;
    if (value.contains('date-time')) {
      throw FormatException(
        'spec: $key hem format: date hem date-time — gün dönüştürücüsü ada göre eklenemez',
      );
    }
    out.add(key);
  }
  return out;
}

const dateOnlyImport = "import '../../date_only.dart';";

final _dateField = RegExp(
  r"@JsonKey\(name: '(\w+)'\)(\s+(?:required\s+)?DateTime\??\s)",
);

/// Model kaynağında [names] içindeki `DateTime` alanlarına `@DateOnlyConverter()` ekler;
/// eklenen olursa dönüştürücü içe aktarımını da ekler.
String annotateDateOnly(String source, Set<String> names) {
  var changed = false;
  final out = source.replaceAllMapped(_dateField, (m) {
    if (!names.contains(m[1])) return m[0]!;
    changed = true;
    return "@DateOnlyConverter() @JsonKey(name: '${m[1]}')${m[2]}";
  });
  if (!changed) return source;
  const anchor = "import 'package:freezed_annotation/freezed_annotation.dart';";
  if (!out.contains(anchor)) {
    throw const FormatException('model: freezed_annotation içe aktarımı yok');
  }
  return out.replaceFirst(anchor, '$anchor\n\n$dateOnlyImport');
}
