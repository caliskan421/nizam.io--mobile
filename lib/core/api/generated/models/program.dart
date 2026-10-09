// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'program.freezed.dart';
part 'program.g.dart';

@Freezed()
abstract class Program with _$Program {
  const factory Program({
    @JsonKey(name: 'program_id') required String programId,
    required String name,
    int? year,
    String? description,

    /// Yalnız oluşturma yanıtında; yeni kayıt açıldıysa `true`.
    bool? created,
  }) = _Program;

  factory Program.fromJson(Map<String, Object?> json) =>
      _$ProgramFromJson(json);
}
