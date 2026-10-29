import 'package:json_annotation/json_annotation.dart';

/// Sözleşmedeki gün alanı (`type: string, format: date`) ↔ `DateTime`. Tel biçimi yalnız
/// `YYYY-MM-DD`'dir; saat ve saat dilimi taşınmaz. Okumada yerel gece yarısı döner (saat
/// kayması olmasın diye UTC'ye çevrilmez). Üretilmiş modellere `tool/gen/wire_types.dart`
/// ekler; elle kullanılmaz.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(json);
    if (m == null) throw FormatException('gün alanı YYYY-MM-DD değil', json);
    return DateTime(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
  }

  @override
  String toJson(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
