// swagger_parser `oneOf` dallarının hepsi skaler/dizi (nesne ya da `$ref` olmayan) bir bileşen
// şemasını (ör. `TableCellValue`: string | number | boolean | string[]) alansız boş bir freezed
// sınıfına çevirir; `fromJson` nesne beklediği için tel değeri (`"metin"`, `12`, `true`) çözülemez.
// Üretimden önce böyle bir bileşene giden her `$ref`, tipsiz şemayla (yalnız `description` +
// `nullable`) yer değiştirir ve bileşen silinir: alan Dart'ta `Object?` (ham JSON değeri) olur.
// Tel biçimi değişmez; tip denetimi ve dönüşüm data katmanındaki eşleyicinin işidir. `null`
// bu değerlerde anlamlıdır (boş hücre): build.yaml `include_if_null: false` zorunlu alanı
// gövdeden düşürür (sunucu eksik alanı 422 sayar); bu yüzden böyle bir zorunlu alan
// [keepNullRawFields] ile `includeIfNull: true` alır. Ayırıcılı
// nesne birlikleri (`discriminator` + `$ref` dalları, ör. `TableCommand`) bu kurala girmez.
// Böyle bir bileşen yoksa metin olduğu gibi döner (üretim bugünküyle aynı kalır).
import 'dart:convert';

import 'package:yaml/yaml.dart';

/// Skaler birlik bileşenleri satır içine alınmış spec metni (JSON — YAML'ın alt kümesi),
/// satır içine alınan bileşen adları ve onlara başvuran özellik adları (tel adı). Yoksa
/// ([specText], boş, boş).
(String, List<String>, Set<String>) inlineScalarUnions(String specText) {
  final spec = _plain(loadYaml(specText));
  if (spec is! Map<String, Object?>) return (specText, const [], const {});
  final schemas =
      (spec['components'] as Map<String, Object?>?)?['schemas']
          as Map<String, Object?>?;
  if (schemas == null) return (specText, const [], const {});
  final unions = <String, Map<String, Object?>>{};
  for (final MapEntry(:key, :value) in schemas.entries) {
    if (value is Map<String, Object?> && _scalarUnion(value)) {
      unions[key] = {
        if (value['description'] != null) 'description': value['description'],
        'nullable': true,
      };
    }
  }
  if (unions.isEmpty) return (specText, const [], const {});
  unions.keys.forEach(schemas.remove);
  final props = <String>{};
  final out = _replaceRefs(spec, unions, props);
  return (
    const JsonEncoder.withIndent(' ').convert(out),
    unions.keys.toList(),
    props,
  );
}

/// Üretilmiş model kaynağında [props] adlı ZORUNLU ham JSON alanına (`required dynamic`)
/// `@JsonKey(includeIfNull: true)` ekler (tel adı Dart adından farklıysa mevcut `@JsonKey`
/// birleşir). Böyle alan yoksa kaynak aynen döner.
String keepNullRawFields(String src, Set<String> props) {
  var out = src;
  for (final prop in props) {
    final dart = _camel(prop);
    out = out
        .replaceAll(
          "@JsonKey(name: '$prop') required dynamic $dart,",
          "@JsonKey(name: '$prop', includeIfNull: true) required dynamic $dart,",
        )
        .replaceAllMapped(
          RegExp('(^|\n)(\\s*)required dynamic $dart,'),
          (m) =>
              '${m[1]}${m[2]}@JsonKey(includeIfNull: true) required dynamic $dart,',
        );
  }
  return out;
}

String _camel(String s) {
  final parts = s.split(RegExp('[_-]')).where((p) => p.isNotEmpty).toList();
  return [
    parts.first,
    for (final p in parts.skip(1)) p[0].toUpperCase() + p.substring(1),
  ].join();
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

Object? _replaceRefs(
  Object? node,
  Map<String, Map<String, Object?>> unions,
  Set<String> props, [
  String? key,
]) {
  if (node is List) {
    return [for (final e in node) _replaceRefs(e, unions, props)];
  }
  if (node is! Map<String, Object?>) return node;
  final ref = node[r'$ref'];
  if (ref is String && ref.startsWith('#/components/schemas/')) {
    final name = ref.substring('#/components/schemas/'.length);
    final inline = unions[name];
    if (inline != null) {
      if (key != null) props.add(key);
      return {...inline};
    }
  }
  return {
    for (final MapEntry(key: k, :value) in node.entries)
      k: _replaceRefs(value, unions, props, k),
  };
}

Object? _plain(Object? y) => switch (y) {
  final YamlMap m => {
    for (final e in m.entries) e.key.toString(): _plain(e.value),
  },
  final YamlList l => [for (final e in l) _plain(e)],
  _ => y,
};
