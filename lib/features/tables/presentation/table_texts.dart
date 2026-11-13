import '../../../core/i18n/generated/app_localizations.dart';
import '../application/table_view.dart';
import '../application/tables_list_controller.dart';
import '../domain/table_models.dart';

extension TableTexts on AppLocalizations {
  String tableKind(TableColumnKind k) => switch (k) {
    TableColumnKind.text => uiTablesText,
    TableColumnKind.number => uiTablesNumber,
    TableColumnKind.phone => uiTablesPhone,
    TableColumnKind.email => uiTablesEmail,
    TableColumnKind.date => uiTablesDate,
    TableColumnKind.checkbox => uiTablesCheckbox,
    TableColumnKind.tableReference => uiTablesLink,
    TableColumnKind.personReference => uiTablesPerson,
    TableColumnKind.departmentReference => uiTablesDepartment,
    TableColumnKind.taskReference => uiTablesTask,
    TableColumnKind.fileReference => uiTablesFile,
    TableColumnKind.attachment => uiTablesAttachmentKind,
    TableColumnKind.unknown => uiTablesText,
  };

  String tablesArea(TablesArea a) => switch (a) {
    TablesArea.coordinatorship => uiTablesCoord,
    TablesArea.personal => uiTablesPersonal,
    TablesArea.shared => uiTablesShared,
  };

  String tableSpace(TableSpace s) => switch (s) {
    TableSpace.personal => uiTablesPersonal,
    _ => uiTablesCoord,
  };

  /// Hücrenin düz metin gösterimi (boş → '—'). Referans kimliği görünen ada çevrilir;
  /// görünmeyen (redakte) öğe "Gizli" yazılır.
  String tableCellText(
    TableView view,
    TableColumnSpec column,
    TableCellData d,
  ) {
    final v = d.value;
    if (v == null || d.isEmpty) return d.redacted ? uiTablesRedacted : '—';
    String ref(Object? id) => id == null
        ? uiTablesRedacted
        : view.referenceName(column.kind, '$id') ?? '$id';
    if (column.kind.isReference) {
      return v is List ? v.map(ref).join(', ') : ref(v);
    }
    if (column.kind == TableColumnKind.attachment) {
      return view.attachments[TableAttachmentId('$v')]?.name ?? '$v';
    }
    if (column.kind == TableColumnKind.checkbox) return v == true ? '✓' : '—';
    return '$v';
  }
}
