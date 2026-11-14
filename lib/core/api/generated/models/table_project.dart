// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_project_space.dart';

part 'table_project.freezed.dart';
part 'table_project.g.dart';

/// Tablo düzenleme grubu (TABLES-K13); organizasyon grubu değildir ve erişim vermez.
@Freezed()
abstract class TableProject with _$TableProject {
  const factory TableProject({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    @JsonKey(name: 'program_id') required String programId,

    /// Kişisel alanda boş metin.
    @JsonKey(name: 'department_id') required String departmentId,
    required TableProjectSpace space,
  }) = _TableProject;

  factory TableProject.fromJson(Map<String, Object?> json) =>
      _$TableProjectFromJson(json);
}
