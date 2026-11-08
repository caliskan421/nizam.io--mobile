// swagger_parser satır içi (inline) nesne şemasını ÖZELLİK adından adlandırır (`department` →
// `Department`) ve aynı adlı bileşen şemasının (`components.schemas.Department`) dosyasını
// sessizce ezer (v0.11 `ChatRefSummary.department`). Üretimden önce, bileşen adıyla çakışan
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
  final moved = <String>[];
  for (final parent in schemas.keys.toList()) {
    final schema = schemas[parent];
    if (schema is! Map<String, Object?>) continue;
    final props = schema['properties'];
    if (props is! Map<String, Object?>) continue;
    for (final key in props.keys.toList()) {
      final v = props[key];
      if (v is! Map<String, Object?> || !_inlineObject(v)) continue;
      if (!schemas.containsKey(_pascal(key))) continue;
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
