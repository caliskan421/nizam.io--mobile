// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file.freezed.dart';
part 'file.g.dart';

@Freezed()
abstract class File with _$File {
  const factory File({
    required String name,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'size_bytes') required int sizeBytes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _File;

  factory File.fromJson(Map<String, Object?> json) => _$FileFromJson(json);
}
