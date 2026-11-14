// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_delete_project_command_kind.dart';
import 'table_project_command.dart';

part 'table_delete_project_command.freezed.dart';
part 'table_delete_project_command.g.dart';

/// Yumuşak silme; tablolar silinmez, proje bağları yanıtlarda görünmez. Silinmiş projede yalnız aynı anahtarlı silme tekrarı 200 alır.
@Freezed()
abstract class TableDeleteProjectCommand with _$TableDeleteProjectCommand {
  const factory TableDeleteProjectCommand({
    required TableDeleteProjectCommandKind kind,
    required String id,
  }) = _TableDeleteProjectCommand;

  factory TableDeleteProjectCommand.fromJson(Map<String, Object?> json) =>
      _$TableDeleteProjectCommandFromJson(json);
}
