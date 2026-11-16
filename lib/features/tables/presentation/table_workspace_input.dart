import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_loader.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../application/table_reference_choices.dart';
import '../domain/table_document.dart';
import '../domain/table_value_validation.dart';
import '../domain/table_workspace.dart';
import 'table_choice_row.dart';
import 'table_file_reference_input.dart';

class TableWorkspaceInput extends ConsumerWidget {
  const TableWorkspaceInput({
    super.key,
    required this.column,
    required this.value,
    required this.onChanged,
    this.department = '',
  });
  final TableColumnState column;
  final Object? value;
  final ValueChanged<Object?> onChanged;
  final String department;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final field = column.field;
    final label = field.name;
    final referenceQuery = (type: field.type, department: department);
    if (column.wireType == 'file_reference') {
      return TableFileReferenceInput(
        value: value,
        multiple: column.multiple,
        onChanged: onChanged,
      );
    }
    if (field.type == TableFieldType.todo) {
      return NzFormRows(
        rows: [
          NzFormRow.toggle(
            label: label,
            value: value == true,
            onChanged: onChanged,
          ),
        ],
      );
    }
    if ([
      TableFieldType.person,
      TableFieldType.unit,
      TableFieldType.task,
      TableFieldType.link,
      TableFieldType.file,
    ].contains(field.type)) {
      final candidates = ref.watch(
        tableReferenceChoicesProvider(referenceQuery),
      );
      return candidates.when(
        loading: () => const Center(child: NzLoader()),
        error: (e, _) => Column(
          children: [
            const Text('Seçenekler yüklenemedi.'),
            NzButton.ghost(
              onPressed: () =>
                  ref.invalidate(tableReferenceChoicesProvider(referenceQuery)),
              label: 'Yeniden dene',
            ),
          ],
        ),
        data: (choices) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (choices.isEmpty) const Text('Görünür kayıt bulunamadı.'),
            if (column.multiple)
              for (final c in choices.entries)
                TableChoiceRow(
                  label: c.value,
                  value:
                      value is List && (value! as List).contains(c.key.value),
                  onChanged: (selected) {
                    final values = value is List
                        ? List<Object?>.of(value! as List)
                        : <Object?>[];
                    values.removeWhere((v) => v == null || v == c.key.value);
                    if (selected) values.add(c.key.value);
                    onChanged(values.isEmpty ? null : values);
                  },
                )
            else
              NzSelect<String>(
                label: label,
                value:
                    value is String &&
                        choices.containsKey(TableStepId(value! as String))
                    ? value! as String
                    : null,
                items: [
                  const NzSelectItem(value: '', label: 'Boş'),
                  for (final c in choices.entries)
                    NzSelectItem(value: c.key.value, label: c.value),
                ],
                onChanged: (v) => onChanged(v == '' ? null : v),
              ),
          ],
        ),
      );
    }
    if (field.type == TableFieldType.date) {
      final selected = DateTime.tryParse('$value');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NzButton.ghost(
            label: selected == null
                ? 'Tarih seç'
                : '${selected.day}.${selected.month}.${selected.year}',
            onPressed: () async {
              final date = await showNzDateSheet(
                context,
                title: label,
                initial: selected,
              );
              if (date != null && context.mounted) {
                onChanged(
                  '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                );
              }
            },
          ),
          if (value != null)
            NzButton.ghost(
              onPressed: () => onChanged(null),
              label: 'Tarihi temizle',
            ),
        ],
      );
    }
    return _TableScalarInput(
      column: column,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _TableScalarInput extends StatefulWidget {
  const _TableScalarInput({
    required this.column,
    required this.value,
    required this.onChanged,
  });
  final TableColumnState column;
  final Object? value;
  final ValueChanged<Object?> onChanged;
  @override
  State<_TableScalarInput> createState() => _TableScalarInputState();
}

class _TableScalarInputState extends State<_TableScalarInput> {
  late final _text = TextEditingController(
    text: widget.value?.toString() ?? '',
  );
  @override
  void initState() {
    super.initState();
    _text.addListener(_update);
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    _text.removeListener(_update);
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.column.field.type;
    void changed(String value) => widget.onChanged(
      value.isEmpty
          ? null
          : type == TableFieldType.number
          ? TableDecimal(value.trim().replaceAll(',', '.'))
          : [TableFieldType.email, TableFieldType.phone].contains(type)
          ? value.trim()
          : value,
    );
    final value = _text.text.trim();
    final issue = tableValueIssue(
      type,
      value.isEmpty
          ? null
          : type == TableFieldType.number
          ? TableDecimal(value.replaceAll(',', '.'))
          : [TableFieldType.email, TableFieldType.phone].contains(type)
          ? value.trim()
          : value,
    );
    Widget decorate(Widget field) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        field,
        if (issue != null)
          Semantics(
            liveRegion: true,
            child: Text(
              switch (issue) {
                TableValueIssue.email =>
                  'Geçerli bir e-posta adresi gir (ör. ad@ornek.com).',
                TableValueIssue.phone => '7–15 rakam içeren bir telefon numarası gir. Başta +, boşluk, tire ve parantez kullanabilirsin.',
                TableValueIssue.number => 'Geçerli bir sayı gir.',
                TableValueIssue.date => 'Geçerli bir tarih gir.',
              },
              style: context.text.caption.copyWith(
                color: context.colors.danger,
              ),
            ),
          ),
      ],
    );
    if (type == TableFieldType.email) {
      return decorate(
        NzTextField.email(
          invalid: issue != null,
          pill: true,
          labelAbove: false,
          label: widget.column.field.name,
          controller: _text,
          hint: 'Değer gir',
          onChanged: changed,
        ),
      );
    }
    return decorate(
      NzTextField(
        invalid: issue != null,
        pill: true,
        labelAbove: false,
        label: widget.column.field.name,
        controller: _text,
        hint: 'Değer gir',
        keyboardType: type == TableFieldType.number
            ? const TextInputType.numberWithOptions(signed: true, decimal: true)
            : type == TableFieldType.phone
            ? TextInputType.phone
            : TextInputType.text,
        onChanged: changed,
      ),
    );
  }
}
