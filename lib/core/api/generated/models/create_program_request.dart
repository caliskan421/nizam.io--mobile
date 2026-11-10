// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_program_request_color.dart';

part 'create_program_request.freezed.dart';
part 'create_program_request.g.dart';

@Freezed()
abstract class CreateProgramRequest with _$CreateProgramRequest {
  const factory CreateProgramRequest({
    required String name,
    int? year,
    String? description,

    /// İsteğe bağlı kısa ad (PROGRAM-K46): baştaki/sondaki boşluk kırpıldıktan SONRA 1–4 Unicode harf ya da rakam olmalıdır (ham değerin uzunluğu sınırlanmaz; ör. `" ABCD "` geçerlidir ve `ABCD` yazılır); harf büyüklüğü korunur. Yok ya da `null` = verilmemiş. Kural dışı değer `422 program.input_invalid` (`program.invalid_short_name`).
    @JsonKey(name: 'short_name') String? shortName,

    /// İsteğe bağlı palet anahtarı (birebir). Yok ya da `null` = verilmemiş; başka değer `422 program.input_invalid` (`program.invalid_color`).
    CreateProgramRequestColor? color,
  }) = _CreateProgramRequest;

  factory CreateProgramRequest.fromJson(Map<String, Object?> json) =>
      _$CreateProgramRequestFromJson(json);
}
