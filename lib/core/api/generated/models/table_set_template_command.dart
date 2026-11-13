// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_set_template_command_kind.dart';

part 'table_set_template_command.freezed.dart';
part 'table_set_template_command.g.dart';

/// Yalnız sahip. Şablon bayrağını açar ya da kapatır (TABLES-K16). Bayrak erişim vermez; şablondan oluşturma yapı kopyasıdır (`/v1/table-copies`, `mode: structure`).
@Freezed()
abstract class TableSetTemplateCommand with _$TableSetTemplateCommand {
  const factory TableSetTemplateCommand({
    required TableSetTemplateCommandKind kind,
    required bool template,
  }) = _TableSetTemplateCommand;

  factory TableSetTemplateCommand.fromJson(Map<String, Object?> json) =>
      _$TableSetTemplateCommandFromJson(json);
}
