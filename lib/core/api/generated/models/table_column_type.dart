// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// Sütun tipi; oluşturulduktan sonra değişmez (tip dönüşümü yok, TABLES-K06). `attachment` hücrede tek tablo eki kimliği ya da `null` tutar (TABLES-K15): dolu değeri yalnız ek yükleme ucu yazar, `set_cells` yalnız `null` (temizleme) kabul eder; hücre temizlenince ek emekli olur (indirilemez, nesnesi dönem temizliğine kadar saklanır). `*_reference` tipleri hedef kimliği saklar; hedefin görünürlüğü sahip modülün kuralıyla okuma anında okuyana göre karar verilir (TABLES-K07, TABLES-K14). İstemci bilinmeyen tip değerini görüntülemeden atlamalıdır (tip kümesi ekleyici genişler).
@JsonEnum()
enum TableColumnType {
  @JsonValue('text')
  text('text'),
  @JsonValue('number')
  number('number'),
  @JsonValue('phone')
  phone('phone'),
  @JsonValue('email')
  email('email'),
  @JsonValue('date')
  date('date'),
  @JsonValue('checkbox')
  checkbox('checkbox'),
  @JsonValue('table_reference')
  tableReference('table_reference'),
  @JsonValue('person_reference')
  personReference('person_reference'),
  @JsonValue('department_reference')
  departmentReference('department_reference'),
  @JsonValue('task_reference')
  taskReference('task_reference'),
  @JsonValue('file_reference')
  fileReference('file_reference'),
  @JsonValue('attachment')
  attachment('attachment'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const TableColumnType(this.json);

  factory TableColumnType.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<TableColumnType> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
