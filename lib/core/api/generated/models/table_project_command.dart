// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_create_project_command.dart';
import 'table_create_project_command_kind.dart';
import 'table_delete_project_command.dart';
import 'table_delete_project_command_kind.dart';
import 'table_rename_project_command.dart';
import 'table_rename_project_command_kind.dart';

part 'table_project_command.freezed.dart';
part 'table_project_command.g.dart';

/// `kind` alanına göre ayrışan proje komutu (TABLES-K13). Kişisel proje yalnız sahibine görünür ve onun tarafından yönetilir; koordinatörlük projesini kapsam ekibi listeler, yalnız seçili departmanın güncel koordinatörü ya da şirket yöneticisi oluşturur, yeniden adlandırır ve siler (diğerleri 403 `tables.forbidden`). Silme yumuşaktır, tablo içeriğini silmez.
@Freezed(unionKey: 'kind')
sealed class TableProjectCommand with _$TableProjectCommand {
  @FreezedUnionValue('create_project')
  const factory TableProjectCommand.createProject({
    required TableCreateProjectCommandKind kind,
    required String name,
  }) = TableProjectCommandCreateProject;

  @FreezedUnionValue('rename_project')
  const factory TableProjectCommand.renameProject({
    required TableRenameProjectCommandKind kind,
    required String id,
    required String name,
  }) = TableProjectCommandRenameProject;

  @FreezedUnionValue('delete_project')
  const factory TableProjectCommand.deleteProject({
    required TableDeleteProjectCommandKind kind,
    required String id,
  }) = TableProjectCommandDeleteProject;

  factory TableProjectCommand.fromJson(Map<String, Object?> json) =>
      _$TableProjectCommandFromJson(json);
}
