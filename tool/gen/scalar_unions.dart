// swagger_parser `oneOf` dallarının hepsi skaler/dizi (nesne ya da `$ref` olmayan) bir bileşen
// şemasını (ör. `TableCellValue`: string | number | boolean | string[]) alansız boş bir freezed
// sınıfına çevirir; `fromJson` nesne beklediği için tel değeri (`"metin"`, `12`, `true`) çözülemez.
// Üretimden önce böyle bir bileşene giden her `$ref`, tipsiz şemayla (yalnız `description` +
// `nullable`) yer değiştirir ve bileşen silinir: alan Dart'ta `Object?` (ham JSON değeri) olur.
// Tel biçimi değişmez; tip denetimi ve dönüşüm data katmanındaki eşleyicinin işidir. Ayırıcılı
// nesne birlikleri (`discriminator` + `$ref` dalları, ör. `TableCommand`) bu kurala girmez.
// Böyle bir bileşen yoksa metin olduğu gibi döner (üretim bugünküyle aynı kalır).
import 'dart:convert';

import 'package:yaml/yaml.dart';

/// Skaler birlik bileşenleri satır içine alınmış spec metni (JSON — YAML'ın alt kümesi) ve
/// satır içine alınan bileşen adları. Yoksa ([specText], boş liste).
(String, List<String>) inlineScalarUnions(String specText) {
  final spec = _plain(loadYaml(specText));
  if (spec is! Map<String, Object?>) return (specText, const []);
  final schemas =
      (spec['components'] as Map<String, Object?>?)?['schemas']
          as Map<String, Object?>?;
  if (schemas == null) return (specText, const []);
  final unions = <String, Map<String, Object?>>{};
  for (final MapEntry(:key, :value) in schemas.entries) {
    if (value is Map<String, Object?> && _scalarUnion(value)) {
      unions[key] = {
        if (value['description'] != null) 'description': value['description'],
        'nullable': true,
      };
    }
  }
  if (unions.isEmpty) return (specText, const []);
  unions.keys.forEach(schemas.remove);
  final out = _replaceRefs(spec, unions);
  return (const JsonEncoder.withIndent(' ').convert(out), unions.keys.toList());
}

bool _scalarUnion(Map<String, Object?> s) {
  final branches = s['oneOf'];
  if (branches is! List || branches.isEmpty) return false;
  if (s.containsKey('discriminator') || s.containsKey('properties')) {
    return false;
  }
  return branches.every(
    (b) =>
        b is Map<String, Object?> &&
        !b.containsKey(r'$ref') &&
        b['type'] is String &&
        b['type'] != 'object',
  );
}

Object? _replaceRefs(Object? node, Map<String, Map<String, Object?>> unions) {
  if (node is List) return [for (final e in node) _replaceRefs(e, unions)];
  if (node is! Map<String, Object?>) return node;
  final ref = node[r'$ref'];
  if (ref is String && ref.startsWith('#/components/schemas/')) {
    final name = ref.substring('#/components/schemas/'.length);
    final inline = unions[name];
    if (inline != null) return {...inline};
  }
  return {
    for (final MapEntry(:key, :value) in node.entries)
      key: _replaceRefs(value, unions),
  };
}

Object? _plain(Object? y) => switch (y) {
  final YamlMap m => {
    for (final e in m.entries) e.key.toString(): _plain(e.value),
  },
  final YamlList l => [for (final e in l) _plain(e)],
  _ => y,
};
