// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_set_project_command_kind.dart';

part 'table_set_project_command.freezed.dart';
part 'table_set_project_command.g.dart';

/// Yalnız sahip. Tabloyu aynı program, alan ve departmandaki silinmemiş projeye bağlar; kişisel alanda proje de sahibin olmalıdır. Hedef uygun değilse 422 `tables.reference_unavailable`. `project_id` verilmezse tablo projeden çıkar (TABLES-K13). Proje tabloya erişim vermez.
@Freezed()
abstract class TableSetProjectCommand with _$TableSetProjectCommand {
  const factory TableSetProjectCommand({
    required TableSetProjectCommandKind kind,
    @JsonKey(name: 'project_id') String? projectId,
  }) = _TableSetProjectCommand;

  factory TableSetProjectCommand.fromJson(Map<String, Object?> json) =>
      _$TableSetProjectCommandFromJson(json);
}
