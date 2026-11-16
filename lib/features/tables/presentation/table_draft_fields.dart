import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_tap.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_reference_choices.dart';
import '../domain/table_document.dart';
import '../domain/table_workspace.dart';
import 'table_design.dart';
import 'table_grid_value.dart';
import 'table_sheet_host.dart';
import 'table_workspace_forms.dart';
import 'table_workspace_input.dart';

class TableDraftFields extends ConsumerWidget {
  const TableDraftFields({
    super.key,
    required this.id,
    required this.data,
    required this.values,
    required this.onChanged,
    this.onAttachment,
    this.attachments = const {},
  });
  final String id;
  final TableWorkspace data;
  final Map<TableFieldId, Object?> values;
  final void Function(TableFieldId, Object?) onChanged;
  final Future<void> Function(TableColumnState)? onAttachment;
  final Map<TableFieldId, String> attachments;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final first = data.columns
        .where((c) => c.field.type == TableFieldType.text)
        .firstOrNull;
    String display(TableColumnState c) {
      final value = values[TableFieldId(c.field.id)];
      if (attachments[TableFieldId(c.field.id)] case final name?) return name;
      if (value == null) {
        return c.field.type == TableFieldType.date
            ? 'gg.aa.yyyy'
            : c.field.type == TableFieldType.file
            ? 'Ekle'
            : 'Seç';
      }
      if (c.wireType.endsWith('_reference')) {
        final labels = ref
            .watch(
              tableReferenceChoicesProvider((
                type: c.field.type,
                department: data.document.unit,
              )),
            )
            .value;
        final ids = value is List ? value.whereType<String>() : ['$value'];
        return ids.map((id) => labels?[TableStepId(id)] ?? 'Seçili').join(', ');
      }
      return '$value';
    }

    Future<void> pick(TableColumnState c) async {
      if (c.wireType == 'attachment') {
        await onAttachment?.call(c);
        return;
      }
      if (c.field.type == TableFieldType.date) {
        final date = await showNzDateSheet(
          context,
          title: c.field.name,
          initial: DateTime.tryParse('${values[TableFieldId(c.field.id)]}'),
        );
        if (date != null && context.mounted) {
          onChanged(
            TableFieldId(c.field.id),
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          );
        }
        return;
      }
      await showTableSheet(
        ref,
        context,
        tableId: id,
        title: c.field.name,
        headerAction: Builder(
          builder: (sheet) => TableDesignButton(
            label: 'Bitti',
            kind: TableButtonKind.plain,
            onPressed: () => Navigator.of(sheet).pop(),
          ),
        ),
        builder: (_) => _DraftPicker(
          column: c,
          department: data.document.unit,
          value: values[TableFieldId(c.field.id)],
          onChanged: (v) => onChanged(TableFieldId(c.field.id), v),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (first != null) ...[
          TableTitleInput(
            value: '${values[TableFieldId(first.field.id)] ?? ''}',
            hint: '${first.field.name} · ne eklemek istiyorsun?',
            label: first.field.name,
            onChanged: (v) =>
                onChanged(TableFieldId(first.field.id), v.isEmpty ? null : v),
          ),
          const Gap(16),
        ],
        if (data.columns.any((c) => c != first))
          TableDesignCard(
            child: NzFormRows(
              rows: [
                for (final c in data.columns.where((c) => c != first))
                  c.field.type == TableFieldType.todo
                      ? NzFormRow.toggle(
                          label: c.field.name,
                          leading: tableFieldGlyph(context, c.field.type),
                          value: values[TableFieldId(c.field.id)] == true,
                          onChanged: (v) =>
                              onChanged(TableFieldId(c.field.id), v),
                        )
                      : c.field.type == TableFieldType.date
                      ? NzFormRow.custom(
                          label: c.field.name,
                          leading: tableFieldGlyph(context, c.field.type),
                          trailing: NzTap(
                            onTap: () => tableUiAction(context, () => pick(c)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  display(c),
                                  style: context.text.bodyMd.copyWith(
                                    color: context.colors.textMuted,
                                  ),
                                ),
                                const Gap(6),
                                const NzIcon(NzIcons.calendar, size: 16),
                              ],
                            ),
                          ),
                        )
                      : NzFormRow(
                          label: c.field.name,
                          leading: tableFieldGlyph(context, c.field.type),
                          value: display(c),
                          valueSet:
                              values[TableFieldId(c.field.id)] != null ||
                              attachments.containsKey(TableFieldId(c.field.id)),
                          onTap: () => tableUiAction(context, () => pick(c)),
                        ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DraftPicker extends StatefulWidget {
  const _DraftPicker({
    required this.column,
    required this.department,
    required this.value,
    required this.onChanged,
  });
  final TableColumnState column;
  final String department;
  final Object? value;
  final ValueChanged<Object?> onChanged;
  @override
  State<_DraftPicker> createState() => _DraftPickerState();
}

class _DraftPickerState extends State<_DraftPicker> {
  late Object? value = widget.value;
  @override
  Widget build(BuildContext context) => TableWorkspaceInput(
    column: widget.column,
    department: widget.department,
    value: value,
    onChanged: (v) {
      setState(() => value = v);
      widget.onChanged(v);
    },
  );
}
