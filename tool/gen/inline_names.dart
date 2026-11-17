// swagger_parser satır içi (inline) nesne şemasını ÖZELLİK adından adlandırır (`department` →
// `Department`) ve aynı adlı bileşen şemasının (`components.schemas.Department`) dosyasını
// sessizce ezer (v0.11 `ChatRefSummary.department`). Aynı ezme, satır içi enum sorgu/yol
// parametresinin adıyla da olur (parametre `author: [me]` → enum `Author`, `TableComment.author`
// nesnesini ezer). Üretimden önce, bileşen ya da satır içi enum parametre adıyla çakışan
// satır içi nesne özelliği `<Ebeveyn><Özellik>` adlı bileşene taşınır ve `$ref` ile bağlanır.
// Tel biçimi değişmez (özellik adı aynı); yalnız Dart sınıf adı değişir. Çakışma yoksa metin
// olduğu gibi döner (üretim bugünküyle aynı kalır). Kalıcı çözüm backend'de satır içi nesneye
// bileşen adı vermektir.
import 'dart:convert';

import 'package:yaml/yaml.dart';

/// Çakışan satır içi nesneleri bileşene taşınmış spec metni (JSON — YAML'ın alt kümesi) ve
/// taşınanların listesi (`Ebeveyn.özellik → YeniAd`). Çakışma yoksa ([specText], boş liste).
(String, List<String>) hoistCollidingInlineObjects(String specText) {
  final spec = _plain(loadYaml(specText)) as Map<String, Object?>;
  final components = spec['components'] as Map<String, Object?>?;
  final schemas = components?['schemas'] as Map<String, Object?>?;
  if (schemas == null) return (specText, const []);
  final taken = {...schemas.keys, ..._inlineEnumParameterNames(spec)};
  final moved = <String>[];
  for (final parent in schemas.keys.toList()) {
    final schema = schemas[parent];
    if (schema is! Map<String, Object?>) continue;
    final props = schema['properties'];
    if (props is! Map<String, Object?>) continue;
    for (final key in props.keys.toList()) {
      final v = props[key];
      if (v is! Map<String, Object?> || !_inlineObject(v)) continue;
      if (!taken.contains(_pascal(key))) continue;
      var name = '$parent${_pascal(key)}';
      for (var i = 2; schemas.containsKey(name); i++) {
        name = '$parent${_pascal(key)}$i';
      }
      schemas[name] = v;
      props[key] = {r'$ref': '#/components/schemas/$name'};
      moved.add('$parent.$key → $name');
    }
  }
  if (moved.isEmpty) return (specText, const []);
  return (const JsonEncoder.withIndent(' ').convert(spec), moved);
}

/// swagger_parser'ın satır içi enum parametrelerine verdiği sınıf adları (`PascalCase(ad)`).
Set<String> _inlineEnumParameterNames(Map<String, Object?> spec) {
  final out = <String>{};
  void collect(Object? params) {
    if (params is! List) return;
    for (final p in params) {
      if (p is! Map<String, Object?>) continue;
      final schema = p['schema'];
      final name = p['name'];
      if (name is String &&
          schema is Map<String, Object?> &&
          !schema.containsKey(r'$ref') &&
          schema['enum'] is List) {
        out.add(_pascal(name));
      }
    }
  }

  final paths = spec['paths'];
  if (paths is! Map<String, Object?>) return out;
  for (final item in paths.values) {
    if (item is! Map<String, Object?>) continue;
    collect(item['parameters']);
    for (final op in item.values) {
      if (op is Map<String, Object?>) collect(op['parameters']);
    }
  }
  return out;
}

bool _inlineObject(Map<String, Object?> v) =>
    v['type'] == 'object' &&
    !v.containsKey(r'$ref') &&
    v['properties'] is Map &&
    (v['properties']! as Map).isNotEmpty;

String _pascal(String s) => s
    .split(RegExp('[_-]'))
    .where((p) => p.isNotEmpty)
    .map((p) => p[0].toUpperCase() + p.substring(1))
    .join();

Object? _plain(Object? y) => switch (y) {
  final YamlMap m => {
    for (final e in m.entries) e.key.toString(): _plain(e.value),
  },
  final YamlList l => [for (final e in l) _plain(e)],
  _ => y,
};
