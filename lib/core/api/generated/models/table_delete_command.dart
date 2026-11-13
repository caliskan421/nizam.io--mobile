// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_delete_command_kind.dart';

part 'table_delete_command.freezed.dart';
part 'table_delete_command.g.dart';

/// Yumuşak silme; yalnız sahip. Silinmiş tabloda yalnız aynı anahtarlı silme tekrarı 200 alır.
@Freezed()
abstract class TableDeleteCommand with _$TableDeleteCommand {
  const factory TableDeleteCommand({required TableDeleteCommandKind kind}) =
      _TableDeleteCommand;

  factory TableDeleteCommand.fromJson(Map<String, Object?> json) =>
      _$TableDeleteCommandFromJson(json);
}
