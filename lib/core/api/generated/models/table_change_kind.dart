// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum TableChangeKind {
  @JsonValue('rename_table')
  renameTable('rename_table'),
  @JsonValue('delete_table')
  deleteTable('delete_table'),
  @JsonValue('add_column')
  addColumn('add_column'),
  @JsonValue('rename_column')
  renameColumn('rename_column'),
  @JsonValue('resize_column')
  resizeColumn('resize_column'),
  @JsonValue('delete_column')
  deleteColumn('delete_column'),
  @JsonValue('move_column')
  moveColumn('move_column'),
  @JsonValue('add_row')
  addRow('add_row'),
  @JsonValue('delete_row')
  deleteRow('delete_row'),
  @JsonValue('move_row')
  moveRow('move_row'),
  @JsonValue('set_cells')
  setCells('set_cells'),
  @JsonValue('grant')
  grant('grant'),
  @JsonValue('revoke')
  revoke('revoke'),
  @JsonValue('set_team_role')
  setTeamRole('set_team_role'),
  @JsonValue('set_template')
  setTemplate('set_template'),
  @JsonValue('set_project')
  setProject('set_project'),
  @JsonValue('upload_attachment')
  uploadAttachment('upload_attachment'),
  @JsonValue('convert_column')
  convertColumn('convert_column'),
  @JsonValue('move_table')
  moveTable('move_table'),
  @JsonValue('add_comment')
  addComment('add_comment'),
  @JsonValue('edit_comment')
  editComment('edit_comment'),
  @JsonValue('delete_comment')
  deleteComment('delete_comment'),
  @JsonValue('undo_cells')
  undoCells('undo_cells'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const TableChangeKind(this.json);

  factory TableChangeKind.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<TableChangeKind> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
