// `POST /v1/tables/{id}/operations` komutları (backend `TableCommand`, `kind` ayırıcılı).
// Proje/taşıma/öneri komutları (`set_project`, `move_table`, `propose_*`,
// `withdraw_proposal`) proje ve öneri yüzüyle birlikte bağlanacak; burada yoktur.
import 'package:meta/meta.dart';

import 'table_models.dart';

/// Tek tablo komutu. [signature] aynı eylemin gövdesini tanımlar: işlem anahtarı defteri
/// (`RequestKeys`) aynı gövdeye aynı anahtarı verir (sonucu bilinmeyen isteğin tekrarı),
/// gövde değişirse yeni anahtar üretilir. Sunucu yükü bayt-bayt karşılaştırır (K-04).
@immutable
sealed class TableOperation {
  const TableOperation();

  String get signature;

  /// Sütun şemasını değiştiren komut mu (`expected_schema` taşır).
  bool get schemaBound => false;
}

final class RenameTable extends TableOperation {
  const RenameTable(this.name);
  final String name;
  @override
  String get signature => 'rename_table|$name';
}

final class DeleteTable extends TableOperation {
  const DeleteTable();
  @override
  String get signature => 'delete_table';
}

final class AddColumn extends TableOperation {
  const AddColumn({
    required this.name,
    required this.kind,
    required this.width,
    required this.expectedSchema,
    this.multiple = false,
  });
  final String name;
  final TableColumnKind kind;
  final int width;
  final int expectedSchema;
  final bool multiple;
  @override
  bool get schemaBound => true;
  @override
  String get signature =>
      'add_column|$name|${kind.name}|$width|$multiple|$expectedSchema';
}

final class RenameColumn extends TableOperation {
  const RenameColumn({
    required this.id,
    required this.name,
    required this.expectedSchema,
  });
  final String id;
  final String name;
  final int expectedSchema;
  @override
  bool get schemaBound => true;
  @override
  String get signature => 'rename_column|$id|$name|$expectedSchema';
}

final class ResizeColumn extends TableOperation {
  const ResizeColumn({
    required this.id,
    required this.width,
    required this.expectedSchema,
  });
  final String id;
  final int width;
  final int expectedSchema;
  @override
  bool get schemaBound => true;
  @override
  String get signature => 'resize_column|$id|$width|$expectedSchema';
}

final class DeleteColumn extends TableOperation {
  const DeleteColumn({required this.id, required this.expectedSchema});
  final String id;
  final int expectedSchema;
  @override
  bool get schemaBound => true;
  @override
  String get signature => 'delete_column|$id|$expectedSchema';
}

/// [afterId] null → başa taşır.
final class MoveColumn extends TableOperation {
  const MoveColumn({
    required this.id,
    required this.expectedSchema,
    this.afterId,
  });
  final String id;
  final String? afterId;
  final int expectedSchema;
  @override
  bool get schemaBound => true;
  @override
  String get signature => 'move_column|$id|$afterId|$expectedSchema';
}

/// Kayıplı dönüşüm 409 `tables.conversion_lossy` alır.
final class ConvertColumn extends TableOperation {
  const ConvertColumn({
    required this.id,
    required this.kind,
    required this.expectedSchema,
  });
  final String id;
  final TableColumnKind kind;
  final int expectedSchema;
  @override
  bool get schemaBound => true;
  @override
  String get signature => 'convert_column|$id|${kind.name}|$expectedSchema';
}

final class AddRow extends TableOperation {
  const AddRow();
  @override
  String get signature => 'add_row';
}

final class DeleteRow extends TableOperation {
  const DeleteRow(this.id);
  final String id;
  @override
  String get signature => 'delete_row|$id';
}

/// [afterId] null → başa taşır.
final class MoveRow extends TableOperation {
  const MoveRow({required this.id, this.afterId});
  final String id;
  final String? afterId;
  @override
  String get signature => 'move_row|$id|$afterId';
}

/// 1–100 hücre, atomik: tek bayat sürüm bütün batch'i geri alır (K-05).
final class SetCells extends TableOperation {
  SetCells(List<TableCellWrite> cells) : cells = List.unmodifiable(cells);
  final List<TableCellWrite> cells;
  @override
  String get signature => [
    'set_cells',
    for (final c in cells)
      '${c.rowId}|${c.columnId}|${c.version}|${_valueSig(c.value)}',
  ].join(';');
}

/// Kendi `set_cells` makbuzunun sırasını koşullu geri alır (K-27).
final class UndoCells extends TableOperation {
  const UndoCells(this.sequence);
  final int sequence;
  @override
  String get signature => 'undo_cells|$sequence';
}

final class GrantAccess extends TableOperation {
  const GrantAccess({required this.accountId, required this.role});
  final String accountId;
  final TableGrantRole role;
  @override
  String get signature => 'grant|$accountId|${role.name}';
}

final class RevokeAccess extends TableOperation {
  const RevokeAccess(this.accountId);
  final String accountId;
  @override
  String get signature => 'revoke|$accountId';
}

/// Koordinatörlük ekibinin rolü; null → ekip erişimi kapalı (`none`).
final class SetTeamRole extends TableOperation {
  const SetTeamRole(this.role);
  final TableGrantRole? role;
  @override
  String get signature => 'set_team_role|${role?.name}';
}

final class SetTemplate extends TableOperation {
  const SetTemplate({required this.template});
  final bool template;
  @override
  String get signature => 'set_template|$template';
}

final class AddComment extends TableOperation {
  const AddComment({required this.rowId, required this.body, this.columnId});
  final String rowId;
  final String? columnId;
  final String body;
  @override
  String get signature => 'add_comment|$rowId|$columnId|$body';
}

final class EditComment extends TableOperation {
  const EditComment({required this.id, required this.body});
  final String id;
  final String body;
  @override
  String get signature => 'edit_comment|$id|$body';
}

final class DeleteComment extends TableOperation {
  const DeleteComment(this.id);
  final String id;
  @override
  String get signature => 'delete_comment|$id';
}

String _valueSig(Object? v) => switch (v) {
  null => 'null',
  final String s => 's:$s',
  final List<Object?> l => 'l:${l.map(_valueSig).join(',')}',
  _ => '${v.runtimeType}:$v',
};
