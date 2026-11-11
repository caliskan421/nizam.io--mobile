// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'update_program_request_color.dart';

part 'update_program_request.freezed.dart';
part 'update_program_request.g.dart';

@Freezed()
abstract class UpdateProgramRequest with _$UpdateProgramRequest {
  const factory UpdateProgramRequest({
    String? name,
    int? year,
    String? description,

    /// Üç hâlli (PROGRAM-K46): alan yoksa değişmez; dizge verilirse kırpılıp doğrulanır (kırpılmış hâli 1–4 Unicode harf ya da rakam; ham uzunluk sınırlanmaz) ve yazılır; açık `null` kısa adı temizler. Boş dizge temizleme değildir: `422 program.input_invalid` (`program.invalid_short_name`).
    @JsonKey(name: 'short_name') String? shortName,

    /// Üç hâlli (PROGRAM-K46): alan yoksa değişmez; palet anahtarı (`violet`, `gold`, `blue`, `teal`, `green`, `orange`, `red`, `slate`) yazılır; açık `null` rengi temizler. Başka değer `422 program.input_invalid` (`program.invalid_color`).
    UpdateProgramRequestColor? color,
  }) = _UpdateProgramRequest;

  factory UpdateProgramRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateProgramRequestFromJson(json);
}
