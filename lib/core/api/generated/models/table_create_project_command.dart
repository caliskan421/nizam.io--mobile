// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_create_project_command_kind.dart';
import 'table_project_command.dart';

part 'table_create_project_command.freezed.dart';
part 'table_create_project_command.g.dart';

/// Yeni proje kimliği sunucuda üretilir ve `id` olarak döner; `id` gönderilirse 422.
@Freezed()
abstract class TableCreateProjectCommand with _$TableCreateProjectCommand {
  const factory TableCreateProjectCommand({
    required TableCreateProjectCommandKind kind,
    required String name,
  }) = _TableCreateProjectCommand;

  factory TableCreateProjectCommand.fromJson(Map<String, Object?> json) =>
      _$TableCreateProjectCommandFromJson(json);
}
